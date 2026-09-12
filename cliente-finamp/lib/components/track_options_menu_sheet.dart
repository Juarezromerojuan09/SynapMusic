import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/jellyfin_api_helper.dart';
import '../services/audio_service_helper.dart';
import '../services/playback_download_coordinator.dart';
import 'add_to_playlist_sheet.dart';
import '../services/synap_api_service.dart';
import 'fix_metadata_dialog.dart';

class TrackOptionsMenuSheet extends StatefulWidget {
  final String? itemId;
  final String? playlistId;
  final String? playlistItemId;
  final VoidCallback? onTrackRemoved;
  final String? title;
  final String? artist;
  final String? queryString;
  final String? coverUrl;

  const TrackOptionsMenuSheet({
    Key? key,
    this.itemId,
    this.playlistId,
    this.playlistItemId,
    this.onTrackRemoved,
    this.title,
    this.artist,
    this.queryString,
    this.coverUrl,
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
    if (widget.itemId == null) {
      if (mounted) {
        setState(() {
          _isEditable = false;
          _isLoadingEditable = false;
        });
      }
      return;
    }

    final synapApi = SynapApiService();
    final editable = await synapApi.checkMetadataEditable(widget.itemId!);
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
    const Color synapColor = Color(0xFF8B93FF);
    final bool isInsidePlaylist = widget.playlistId != null && widget.playlistItemId != null;
    final bool isLocal = widget.itemId != null;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A), // Tema oscuro para el modal
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
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

            if (widget.title != null && widget.title!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  children: [
                    Text(
                      widget.title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    if (widget.artist != null && widget.artist!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.artist!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 8),
                    const Divider(color: Colors.white12, height: 1),
                  ],
                ),
              ),

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
                      itemId: widget.itemId!,
                      currentTitle: widget.title ?? '',
                    ),
                  );
                },
              ),

            ListTile(
              leading: Icon(Icons.playlist_add, color: synapColor),
              title: Text(
                isLocal ? 'Agregar a otra playlist' : 'Agregar a playlist',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context); // Cierra este modal
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => AddToPlaylistSheet(
                    itemId: widget.itemId,
                    title: widget.title,
                    artist: widget.artist,
                    queryString: widget.queryString,
                    coverUrl: widget.coverUrl,
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.queue_music, color: Colors.white70),
              title: const Text(
                'Reproducir siguiente',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () async {
                Navigator.pop(context);
                if (isLocal) {
                  try {
                    final jellyfin = GetIt.instance<JellyfinApiHelper>();
                    final item = await jellyfin.getItemById(widget.itemId!);
                    if (item != null) {
                      await GetIt.instance<AudioServiceHelper>().insertQueueItemsNext([item]);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('"${item.name ?? 'Canción'}" se reproducirá a continuación'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: const Color(0xFF1E1E1E),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al agregar a la cola: $e'), backgroundColor: Colors.red),
                      );
                    }
                  }
                } else {
                  // Canción remota: descargar y luego agregar como siguiente
                  await PlaybackDownloadCoordinator().downloadAndPlayNext(
                    context: context,
                    title: widget.title ?? '',
                    artist: widget.artist ?? '',
                    queryString: widget.queryString,
                    coverUrl: widget.coverUrl,
                  );
                }
              },
            ),

            if (!isLocal)
              ListTile(
                leading: const Icon(Icons.download, color: Colors.white70),
                title: const Text(
                  'Descargar a Biblioteca',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  Navigator.pop(context);
                  final cleanQuery = (widget.queryString != null && widget.queryString!.isNotEmpty)
                      ? widget.queryString!
                      : '${widget.title ?? ''} ${widget.artist ?? ''}';
                  SynapApiService().downloadMedia(cleanQuery);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Descargando "${widget.title ?? 'canción'}" a la biblioteca...'),
                      duration: const Duration(seconds: 3),
                      backgroundColor: const Color(0xFF1E1E1E),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

            if (isLocal)
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
