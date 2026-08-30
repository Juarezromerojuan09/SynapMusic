import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/jellyfin_api_helper.dart';
import 'add_to_playlist_sheet.dart';

import '../services/synap_api_service.dart';
import 'fix_metadata_dialog.dart';

class TrackOptionsMenuSheet extends StatefulWidget {
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

  @override
  State<TrackOptionsMenuSheet> createState() => _TrackOptionsMenuSheetState();
}

class _TrackOptionsMenuSheetState extends State<TrackOptionsMenuSheet> {
  bool _isEditable = false;
  bool _isLoadingEditable = true;

  @override
  void initState() {
    super.initState();
    _checkEditable();
  }

  Future<void> _checkEditable() async {
    final synapApi = SynapApiService();
    final editable = await synapApi.checkMetadataEditable(widget.itemId);
    if (mounted) {
      setState(() {
        _isEditable = editable;
        _isLoadingEditable = false;
      });
    }
  }

  Future<void> _removeFromPlaylist(BuildContext context) async {
    if (widget.playlistId == null || widget.playlistItemId == null) return;
    
    try {
      await GetIt.instance<JellyfinApiHelper>().removeItemsFromPlaylist(
        playlistId: widget.playlistId!,
        entryIds: [widget.playlistItemId!],
      );
      
      if (context.mounted) {
        Navigator.pop(context); // Cierra modal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Canción eliminada de la playlist'), backgroundColor: Colors.orange),
        );
        if (widget.onTrackRemoved != null) {
          widget.onTrackRemoved!();
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
    final bool isInsidePlaylist = widget.playlistId != null && widget.playlistItemId != null;

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

          if (!_isLoadingEditable && _isEditable)
            ListTile(
              leading: const Icon(Icons.auto_fix_high, color: Colors.blueAccent),
              title: const Text(
                'Corregir Metadatos',
                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => FixMetadataDialog(
                    itemId: widget.itemId,
                    currentTitle: '', // Se podría pasar si lo tuviéramos, pero está bien así
                  ),
                );
              },
            ),
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
                builder: (_) => AddToPlaylistSheet(itemId: widget.itemId),
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
