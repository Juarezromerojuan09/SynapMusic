import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/synap_api_service.dart';
import '../../services/sync_helper.dart';
import '../../services/downloads_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'dart:ui';

import '../../components/track_list_item.dart';
import '../../components/track_options_menu_sheet.dart';
import '../../services/audio_service_helper.dart';
import '../player_screen.dart';
import '../../services/synap_events.dart';
import '../../components/now_playing_bar.dart';

enum PlaylistSortMode { artist, dateAdded, duration, title }

class PlaylistDetailScreen extends StatefulWidget {
  final BaseItemDto playlist;

  const PlaylistDetailScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final Color _synapColor = const Color(0xFF144477);
  
  List<BaseItemDto>? _tracks;
  bool _isLoading = true;
  String? _errorMessage;
  PlaylistSortMode _sortMode = PlaylistSortMode.dateAdded;

  late String _imageUrl;
  bool _isDownloading = false;
  final DownloadsHelper _downloadsHelper = GetIt.instance<DownloadsHelper>();
  late ValueNotifier<bool> _isDownloadedNotifier;

  @override
  void initState() {
    super.initState();
    _imageUrl = 'http://100.81.156.126:8096/Items/${widget.playlist.id}/Images/Primary';
    _loadItems();
    
    _isDownloadedNotifier = ValueNotifier(_downloadsHelper.getDownloadedParent(widget.playlist.id) != null);
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    List<BaseItemDto> loadedTracks = [];
    try {
      if (FinampSettingsHelper.finampSettings.isOffline) {
        final parent = _downloadsHelper.getDownloadedParent(widget.playlist.id);
        if (parent != null) {
          loadedTracks = parent.downloadedChildren.values.toList();
        }
      } else {
        final value = await GetIt.instance<JellyfinApiHelper>().getItems(
          parentItem: widget.playlist,
          isGenres: false,
        );
        loadedTracks = value ?? [];
      }
    } catch (e) {
      final parent = _downloadsHelper.getDownloadedParent(widget.playlist.id);
      if (parent != null) {
        loadedTracks = parent.downloadedChildren.values.toList();
      } else {
        _errorMessage = e.toString();
      }
    }

    if (mounted) {
      setState(() {
        _tracks = loadedTracks;
        _applySort();
        _isLoading = false;
      });
    }
  }

  void _applySort() {
    if (_tracks == null) return;
    switch (_sortMode) {
      case PlaylistSortMode.artist:
        _tracks!.sort((a, b) {
          final artistA = a.artists?.isNotEmpty == true ? a.artists![0] : 'z';
          final artistB = b.artists?.isNotEmpty == true ? b.artists![0] : 'z';
          return artistA.compareTo(artistB);
        });
        break;
      case PlaylistSortMode.dateAdded:
        // By default playlists are chronologically ordered. We can sort by dateCreated (descending).
        _tracks!.sort((a, b) => (b.dateCreated ?? '').compareTo(a.dateCreated ?? ''));
        break;
      case PlaylistSortMode.duration:
        _tracks!.sort((a, b) => (b.runTimeTicks ?? 0).compareTo(a.runTimeTicks ?? 0));
        break;
      case PlaylistSortMode.title:
        _tracks!.sort((a, b) => (a.name ?? 'z').compareTo(b.name ?? 'z'));
        break;
    }
  }

