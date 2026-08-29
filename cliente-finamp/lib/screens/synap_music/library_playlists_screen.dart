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

class LibraryPlaylistsScreen extends StatefulWidget {
  const LibraryPlaylistsScreen({Key? key}) : super(key: key);

  @override
  _LibraryPlaylistsScreenState createState() => _LibraryPlaylistsScreenState();
}

class _LibraryPlaylistsScreenState extends State<LibraryPlaylistsScreen> {
  final Color _synapColor = const Color(0xFF144477);
  
  List<BaseItemDto>? _playlists;
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _favoriteAlbums = [];
  final SynapApiService _apiService = SynapApiService();
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

  Future<void> _loadPlaylists() async {
    try {
      final userHelper = GetIt.instance<FinampUserHelper>();
      final userId = userHelper.currentUserId;
      final playlistsData = await _apiService.getUserPlaylists(userId: userId);
      final playlists = playlistsData.map((e) => BaseItemDto.fromJson(e)).toList();
      if (mounted) {
        setState(() {
          _playlists = playlists;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
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
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _deleteSelected() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Playlists'),
        content: Text('¿Estás seguro de eliminar ${_selectedIds.length} playlist(s)? Esta acción no se puede deshacer.'),
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
      for (final id in _selectedIds) {
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
                      final isSelected = _selectedIds.contains(playlist.id);
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
                                      child: (playlist.imageTags != null && playlist.imageTags!.isNotEmpty)
                                          ? Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => _buildPlaceholder(),
                                            )
                                          : _buildPlaceholder(),
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
                                      '${playlist.childCount ?? 0} canciones',
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

  Widget _buildPlaceholder() {
    return Container(
      color: _synapColor.withOpacity(0.1),
      child: Icon(Icons.queue_music, color: _synapColor, size: 48),
    );
  }
}
