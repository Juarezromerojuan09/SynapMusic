import 'package:flutter/material.dart';
import '../../services/media_state_stream.dart';
import '../../services/synap_api_service.dart';
import '../../services/synap_events.dart';
import 'package:get_it/get_it.dart';
import '../../services/audio_service_helper.dart';
import '../../models/jellyfin_models.dart';
import '../player_screen.dart';
import '../../components/track_list_item.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String albumId;

  const AlbumDetailScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  _AlbumDetailScreenState createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final SynapApiService _apiService = SynapApiService();
  bool _isLoading = true;
  Map<String, dynamic>? _albumData;
  List<dynamic> _tracks = [];
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchAlbumDetails();
  }

  Future<void> _fetchAlbumDetails() async {
    final data = await _apiService.getAlbumDetails(widget.albumId);
    if (mounted) {
      setState(() {
        if (data != null && data['album'] != null) {
          _albumData = data['album'];
          _tracks = data['tracks'] ?? [];
        }
        _isLoading = false;
      });
    }
    await _checkIfFavorite();
  }

  Future<File> _getFavoritesFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/synap_favorite_albums.json');
  }

  Future<void> _checkIfFavorite() async {
    try {
      final file = await _getFavoritesFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> favorites = json.decode(content);
        if (mounted) {
          setState(() {
            _isFavorite = favorites.any((a) => a['id'] == widget.albumId);
          });
        }
      }
    } catch (e) {
      print('Error al cargar favoritos: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    if (_albumData == null) return;
    
    try {
      final file = await _getFavoritesFile();
      List<dynamic> favorites = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        favorites = json.decode(content);
      }
      
      if (_isFavorite) {
        favorites.removeWhere((a) => a['id'] == widget.albumId);
      } else {
        favorites.add({
          'id': widget.albumId,
          'title': _albumData!['title'],
          'artist': _albumData!['artist'],
          'cover_url': _albumData!['cover_url'],
          'year': _albumData!['year']
        });
      }
      
      await file.writeAsString(json.encode(favorites));
      
      SynapEvents.fireLibraryRefresh();

      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isFavorite ? 'Álbum añadido a favoritos' : 'Álbum removido de favoritos')),
        );
      }
    } catch (e) {
      print('Error al guardar favorito: $e');
    }
  }

  void _downloadFullAlbum() {
    List<String> missingTracks = [];
    for (final track in _tracks) {
      final localMatch = track['local_match'];
      if (localMatch == null || localMatch['exists'] != true) {
        missingTracks.add(track['query_string']);
      }
    }
    
    if (missingTracks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El álbum ya está completamente descargado.')),
      );
    } else {
      _apiService.downloadMusicBulk(missingTracks);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Descargando ${missingTracks.length} pistas faltantes del álbum...')),
      );
    }
  }

  void _downloadTrack(dynamic track) {
    print('Descargando pista: ${track['spotify_url']}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Descarga de pista encolada: ${track['title']}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _albumData == null
              ? Center(child: Text('Error al cargar el álbum'))
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 300,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                          _albumData!['cover_url'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.album, size: 100),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _albumData!['title'] ?? 'Unknown Title',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_albumData!['artist'] ?? 'Unknown Artist'} • ${_albumData!['year'] ?? ''}',
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),

                            const SizedBox(height: 20),
                            // ACTION BAR
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // 1. Play
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF144477),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.play_arrow, size: 36, color: Colors.black),
                                    onPressed: () async {
                                      if (_tracks.isEmpty) return;
                                      List<BaseItemDto> availableTracks = [];
                                      for (final track in _tracks) {
                                        final lm = track['local_match'];
                                        if (lm != null && lm['exists'] == true && lm['jellyfin_data'] != null) {
                                          availableTracks.add(BaseItemDto.fromJson(lm['jellyfin_data']));
                                        }
                                      }
                                      if (availableTracks.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay pistas disponibles')));
                                        return;
                                      }
                                      await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                                        itemList: availableTracks,
                                        initialIndex: 0,
                                      );
                                      if (mounted) Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
                                    },
                                  ),
                                ),
                                // 2. Shuffle
                                IconButton(
                                  icon: const Icon(Icons.shuffle, size: 24, color: Colors.white),
                                  onPressed: () async {
                                    if (_tracks.isEmpty) return;
                                    List<BaseItemDto> availableTracks = [];
                                    for (final track in _tracks) {
                                      final lm = track['local_match'];
                                      if (lm != null && lm['exists'] == true && lm['jellyfin_data'] != null) {
                                        availableTracks.add(BaseItemDto.fromJson(lm['jellyfin_data']));
                                      }
                                    }
                                    if (availableTracks.isEmpty) return;
                                    await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                                      itemList: availableTracks,
                                      initialIndex: 0,
                                      shuffle: true,
                                    );
                                    if (mounted) Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
                                  },
                                ),
                                // 3. Favorite
                                IconButton(
                                  icon: Icon(
                                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                                    size: 24,
                                    color: _isFavorite ? Colors.red : Colors.white,
                                  ),
                                  onPressed: _toggleFavorite,
                                ),
                                // 4. Download
                                Builder(
                                  builder: (context) {
                                    bool isFullyDownloaded = _tracks.isNotEmpty && 
                                        _tracks.every((track) => track['local_match']?['exists'] == true);
                                    return IconButton(
                                      icon: Icon(
                                        Icons.download_for_offline, 
                                        size: 24, 
                                        color: isFullyDownloaded ? const Color(0xFF144477) : Colors.white,
                                      ),
                                      onPressed: _downloadFullAlbum,
                                    );
                                  }
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final track = _tracks[index];
                          final ms = track['duration_ms'] as int? ?? 0;
                          final totalSeconds = ms ~/ 1000;
                          final minutes = totalSeconds ~/ 60;
                          final seconds = totalSeconds % 60;
                          final durationStr = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

                          final localMatch = track['local_match'];
                          final bool existsLocal = localMatch != null && localMatch['exists'] == true;

                          Widget actionButton;
                          if (existsLocal) {
                            actionButton = IconButton(
                              icon: const Icon(Icons.more_vert, color: Colors.white),
                              onPressed: () {},
                            );
                          } else {
                            actionButton = IconButton(
                              icon: const Icon(Icons.download, color: Color(0xFF1DB954)),
                              onPressed: () {
                                _apiService.downloadMedia(track['query_string']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Descarga de pista encolada: ${track['title']}')),
                                );
                              },
                            );
                          }

                          final trackId = existsLocal ? track['local_match']['jellyfin_data']['Id'] : null;

                          return TrackListItem(
                            trackId: trackId,
                            title: track['title'] ?? 'Unknown Track',
                            artist: track['artist'] ?? '',
                            duration: durationStr,
                            isAvailableInServer: existsLocal,
                            trackNumber: (track['track_number'] != null && track['track_number'] != 0) ? track['track_number'] : index + 1,
                            trailingWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                actionButton,
                              ],
                            ),
                            onPlayPressed: () async {
                              try {
                                List<BaseItemDto> availableTracks = [];
                                int targetIndex = 0;
                                for (int i = 0; i < _tracks.length; i++) {
                                  final t = _tracks[i];
                                  final lm = t['local_match'];
                                  if (lm != null && lm['exists'] == true && lm['jellyfin_data'] != null) {
                                    availableTracks.add(BaseItemDto.fromJson(lm['jellyfin_data']));
                                    if (i == index) targetIndex = availableTracks.length - 1;
                                  }
                                }
                                await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                                  itemList: availableTracks,
                                  initialIndex: targetIndex,
                                );
                                if (mounted) {
                                  Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al reproducir: $e')));
                                }
                              }
                            },
                          );
                        },
                        childCount: _tracks.length,
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                  ],
                ),
    );
  }
}