  void _showSortDialog() {
    PlaylistSortMode tempMode = _sortMode;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Ordenar por'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<PlaylistSortMode>(
                    title: const Text('Nombre del artista (A-Z)'),
                    value: PlaylistSortMode.artist,
                    groupValue: tempMode,
                    activeColor: _synapColor,
                    onChanged: (val) => setDialogState(() => tempMode = val!),
                  ),
                  RadioListTile<PlaylistSortMode>(
                    title: const Text('Añadido recientemente'),
                    value: PlaylistSortMode.dateAdded,
                    groupValue: tempMode,
                    activeColor: _synapColor,
                    onChanged: (val) => setDialogState(() => tempMode = val!),
                  ),
                  RadioListTile<PlaylistSortMode>(
                    title: const Text('Duración'),
                    value: PlaylistSortMode.duration,
                    groupValue: tempMode,
                    activeColor: _synapColor,
                    onChanged: (val) => setDialogState(() => tempMode = val!),
                  ),
                  RadioListTile<PlaylistSortMode>(
                    title: const Text('Título (A-Z)'),
                    value: PlaylistSortMode.title,
                    groupValue: tempMode,
                    activeColor: _synapColor,
                    onChanged: (val) => setDialogState(() => tempMode = val!),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Omitir', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _sortMode = tempMode;
                      _applySort();
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Aplicar', style: TextStyle(color: _synapColor)),
                ),
              ],
            );
          }
        );
      }
    );
  }

  Future<void> _toggleDownload(bool value, List<BaseItemDto> items) async {
    setState(() { _isDownloading = true; });
    try {
      if (value) {
        // Encender: Descargar playlist y letras
        final syncHelper = DownloadsSyncHelper(Logger("SyncHelper"));
        syncHelper.sync(context, widget.playlist, items);
        
        // Descargar letras
        final directory = await getApplicationDocumentsDirectory();
        final lyricsDir = Directory('${directory.path}/lyrics');
        if (!await lyricsDir.exists()) {
          await lyricsDir.create(recursive: true);
        }
        
        final api = SynapApiService();
        for (var item in items) {
          if (item.name != null) {
            final artist = item.albumArtist ?? item.artists?.firstOrNull ?? '';
            final file = File('${lyricsDir.path}/${item.id}.lrc');
            if (!await file.exists()) {
              final lrc = await api.getLyrics(artist, item.name!);
              if (lrc != null && lrc.isNotEmpty) {
                await file.writeAsString(lrc);
              }
            }
          }
        }
      } else {
        // Apagar: Eliminar descargas
        await _downloadsHelper.deleteDownloadParent(deletedFor: widget.playlist.id);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() { _isDownloading = false; });
      _isDownloadedNotifier.value = _downloadsHelper.getDownloadedParent(widget.playlist.id) != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final top = constraints.biggest.height;
                final maxExtent = 300.0;
                final minExtent = MediaQuery.of(context).padding.top + kToolbarHeight;
                final t = ((maxExtent - top) / (maxExtent - minExtent)).clamp(0.0, 1.0);

                final screenWidth = MediaQuery.of(context).size.width;
                final currentWidth = screenWidth * (1 - t) + 40.0 * t;
                final currentHeight = 300.0 * (1 - t) + 40.0 * t;
                final currentLeft = 0.0 * (1 - t) + ((screenWidth - 40.0) / 2) * t;
                final currentTop = 0.0 * (1 - t) + (MediaQuery.of(context).padding.top + (kToolbarHeight - 40.0) / 2) * t;
                final currentRadius = 0.0 * (1 - t) + 20.0 * t;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gradiente de fondo negro
                    Container(color: Theme.of(context).scaffoldBackgroundColor),
                    
                    // Imagen que se encoge
                    Positioned(
                      top: currentTop,
                      left: currentLeft,
                      width: currentWidth,
                      height: currentHeight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(currentRadius),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[900], 
                                child: const Icon(Icons.queue_music, color: Colors.white24)
                              ),
                            ),
                            // Gradiente solo cuando esta expandido
                            Opacity(
                              opacity: 1 - t,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.transparent, Colors.black87],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Titulo (usamos FlexibleSpaceBar solo para el titulo)
                    FlexibleSpaceBar(
                      title: Text(
                        widget.playlist.name ?? 'Playlist',
                        style: const TextStyle(fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 4)]),
                      ),
                      centerTitle: false,
                    ),
                  ],
                );
              },
            ),
          ),
          
          if (_isLoading)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_synapColor),
                ),
              ),
            )
          else if (_errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Text('Error: $_errorMessage', style: const TextStyle(color: Colors.red)),
              ),
            )
          else if (_tracks == null || _tracks!.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text('Esta playlist está vacía.', style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return ValueListenableBuilder<Box<DownloadedParent>>(
                      valueListenable: _downloadsHelper.downloadedParentsListenable,
                      builder: (context, box, child) {
                        final isDownloaded = box.containsKey(widget.playlist.id);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // 1. Play grande
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: _synapColor,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.play_arrow, size: 36, color: Colors.black),
                                  onPressed: () async {
                                    if (_tracks == null || _tracks!.isEmpty) return;
                                    await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                                      itemList: _tracks!,
                                      initialIndex: 0,
                                    );
                                    if (mounted) {
                                      Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
                                    }
                                  },
                                ),
                              ),
                              // 2. Aleatorio
                              IconButton(
                                icon: const Icon(Icons.shuffle, size: 24, color: Colors.white),
                                onPressed: () async {
                                  if (_tracks == null || _tracks!.isEmpty) return;
                                  await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                                    itemList: _tracks!,
                                    initialIndex: 0,
                                    shuffle: true,
                                  );
                                  if (mounted) {
                                    Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
                                  }
                                },
                              ),
                              // 3. Filtro
                              IconButton(
                                icon: const Icon(Icons.sort, size: 24, color: Colors.white),
                                onPressed: _showSortDialog,
                              ),
                              // 4. Lapiz
                              IconButton(
                                icon: const Icon(Icons.edit, size: 24, color: Colors.white),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Edición próximamente')),
                                  );
                                },
                              ),
                              // 5. Descargar
                              IconButton(
                                icon: Icon(
                                  Icons.download_for_offline,
                                  size: 24,
                                  color: isDownloaded ? _synapColor : Colors.white,
                                ),
                                onPressed: _isDownloading ? null : () => _toggleDownload(!isDownloaded, _tracks!),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  
                  final trackIndex = index - 1;
                  final track = _tracks![trackIndex];
                  final artist = (track.artists?.isNotEmpty == true) ? track.artists![0] : 'Desconocido';
                  final trackImageUrl = 'http://100.81.156.126:8096/Items/${track.id}/Images/Primary';
                  
                  return TrackListItem(
                    trackId: track.id,
                    trackNumber: trackIndex + 1,
                    title: track.name ?? 'Canción',
                    artist: artist,
                    isAvailableInServer: true,
                    coverUrl: trackImageUrl,
                    onPlayPressed: () async {
                      try {
                        await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                          itemList: _tracks!,
                          initialIndex: trackIndex,
                        );
                        if (mounted) {
                          Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al reproducir: $e')),
                          );
                        }
                      }
                    },
                    onMenuPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) => TrackOptionsMenuSheet(
                          itemId: track.id!,
                          playlistId: widget.playlist.id,
                          playlistItemId: track.playlistItemId,
                          onTrackRemoved: () {
                            _loadItems(); // Recarga la lista de inmediato
                            SynapEvents.fireLibraryRefresh();
                          },
                        ),
                      );
                    },
                  );
                },
                childCount: _tracks!.length + 1,
              ),
            ),
        ],
      ),
    );
  }
}
