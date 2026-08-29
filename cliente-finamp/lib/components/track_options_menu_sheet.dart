import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/jellyfin_api_helper.dart';
import 'add_to_playlist_sheet.dart';

class TrackOptionsMenuSheet extends StatelessWidget {
  final String itemId;
  final String? playlistId;
  final String? playlistItemId;
  final VoidCallback? onTrackRemoved;

  const TrackOptionsMenuSheet({
    Key? key,
    required this.itemId,
    this.playlistId,
    this.playlistItemId,
    this.onTrackRemoved,
  }) : super(key: key);

  Future<void> _removeFromPlaylist(BuildContext context) async {
    if (playlistId == null || playlistItemId == null) return;
    
    try {
      await GetIt.instance<JellyfinApiHelper>().removeItemsFromPlaylist(
        playlistId: playlistId!,
        entryIds: [playlistItemId!],
      );
      
      if (context.mounted) {
        Navigator.pop(context); // Cierra modal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Canción eliminada de la playlist'), backgroundColor: Colors.orange),
        );
        if (onTrackRemoved != null) {
          onTrackRemoved!();
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color synapColor = Color(0xFF144477);
    final bool isInsidePlaylist = playlistId != null && playlistItemId != null;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E), // Tema oscuro para el modal
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
          const SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.playlist_add, color: synapColor),
            title: const Text(
              'Agregar a otra playlist',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context); // Cierra este modal
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => AddToPlaylistSheet(itemId: itemId),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.queue_music, color: Colors.white70),
            title: const Text(
              'Reproducir siguiente',
              style: TextStyle(color: Colors.white70),
            ),
            onTap: () {
              Navigator.pop(context);
              print('TODO: Implementar Reproducir siguiente');
            },
          ),
          if (isInsidePlaylist)
            ListTile(
              leading: const Icon(Icons.remove_circle_outline, color: Colors.orange),
              title: const Text(
                'Quitar de esta playlist',
                style: TextStyle(color: Colors.orange),
              ),
              onTap: () => _removeFromPlaylist(context),
            )
          else
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.white70),
              title: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                Navigator.pop(context);
                print('TODO: Implementar Eliminar Global');
              },
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
