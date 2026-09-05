import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:io';
import 'dart:convert';
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
import '../../services/likes_playlist_helper.dart';

enum PlaylistSortMode { artist, dateAdded, duration, title }

class _PinnedSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _PinnedSearchBarDelegate({required this.child, this.height = 64.0});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF0A0A0A),
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedSearchBarDelegate oldDelegate) => true;
}

class PlaylistDetailScreen extends StatefulWidget {
  final BaseItemDto playlist;

  const PlaylistDetailScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final Color _synapColor = const Color(0xFF8B93FF);
  
  List<BaseItemDto>? _tracks;
  bool _isLoading = true;
  String? _errorMessage;
  PlaylistSortMode _sortMode = PlaylistSortMode.dateAdded;

  late String _imageUrl;
  bool _isDownloading = false;
  final DownloadsHelper _downloadsHelper = GetIt.instance<DownloadsHelper>();
  late ValueNotifier<bool> _isDownloadedNotifier;

  bool _isSearchOpen = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _normalize(String input) {
    const withAccents = 'áéíóúüñÁÉÍÓÚÜÑ';
    const withoutAccents = 'aeiouunAEIOUUN';
    var res = input.toLowerCase();
    for (int i = 0; i < withAccents.length; i++) {
      res = res.replaceAll(withAccents[i].toLowerCase(), withoutAccents[i].toLowerCase());
    }
    return res;
  }

  List<BaseItemDto> get _displayedTracks {
    if (_tracks == null) return [];
    if (!_isSearchOpen || _searchQuery.trim().isEmpty) return _tracks!;

    final q = _normalize(_searchQuery.trim());
    return _tracks!.where((track) {
      final title = _normalize(track.name ?? '');
      final album = _normalize(track.album ?? '');
      final artistsList = track.artists ?? track.artistItems?.map((a) => a.name ?? '').toList() ?? [];
      final artists = _normalize(artistsList.join(' '));
      final albumArtist = _normalize(track.albumArtist ?? '');

      return title.contains(q) ||
             album.contains(q) ||
             artists.contains(q) ||
             albumArtist.contains(q);
    }).toList();
  }

  void _toggleSearch([bool? open]) {
    final shouldOpen = open ?? !_isSearchOpen;
    setState(() {
      _isSearchOpen = shouldOpen;
      if (!shouldOpen) {
        _searchQuery = '';
        _searchController.clear();
        _searchFocusNode.unfocus();
      }
    });

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    if (shouldOpen) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          _searchFocusNode.requestFocus();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrl = 'http://100.81.156.126:8096/Items/${widget.playlist.id}/Images/Primary';
    _loadItems();
    
    _isDownloadedNotifier = ValueNotifier(_downloadsHelper.getDownloadedParent(widget.playlist.id) != null);
  }

