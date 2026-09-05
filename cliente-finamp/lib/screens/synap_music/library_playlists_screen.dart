import 'package:flutter/material.dart';
import '../../services/synap_events.dart';
import 'dart:async';
import 'package:get_it/get_it.dart';
import '../../components/create_playlist_dialog.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/synap_api_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/finamp_user_helper.dart';
import '../../services/downloads_helper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import '../../models/jellyfin_models.dart';
import 'playlist_detail_screen.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'album_detail_screen.dart';
import '../../services/likes_playlist_helper.dart';

class LibraryPlaylistsScreen extends StatefulWidget {
  const LibraryPlaylistsScreen({Key? key}) : super(key: key);

  @override
  _LibraryPlaylistsScreenState createState() => _LibraryPlaylistsScreenState();
}

class _LibraryPlaylistsScreenState extends State<LibraryPlaylistsScreen> {
  final Color _synapColor = const Color(0xFF8B93FF);
  
  List<BaseItemDto>? _playlists;
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _favoriteAlbums = [];
  final SynapApiService _apiService = SynapApiService();
  final DownloadsHelper _downloadsHelper = GetIt.instance<DownloadsHelper>();
  StreamSubscription? _refreshSub;

  // Modo de selección
  final Set<String> _selectedIds = {};
  bool get _isSelectionMode => _selectedIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
    _refreshSub = SynapEvents.libraryRefreshStream.stream.listen((_) {
      if (mounted) {
        _loadPlaylists();
      }
    });
  }

  @override
  void dispose() {
    _refreshSub?.cancel();
    super.dispose();
  }

  void _sortPlaylists(List<BaseItemDto> list) {
    list.sort((a, b) {
      final aIs = LikesPlaylistHelper.isLikesPlaylist(a);
      final bIs = LikesPlaylistHelper.isLikesPlaylist(b);
      if (aIs && !bIs) return -1;
      if (!aIs && bIs) return 1;
      return (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase());
    });
  }

  Future<void> _loadPlaylists() async {
    // 1. CARGA INMEDIATA OFFLINE / CACHÉ (0 ms)
    try {
      final downloadedPlaylists = _downloadsHelper.downloadedParents
          .where((dp) => dp.item.type == 'Playlist' || (dp.item.type != 'MusicAlbum' && dp.downloadedChildren.isNotEmpty))
          .map((dp) => dp.item)
          .toList();

      List<BaseItemDto> localCached = [];
      final directory = await getApplicationDocumentsDirectory();
      final cacheFile = File('${directory.path}/synap_playlists_cache.json');
      if (await cacheFile.exists()) {
        final content = await cacheFile.readAsString();
        final List<dynamic> jsonList = json.decode(content);
        localCached = jsonList.map((e) => BaseItemDto.fromJson(e)).toList();
      }

      final Map<String, BaseItemDto> mergedMap = {};
      for (final p in localCached) {
        if (p.id != null) mergedMap[p.id!] = p;
      }
      for (final p in downloadedPlaylists) {
        if (p.id != null) mergedMap[p.id!] = p;
      }

      if (mergedMap.isNotEmpty) {
        final initialList = mergedMap.values.toList();
        _sortPlaylists(initialList);
        if (mounted) {
          setState(() {
            _playlists = initialList;
            _isLoading = false;
            _errorMessage = null;
          });
        }
      }
    } catch (e) {
      print('Aviso cargando cache offline: $e');
    }

    // 2. SINCRONIZACIÓN EN RED (con timeout para no bloquearse offline)
    try {
      final userHelper = GetIt.instance<FinampUserHelper>();
      final userId = userHelper.currentUserId;
      var playlistsData = await _apiService.getUserPlaylists(userId: userId);

      if (playlistsData.isNotEmpty) {
        var playlists = playlistsData.map((e) => BaseItemDto.fromJson(e)).toList();

        // Asegurar que la playlist fija "My likes" exista
        final hasLikes = playlists.any((p) => LikesPlaylistHelper.isLikesPlaylist(p));
        if (!hasLikes) {
          final created = await LikesPlaylistHelper.getOrCreateLikesPlaylist();
          if (created != null) {
            playlistsData = await _apiService.getUserPlaylists(userId: userId);
            playlists = playlistsData.map((e) => BaseItemDto.fromJson(e)).toList();
          }
        }

        // Incorporar playlists descargadas que no estén en el servidor
        final downloadedPlaylists = _downloadsHelper.downloadedParents
            .where((dp) => dp.item.type == 'Playlist' || (dp.item.type != 'MusicAlbum' && dp.downloadedChildren.isNotEmpty))
            .map((dp) => dp.item)
            .toList();
        for (final dp in downloadedPlaylists) {
          if (dp.id != null && !playlists.any((p) => p.id == dp.id)) {
            playlists.add(dp);
          }
        }

        _sortPlaylists(playlists);

        // Guardar en caché local para persistencia offline
        try {
          final directory = await getApplicationDocumentsDirectory();
          final cacheFile = File('${directory.path}/synap_playlists_cache.json');
          await cacheFile.writeAsString(json.encode(playlists.map((p) => p.toJson()).toList()));
        } catch (_) {}

        if (mounted) {
          setState(() {
            _playlists = playlists;
            _isLoading = false;
            _errorMessage = null;
          });
        }
      } else {
        if (mounted && (_playlists == null || _playlists!.isEmpty)) {
          setState(() {
            _playlists = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (_playlists == null || _playlists!.isEmpty) {
            _errorMessage = 'Sin conexión al servidor y sin playlists guardadas.';
          }
          _isLoading = false;
        });
      }
    }
    await _loadFavoriteAlbums();
  }

  Future<void> _loadFavoriteAlbums() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/synap_favorite_albums.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        if (mounted) {
          setState(() {
            _favoriteAlbums = json.decode(content);
          });
        }
      }
    } catch (e) {
      print('Error al cargar álbumes favoritos: $e');
    }
  }

  void _toggleSelection(String id) {
    final playlist = _playlists?.where((p) => p.id == id).firstOrNull;
    if (LikesPlaylistHelper.isLikesPlaylist(playlist)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La playlist "My likes" es fija y no se puede eliminar.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _deleteSelected() async {
    final idsToDelete = _selectedIds.where((id) {
      return !_playlists!.any((p) => p.id == id && LikesPlaylistHelper.isLikesPlaylist(p));
    }).toList();

    if (idsToDelete.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay playlists seleccionadas para eliminar.')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Playlists'),
        content: Text('¿Estás seguro de eliminar ${idsToDelete.length} playlist(s)? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      bool allSuccess = true;
      for (final id in idsToDelete) {
        final success = await _apiService.deletePlaylist(id);
        if (!success) allSuccess = false;
      }

      Navigator.pop(context); // Cierra indicador

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(allSuccess ? 'Playlists eliminadas.' : 'Hubo un error al eliminar algunas playlists.'),
            backgroundColor: allSuccess ? Colors.green : Colors.red,
          ),
        );
      }

      setState(() {
        _selectedIds.clear();
      });
      _loadPlaylists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: _isSelectionMode
          ? AppBar(
              title: Text(
                '${_selectedIds.length} seleccionadas',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 0,
              backgroundColor: _synapColor,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedIds.clear();
                  });
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteSelected,
                ),
              ],
            )
          : null, // Sin AppBar por defecto, usamos CustomScrollView
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            if (!_isSelectionMode)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 24.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Playlists',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white, size: 30),
                        onPressed: () async {
                          final created = await showDialog<bool>(
                            context: context,
                            builder: (context) => const CreatePlaylistDialog(),
                          );
                          
                          if (created == true) {
                            _loadPlaylists();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

            // Playlists Grid
            if (_isLoading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(_synapColor),
                    ),
                  ),
                ),
              )
            else if (_errorMessage != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'Error al cargar playlists:\n$_errorMessage',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              )
            else if (_playlists == null || _playlists!.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'No tienes playlists aún.\nCrea una tocando el botón "+".',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final playlist = _playlists![index];
                      final isLikes = LikesPlaylistHelper.isLikesPlaylist(playlist);
                      final isSelected = _selectedIds.contains(playlist.id);
                      final isDownloaded = playlist.id != null && _downloadsHelper.getDownloadedParent(playlist.id!) != null;
                      final downloadedParent = isDownloaded ? _downloadsHelper.getDownloadedParent(playlist.id!) : null;
                      final downloadedImage = isDownloaded ? _downloadsHelper.getDownloadedImage(playlist) : null;
                      final songCount = (downloadedParent != null && downloadedParent.downloadedChildren.isNotEmpty)
                          ? downloadedParent.downloadedChildren.length
                          : (playlist.childCount ?? 0);
                      final imageUrl = 'http://100.81.156.126:8096/Items/${playlist.id}/Images/Primary';

                      return GestureDetector(
                        onLongPress: () {
                          if (playlist.id != null) {
                            _toggleSelection(playlist.id!);
                          }
                        },
                        onTap: () {
                          if (_isSelectionMode) {
                            if (playlist.id != null) {
                              _toggleSelection(playlist.id!);
                            }
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PlaylistDetailScreen(playlist: playlist),
                            )).then((_) => _loadPlaylists());
                          }
                        },
                        child: Card(
                          elevation: isSelected ? 8 : 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? _synapColor : Colors.transparent,
                              width: isSelected ? 3 : 0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: isLikes
                                          ? _buildLikesCover()
                                          : (downloadedImage != null
                                              ? Image.file(
                                                  downloadedImage.file,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  cacheWidth: 350,
                                                  cacheHeight: 350,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) => _buildPlaceholder(),
                                                )
                                              : ((playlist.imageTags != null && playlist.imageTags!.isNotEmpty)
                                                  ? Image.network(
                                                      imageUrl,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      cacheWidth: 350,
                                                      cacheHeight: 350,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                                                    )
                                                  : _buildPlaceholder())),
                                    ),
                                    if (isDownloaded)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0A0A0A).withOpacity(0.85),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: _synapColor, width: 1.2),
                                          ),
                                          child: Icon(Icons.download_done, color: _synapColor, size: 14),
                                        ),
                                      ),
                                    if (isSelected)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: _synapColor.withOpacity(0.6),
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.check_circle, color: Colors.white, size: 48),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      playlist.name ?? 'Sin nombre',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$songCount canciones',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: _playlists!.length,
                  ),
                ),
              ),

            // Header Álbumes
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0, bottom: 8.0),
                child: Text(
                  'Álbumes',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            if (_favoriteAlbums.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'No hay álbumes favoritos aún.',
                      style: TextStyle(fontSize: 16, color: Colors.grey.withOpacity(0.5)),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final album = _favoriteAlbums[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => AlbumDetailScreen(albumId: album['id']),
                          )).then((_) => _loadFavoriteAlbums());
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: Image.network(
                                    album['cover_url'] ?? '',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      album['title'] ?? 'Sin nombre',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${album['artist'] ?? ''}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: _favoriteAlbums.length,
                  ),
                ),
              ),
            
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildLikesCover() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF281C3E), Color(0xFF141414)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF8B93FF).withOpacity(0.18),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite,
            color: Color(0xFF8B93FF),
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: _synapColor.withOpacity(0.1),
      child: Icon(Icons.queue_music, color: _synapColor, size: 48),
    );
  }
}
