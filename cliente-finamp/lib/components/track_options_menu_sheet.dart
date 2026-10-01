import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/jellyfin_api_helper.dart';
import '../services/audio_service_helper.dart';
import '../services/playback_download_coordinator.dart';
import 'add_to_playlist_sheet.dart';
import 'request_metadata_sheet.dart';
import '../services/synap_api_service.dart';
import 'fix_metadata_dialog.dart';
import '../screens/synap_music/artist_profile_screen.dart';

class TrackOptionsMenuSheet extends StatefulWidget {
  final String? itemId;
  final String? playlistId;
  final String? playlistItemId;
  final VoidCallback? onTrackRemoved;
  final String? title;
  final String? artist;
  final String? queryString;
  final String? coverUrl;
  final String? currentArtist;
  final bool showArtistProfile;

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
    this.currentArtist,
    this.showArtistProfile = true,
  }) : super(key: key);

  @override
  State<TrackOptionsMenuSheet> createState() => _TrackOptionsMenuSheetState();
}

class _TrackOptionsMenuSheetState extends State<TrackOptionsMenuSheet> {
  bool _isEditable = false;
  bool _isLoadingEditable = true;
  String? _loadedTitle;
  String? _loadedArtist;

  @override
  void initState() {
    super.initState();
    _checkEditable();
    _loadTrackDetailsIfNeeded();
  }

  Future<void> _loadTrackDetailsIfNeeded() async {
    if ((widget.artist == null || widget.artist!.isEmpty) && widget.itemId != null) {
      try {
        final jellyfin = GetIt.instance<JellyfinApiHelper>();
        final item = await jellyfin.getItemById(widget.itemId!);
        if (item != null && mounted) {
          setState(() {
            _loadedTitle ??= item.name;
            _loadedArtist ??= (item.artists?.isNotEmpty == true)
                ? item.artists![0]
                : (item.albumArtist ?? '');
          });
        }
      } catch (_) {}
    }
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

    final String? effectiveTitle = widget.title ?? _loadedTitle;
    final String effectiveArtist = (widget.artist ?? _loadedArtist ?? '').trim();
    final bool hasArtist = effectiveArtist.isNotEmpty &&
        effectiveArtist.toLowerCase() != 'desconocido' &&
        effectiveArtist.toLowerCase() != 'unknown' &&
        effectiveArtist.toLowerCase() != 'unknown artist';

    final bool isSameArtist = widget.currentArtist != null &&
        widget.currentArtist!.trim().isNotEmpty &&
        (widget.currentArtist!.trim().toLowerCase() == effectiveArtist.toLowerCase() ||
            effectiveArtist.toLowerCase().contains(widget.currentArtist!.trim().toLowerCase()) ||
            widget.currentArtist!.trim().toLowerCase().contains(effectiveArtist.toLowerCase()));

    final bool shouldShowArtist = widget.showArtistProfile && hasArtist && !isSameArtist;

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

            if (effectiveTitle != null && effectiveTitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  children: [
                    Text(
                      effectiveTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    if (effectiveArtist.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        effectiveArtist,
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
                      currentTitle: effectiveTitle ?? '',
                    ),
                  );
                },
              ),

            if (isLocal)
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: Colors.amber),
                title: const Text(
                  'Reportar letra o metadatos incorrectos',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Reporta letra o metadatos para corregir la pista',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => RequestMetadataSheet(
                      trackId: widget.itemId!,
                      initialTitle: effectiveTitle ?? '',
                      initialArtist: effectiveArtist,
                    ),
                  );
                },
              ),

            if (shouldShowArtist)
              ListTile(
                leading: const Icon(Icons.person_outline, color: Colors.white70),
                title: const Text(
                  'Perfil del artista',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                subtitle: effectiveArtist.isNotEmpty
                    ? Text(
                        effectiveArtist,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ArtistProfileScreen(artistName: effectiveArtist),
                    ),
                  );
                },
              ),

            ListTile(
              leading: Icon(Icons.playlist_add, color: synapColor),
              title: const Text(
                'Agregar a playlist',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context); // Cierra este modal
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => AddToPlaylistSheet(
                    itemId: widget.itemId,
                    title: effectiveTitle,
                    artist: effectiveArtist,
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
                    title: effectiveTitle ?? '',
                    artist: effectiveArtist,
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
                      : '${effectiveTitle ?? ''} $effectiveArtist'.trim();
                  SynapApiService().downloadMedia(cleanQuery);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Descargando "${effectiveTitle ?? 'canción'}" a la biblioteca...'),
                      duration: const Duration(seconds: 3),
                      backgroundColor: const Color(0xFF1E1E1E),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
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
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
