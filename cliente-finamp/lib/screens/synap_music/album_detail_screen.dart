import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/media_state_stream.dart';
import '../../services/synap_api_service.dart';
import '../../services/synap_events.dart';
import 'package:get_it/get_it.dart';
import '../../services/audio_service_helper.dart';
import '../../models/jellyfin_models.dart';
import '../player_screen.dart';
import '../../components/track_list_item.dart';
import '../../components/track_options_menu_sheet.dart';
import '../../services/playback_download_coordinator.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import '../../components/synap_fast_scroller.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String albumId;

  const AlbumDetailScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  _AlbumDetailScreenState createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final SynapApiService _apiService = SynapApiService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  Map<String, dynamic>? _albumData;
  List<dynamic> _tracks = [];
  bool _isFavorite = false;
  StreamSubscription<LocalTrackReadyEvent>? _trackReadySub;

  @override
  void initState() {
    super.initState();
    _fetchAlbumDetails();
    _trackReadySub = PlaybackDownloadCoordinator().onTrackReady.listen((event) {
      if (mounted) {
        bool updated = false;
        for (var t in _tracks) {
          final tTitle = t['title']?.toString().toLowerCase().trim() ?? '';
          final eTitle = event.title.toLowerCase().trim();
          if (tTitle == eTitle || tTitle.contains(eTitle) || eTitle.contains(tTitle)) {
            t['local_match'] = {
              'exists': true,
              'jellyfin_data': event.jellyfinItem ?? {'Id': event.localId, 'Name': event.title},
            };
            updated = true;
          }
        }
        if (updated) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _trackReadySub?.cancel();
    _scrollController.dispose();
    super.dispose();
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

  (List<BaseItemDto>, int) _getNormalizedAlbumTracks({int? selectedIndex}) {
    // 1. Discover a representative Jellyfin track item ID from tracks that match this album title
    // In flat media storage, Jellyfin stores the album cover on each track's item ID.
    String? representativeTrackItemId;
    String? representativeImageTag;
    final albumTitle = _albumData?['title']?.toString().toLowerCase().trim() ?? '';

    for (final track in _tracks) {
      final jf = track['local_match']?['jellyfin_data'];
      if (jf != null) {
        final trackAlbum = jf['Album']?.toString().toLowerCase().trim();
        final hasPrimaryImage = jf['ImageTags'] is Map && jf['ImageTags']['Primary'] != null;
        if (trackAlbum != null && trackAlbum.isNotEmpty && trackAlbum == albumTitle && hasPrimaryImage) {
          representativeTrackItemId = jf['Id']?.toString();
          representativeImageTag = jf['ImageTags']['Primary']?.toString();
          if (representativeTrackItemId != null) break;
        }
      }
    }

    // Fallback: if no track matched by exact album name, use any available track with an image
    if (representativeTrackItemId == null) {
      for (final track in _tracks) {
        final jf = track['local_match']?['jellyfin_data'];
        if (jf != null) {
          final hasPrimaryImage = jf['ImageTags'] is Map && jf['ImageTags']['Primary'] != null;
          if (hasPrimaryImage) {
            representativeTrackItemId = jf['Id']?.toString();
            representativeImageTag = jf['ImageTags']['Primary']?.toString();
            if (representativeTrackItemId != null) break;
          }
        }
      }
    }

    List<BaseItemDto> availableTracks = [];
    int targetIndex = 0;

    for (int i = 0; i < _tracks.length; i++) {
      final t = _tracks[i];
      final lm = t['local_match'];
      if (lm != null && lm['exists'] == true && lm['jellyfin_data'] != null) {
        final dto = BaseItemDto.fromJson(Map<String, dynamic>.from(lm['jellyfin_data']));

        // Normalize all tracks to the current album context so queue/player/lockscreen all show uniform album info
        if (_albumData != null) {
          dto.album = _albumData!['title'];
          dto.albumArtist = _albumData!['artist'];
        }

        // If this track's album doesn't match the current album (e.g. Overcompensate from compilation or single),
        // route its image to the representative album track so it shows the uniform album cover.
        final trackAlbum = t['local_match']?['jellyfin_data']?['Album']?.toString().toLowerCase().trim() ?? '';
        final isDifferentAlbum = trackAlbum.isNotEmpty && trackAlbum != albumTitle;

        if (isDifferentAlbum && representativeTrackItemId != null) {
          dto.imageTags?.remove('Primary');
          dto.parentPrimaryImageItemId = representativeTrackItemId;
          if (representativeImageTag != null) {
            dto.parentPrimaryImageTag = representativeImageTag;
          }
        }

        availableTracks.add(dto);
        if (selectedIndex != null && i == selectedIndex) {
          targetIndex = availableTracks.length - 1;
        }
      }
    }

    return (availableTracks, targetIndex);
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
      backgroundColor: const Color(0xFF0A0A0A),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B93FF))))
          : _albumData == null
              ? const Center(child: Text('Error al cargar el álbum'))
              : SynapFastScroller(
                  controller: _scrollController,
                  itemCount: _tracks.length,
                  child: CustomScrollView(
                    controller: _scrollController,
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
                                    color: Color(0xFF8B93FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.play_arrow, size: 36, color: Colors.black),
                                    onPressed: () async {
                                      if (_tracks.isEmpty) return;
                                      final (availableTracks, _) = _getNormalizedAlbumTracks();
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
                                    final (availableTracks, _) = _getNormalizedAlbumTracks();
                                    if (availableTracks.isEmpty) return;
                                    await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                                      itemList: availableTracks,
                                      initialIndex: Random().nextInt(availableTracks.length),
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
                                        color: isFullyDownloaded ? const Color(0xFF8B93FF) : Colors.white,
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

                          final String? trackId = (existsLocal && localMatch['jellyfin_data'] != null)
                              ? localMatch['jellyfin_data']['Id']?.toString()
                              : null;

                          Widget actionButton = ValueListenableBuilder<Set<String>>(
                            valueListenable: PlaybackDownloadCoordinator().activeDownloadsNotifier,
                            builder: (context, activeDownloads, _) {
                              final isDownloading = activeDownloads.contains(
                                PlaybackDownloadCoordinator().normalize(track['title'] ?? ''),
                              );
                              if (isDownloading) {
                                return const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B93FF)),
                                    ),
                                  ),
                                );
                              }
                              return IconButton(
                                icon: const Icon(Icons.more_vert, color: Colors.white),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => TrackOptionsMenuSheet(
                                      itemId: trackId,
                                      title: track['title'] ?? 'Unknown Track',
                                      artist: track['artist'] ?? _albumData?['artist'] ?? '',
                                      queryString: track['query_string'],
                                      coverUrl: _albumData?['cover_url'],
                                    ),
                                  );
                                },
                              );
                            },
                          );

                          return TrackListItem(
                            trackId: trackId,
                            title: track['title'] ?? 'Unknown Track',
                            artist: track['artist'] ?? '',
                            duration: durationStr,
                            isAvailableInServer: existsLocal,
                            trackNumber: (track['track_number'] != null && track['track_number'] != 0) ? track['track_number'] : index + 1,
                            queryString: track['query_string'],
                            coverUrl: _albumData?['cover_url'],
                            onMenuPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (_) => TrackOptionsMenuSheet(
                                  itemId: trackId,
                                  title: track['title'] ?? 'Unknown Track',
                                  artist: track['artist'] ?? _albumData?['artist'] ?? '',
                                  queryString: track['query_string'],
                                  coverUrl: _albumData?['cover_url'],
                                ),
                              );
                            },
                            trailingWidget: actionButton,
                            onPlayPressed: () async {
                              if (!existsLocal) {
                                PlaybackDownloadCoordinator().downloadAndAutoPlay(
                                  context: context,
                                  title: track['title'] ?? '',
                                  artist: track['artist'] ?? _albumData?['artist'] ?? '',
                                  queryString: track['query_string'],
                                  coverUrl: _albumData?['cover_url'],
                                );
                                setState(() {});
                                return;
                              }
                              try {
                                final (availableTracks, targetIndex) = _getNormalizedAlbumTracks(selectedIndex: index);
                                if (availableTracks.isEmpty) return;
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
              ),
    );
  }
}
