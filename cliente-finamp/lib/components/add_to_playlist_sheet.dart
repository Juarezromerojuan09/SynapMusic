import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'create_playlist_dialog.dart';
import '../services/jellyfin_api_helper.dart';
import '../models/jellyfin_models.dart';

class PlaylistStatus {
  final BaseItemDto playlist;
  final bool containsItem;
  final String? entryId; // El ID de la canción DENTRO de la playlist

  PlaylistStatus(this.playlist, this.containsItem, this.entryId);
}

class AddToPlaylistSheet extends StatefulWidget {
  final String itemId;

  const AddToPlaylistSheet({Key? key, required this.itemId}) : super(key: key);

  @override
  _AddToPlaylistSheetState createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends State<AddToPlaylistSheet> {
  final Color _synapColor = const Color(0xFF144477);
  late Future<List<PlaylistStatus>> _playlistsFuture;

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  void _loadPlaylists() {
    setState(() {
      _playlistsFuture = _fetchPlaylistsAndStatus();
    });
  }

  Future<List<PlaylistStatus>> _fetchPlaylistsAndStatus() async {
    final jellyfin = GetIt.instance<JellyfinApiHelper>();
    final playlists = await jellyfin.getItems(includeItemTypes: "Playlist", isGenres: false) ?? [];
    
    List<PlaylistStatus> statuses = [];
    
    for (final pl in playlists) {
      if (pl.id == null) continue;
      
      // Fetch items for this playlist
      final items = await jellyfin.getItems(parentItem: pl, isGenres: false) ?? [];
      
      bool contains = false;
      String? entryId;
      
      for (final item in items) {
        if (item.id == widget.itemId) {
          contains = true;
          entryId = item.playlistItemId; // El ID necesario para eliminarlo de la playlist
          break;
        }
      }
      statuses.add(PlaylistStatus(pl, contains, entryId));
    }
    
    return statuses;
  }

  Future<void> _togglePlaylist(PlaylistStatus status) async {
    final jellyfin = GetIt.instance<JellyfinApiHelper>();
    final playlistName = status.playlist.name ?? 'Playlist';

    try {
      if (status.containsItem) {
        // Remover de la playlist
        if (status.entryId != null) {
          await jellyfin.removeItemsFromPlaylist(
            playlistId: status.playlist.id!,
            entryIds: [status.entryId!],
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Removido de $playlistName'), backgroundColor: Colors.orange),
            );
          }
        }
      } else {
        // Agregar a la playlist
        await jellyfin.addItemstoPlaylist(
          playlistId: status.playlist.id!,
          ids: [widget.itemId],
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Agregado a $playlistName'), backgroundColor: Colors.green),
          );
        }
      }
      
      // Recargar el estado para actualizar los iconos visualmente si el usuario no cierra el modal
      _loadPlaylists();
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E), // Tema oscuro
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle gris en la parte superior
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              'Agregar a playlist',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          const Divider(color: Colors.white24),
          
          // Opción Crear Nueva Playlist
          ListTile(
            leading: Icon(Icons.add_circle_outline, color: _synapColor),
            title: Text(
              'Crear playlist',
              style: TextStyle(fontWeight: FontWeight.w600, color: _synapColor),
            ),
            onTap: () async {
              Navigator.pop(context);
              await showDialog(
                context: context,
                builder: (context) => const CreatePlaylistDialog(),
              );
            },
          ),
          
          const Divider(color: Colors.white24),
          
          // Lista de playlists con Toggle
          Flexible(
            child: FutureBuilder<List<PlaylistStatus>>(
              future: _playlistsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(_synapColor),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No tienes playlists.', style: TextStyle(color: Colors.grey)),
                  );
                }

                final statuses = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: statuses.length,
                  itemBuilder: (context, index) {
                    final status = statuses[index];
                    final playlist = status.playlist;
                    
                    return ListTile(
                      leading: Icon(
                        status.containsItem ? Icons.check_circle : Icons.queue_music, 
                        color: status.containsItem ? _synapColor : Colors.grey[400],
                      ),
                      title: Text(
                        playlist.name ?? 'Sin nombre',
                        style: TextStyle(
                          color: status.containsItem ? _synapColor : Colors.white,
                          fontWeight: status.containsItem ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      onTap: () => _togglePlaylist(status),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