  Future<void> _loadItems() async {
    // 1. CARGA INMEDIATA OFFLINE / DESCARGAS (0 ms)
    List<BaseItemDto> offlineTracks = [];

    final downloadedParent = _downloadsHelper.getDownloadedParent(widget.playlist.id);
    if (downloadedParent != null && downloadedParent.downloadedChildren.isNotEmpty) {
      offlineTracks = downloadedParent.downloadedChildren.values.toList();
    }

    if (offlineTracks.isEmpty) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final cacheFile = File('${directory.path}/synap_playlist_${widget.playlist.id}_tracks.json');
        if (await cacheFile.exists()) {
          final content = await cacheFile.readAsString();
          final List<dynamic> list = json.decode(content);
          offlineTracks = list.map((e) => BaseItemDto.fromJson(e)).toList();
        }
      } catch (_) {}
    }

    if (offlineTracks.isNotEmpty && mounted) {
      setState(() {
        _tracks = offlineTracks;
        _applySort();
        _isLoading = false;
        _errorMessage = null;
      });
    }

    // 2. SINCRONIZACIÓN EN RED (con timeout de 4s para no congelar la pantalla sin internet)
    if (!FinampSettingsHelper.finampSettings.isOffline) {
      try {
        final value = await GetIt.instance<JellyfinApiHelper>().getItems(
          parentItem: widget.playlist,
          isGenres: false,
        ).timeout(const Duration(seconds: 4));

        if (value != null) {
          try {
            final directory = await getApplicationDocumentsDirectory();
            final cacheFile = File('${directory.path}/synap_playlist_${widget.playlist.id}_tracks.json');
            await cacheFile.writeAsString(json.encode(value.map((e) => e.toJson()).toList()));
          } catch (_) {}

          if (mounted) {
            setState(() {
              _tracks = value;
              _applySort();
              _isLoading = false;
              _errorMessage = null;
            });
          }
        }
      } catch (e) {
        // En caso de fallo o timeout de red:
        // Si ya tenemos canciones cargadas offline, NO mostramos error y dejamos que el usuario escuche su música.
        if (mounted && (_tracks == null || _tracks!.isEmpty)) {
          final parent = _downloadsHelper.getDownloadedParent(widget.playlist.id);
          if (parent != null && parent.downloadedChildren.isNotEmpty) {
            setState(() {
              _tracks = parent.downloadedChildren.values.toList();
              _applySort();
              _isLoading = false;
              _errorMessage = null;
            });
          } else {
            setState(() {
              _errorMessage = 'Sin conexión y no hay canciones descargadas para esta playlist.';
              _isLoading = false;
            });
          }
        }
      }
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
    final displayedTracks = _displayedTracks;
    final topPadding = MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: () async {
        if (_isSearchOpen) {
          _toggleSearch(false);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: _isSearchOpen ? (topPadding + kToolbarHeight) : 300,
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(
                    _isSearchOpen ? Icons.close : Icons.search,
                    color: _isSearchOpen ? _synapColor : Colors.white,
                  ),
                  tooltip: _isSearchOpen ? 'Cerrar búsqueda' : 'Buscar canción',
                  onPressed: () => _toggleSearch(),
                ),
              ],
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final top = constraints.biggest.height;
                  final minExtent = topPadding + kToolbarHeight;
                  final maxExtent = _isSearchOpen ? minExtent : 300.0;
                  final diff = maxExtent - minExtent;
                  final t = (diff <= 0.001) ? 1.0 : ((maxExtent - top) / diff).clamp(0.0, 1.0);

                  final screenWidth = MediaQuery.of(context).size.width;
                  final currentWidth = screenWidth * (1 - t) + 40.0 * t;
                  final currentHeight = 300.0 * (1 - t) + 40.0 * t;
                  final currentLeft = 0.0 * (1 - t) + ((screenWidth - 40.0) / 2) * t;
                  final currentTop = 0.0 * (1 - t) + (topPadding + (kToolbarHeight - 40.0) / 2) * t;
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
                              LikesPlaylistHelper.isLikesPlaylist(widget.playlist)
                                  ? Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF2E2045), Color(0xFF141414)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF8B93FF).withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.favorite,
                                            color: Color(0xFF8B93FF),
                                            size: 38,
                                          ),
                                        ),
                                      ),
                                    )
                                 : (_downloadsHelper.getDownloadedImage(widget.playlist) != null
                                     ? Image.file(
                                         _downloadsHelper.getDownloadedImage(widget.playlist)!.file,
                                         fit: BoxFit.cover,
                                         errorBuilder: (context, error, stackTrace) => Container(
                                           color: Colors.grey[900], 
                                           child: const Icon(Icons.queue_music, color: Colors.white24)
                                         ),
                                       )
                                     : Image.network(
                                         _imageUrl,
                                         fit: BoxFit.cover,
                                         errorBuilder: (context, error, stackTrace) => Container(
                                           color: Colors.grey[900], 
                                           child: const Icon(Icons.queue_music, color: Colors.white24)
                                         ),
                                       )),
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

            if (_isSearchOpen) ...[
              SliverPersistentHeader(
                pinned: true,
                delegate: _PinnedSearchBarDelegate(
                  height: 64.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: _synapColor.withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        cursorColor: _synapColor,
                        decoration: InputDecoration(
                          hintText: 'Buscar por título, álbum o artista...',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: _synapColor, size: 22),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.white70, size: 20),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                                  onPressed: () => _toggleSearch(false),
                                ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              if (_searchQuery.trim().isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 8.0, right: 20.0, top: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${displayedTracks.length} coincidencia${displayedTracks.length == 1 ? '' : 's'}',
                          style: TextStyle(color: _synapColor, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (displayedTracks.isNotEmpty) ...[
                              IconButton(
                                icon: const Icon(Icons.play_circle_fill, size: 24),
                                color: _synapColor,
                                tooltip: 'Reproducir resultados',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () async {
                                  await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                                    itemList: displayedTracks,
                                    initialIndex: 0,
                                  );
                                  if (mounted) {
                                    Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
                                  }
                                },
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                icon: const Icon(Icons.shuffle, size: 20),
                                color: Colors.white70,
                                tooltip: 'Aleatorio',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () async {
                                  await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                                    itemList: displayedTracks,
                                    initialIndex: 0,
                                    shuffle: true,
                                  );
                                  if (mounted) {
                                    Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
                                  }
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              'de ${_tracks!.length}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],

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
            else if (_isSearchOpen)
              // VISTA DE BÚSQUEDA DIRECTA (máximo espacio para resultados)
              (displayedTracks.isEmpty && _searchQuery.trim().isNotEmpty)
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search_off, size: 56, color: Colors.grey[600]),
                              const SizedBox(height: 16),
                              Text(
                                'Sin resultados',
                                style: TextStyle(color: Colors.grey[300], fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No encontramos ninguna canción que coincida con "$_searchQuery" por título, álbum o artista.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[500], fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final track = displayedTracks[index];
                          final artist = (track.artists?.isNotEmpty == true) ? track.artists![0] : (track.albumArtist ?? 'Desconocido');
                          final trackImageUrl = 'http://100.81.156.126:8096/Items/${track.id}/Images/Primary';
                          final trackNumber = _tracks!.indexOf(track) + 1;

                          return TrackListItem(
                            trackId: track.id,
                            trackNumber: trackNumber,
                            title: track.name ?? 'Canción',
                            artist: artist,
                            isAvailableInServer: true,
                            coverUrl: trackImageUrl,
                            onPlayPressed: () async {
                              try {
                                await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                                  itemList: displayedTracks,
                                  initialIndex: index,
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
                                    _loadItems();
                                    SynapEvents.fireLibraryRefresh();
                                  },
                                ),
                              );
                            },
                          );
                        },
                        childCount: displayedTracks.length,
                      ),
                    )
            else
              // VISTA NORMAL COMPLETA
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
                                // 3. Lupa / Buscar
                                IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                  tooltip: 'Buscar canción',
                                  onPressed: () => _toggleSearch(true),
                                ),
                                // 4. Filtro
                                IconButton(
                                  icon: const Icon(Icons.sort, size: 24, color: Colors.white),
                                  onPressed: _showSortDialog,
                                ),
                                // 5. Lapiz
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 24, color: Colors.white),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Edición próximamente')),
                                    );
                                  },
                                ),
                                // 6. Descargar
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
                    final artist = (track.artists?.isNotEmpty == true) ? track.artists![0] : (track.albumArtist ?? 'Desconocido');
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
                              _loadItems();
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
      ),
    );
  }
}
