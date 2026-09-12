import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import '../../services/downloads_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/music_player_background_task.dart';
import '../../screens/album_screen.dart';
import '../../screens/synap_music/artist_profile_screen.dart';
import '../add_to_playlist_sheet.dart';
import '../AlbumScreen/download_dialog.dart';
import 'sleep_timer_dialog.dart';
import 'sleep_timer_cancel_dialog.dart';

class PlayerOptionsMenuSheet extends StatelessWidget {
  final MediaItem mediaItem;

  const PlayerOptionsMenuSheet({
    Key? key,
    required this.mediaItem,
  }) : super(key: key);

  static void show(BuildContext context, MediaItem mediaItem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PlayerOptionsMenuSheet(mediaItem: mediaItem),
    );
  }

  BaseItemDto? _extractSongDto() {
    final extras = mediaItem.extras;
    if (extras != null && extras['itemJson'] != null) {
      try {
        return BaseItemDto.fromJson(extras['itemJson']);
      } catch (_) {}
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final songDto = _extractSongDto();
    final trackId = songDto?.id ?? mediaItem.id;
    final title = songDto?.name ?? mediaItem.title;
    final artistName = (songDto?.artists != null && songDto!.artists!.isNotEmpty)
        ? songDto.artists!.first
        : (songDto?.albumArtist ?? mediaItem.artist ?? '');
    final albumName = mediaItem.album ?? songDto?.album ?? '';

    final downloadsHelper = GetIt.instance<DownloadsHelper>();
    final isDownloaded = downloadsHelper.getDownloadedSong(trackId) != null;
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final isSleepActive = audioHandler.sleepTimer.value != null;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF161616),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF444444),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header con información de la canción
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: mediaItem.artUri != null
                          ? Image.network(
                              mediaItem.artUri.toString(),
                              width: 46,
                              height: 46,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 46,
                                height: 46,
                                color: const Color(0xFF222222),
                                child: const Icon(Icons.music_note, color: Color(0xFFA0A0A0)),
                              ),
                            )
                          : Container(
                              width: 46,
                              height: 46,
                              color: const Color(0xFF222222),
                              child: const Icon(Icons.music_note, color: Color(0xFFA0A0A0)),
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            artistName.isNotEmpty ? artistName : 'Artista desconocido',
                            style: const TextStyle(
                              color: Color(0xFFA0A0A0),
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Color(0xFF262626), height: 16, thickness: 1),

              // 1. Agregar a la playlist
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                leading: const Icon(Icons.playlist_add, color: Colors.white, size: 24),
                title: const Text(
                  'Agregar a la playlist',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFFA0A0A0), size: 20),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => AddToPlaylistSheet(itemId: trackId),
                  );
                },
              ),

              // 2. Ver álbum
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                leading: const Icon(Icons.album_outlined, color: Colors.white, size: 24),
                title: const Text(
                  'Ver álbum',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                subtitle: albumName.isNotEmpty
                    ? Text(
                        albumName,
                        style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: const Icon(Icons.chevron_right, color: Color(0xFFA0A0A0), size: 20),
                onTap: () async {
                  Navigator.pop(context);
                  await _navigateToAlbum(context, songDto, albumName);
                },
              ),

              // 3. Ver artista
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                leading: const Icon(Icons.person_outline, color: Colors.white, size: 24),
                title: const Text(
                  'Ver artista',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                subtitle: artistName.isNotEmpty
                    ? Text(
                        artistName,
                        style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: const Icon(Icons.chevron_right, color: Color(0xFFA0A0A0), size: 20),
                onTap: () {
                  Navigator.pop(context);
                  if (artistName.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ArtistProfileScreen(artistName: artistName),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Artista no disponible'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),

              // 4. Descargar
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                leading: Icon(
                  isDownloaded ? Icons.download_done : Icons.file_download_outlined,
                  color: isDownloaded ? const Color(0xFF8B93FF) : Colors.white,
                  size: 24,
                ),
                title: Text(
                  isDownloaded ? 'Descargado en el dispositivo' : 'Descargar',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  isDownloaded
                      ? 'Disponible para escuchar sin conexión'
                      : 'Descargar para escuchar sin conexión',
                  style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFFA0A0A0), size: 20),
                onTap: () async {
                  Navigator.pop(context);
                  if (isDownloaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Esta canción ya está descargada en el dispositivo'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xFF1E1E1E),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    await _downloadSongOffline(context, songDto, trackId, title);
                  }
                },
              ),

              // 5. Temporizador de sueño
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                leading: Icon(
                  isSleepActive ? Icons.mode_night : Icons.mode_night_outlined,
                  color: isSleepActive ? const Color(0xFF8B93FF) : Colors.white,
                  size: 24,
                ),
                title: const Text(
                  'Temporizador de sueño',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                subtitle: isSleepActive
                    ? const Text(
                        'Temporizador activo',
                        style: TextStyle(color: Color(0xFF8B93FF), fontSize: 12),
                      )
                    : null,
                trailing: const Icon(Icons.chevron_right, color: Color(0xFFA0A0A0), size: 20),
                onTap: () {
                  Navigator.pop(context);
                  if (isSleepActive) {
                    showDialog(
                      context: context,
                      builder: (context) => const SleepTimerCancelDialog(),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => const SleepTimerDialog(),
                    );
                  }
                },
              ),

              // 6. Solicitar modificación
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                leading: const Icon(Icons.flag_outlined, color: Colors.white, size: 24),
                title: const Text(
                  'Solicitar modificación',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Reportar letra o metadatos incorrectos',
                  style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFFA0A0A0), size: 20),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Solicitud de modificación: Próximamente disponible'),
                      duration: Duration(seconds: 3),
                      backgroundColor: Color(0xFF1E1E1E),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              // Botón inferior Ignorar
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: const Text(
                    'Ignorar',
                    style: TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToAlbum(
    BuildContext context,
    BaseItemDto? songDto,
    String albumName,
  ) async {
    final jellyfin = GetIt.instance<JellyfinApiHelper>();
    final albumId = songDto?.albumId ?? songDto?.parentId;

    if (albumId != null && albumId.isNotEmpty) {
      try {
        final album = await jellyfin.getItemById(albumId);
        if (album != null && context.mounted) {
          Navigator.of(context).pushNamed(AlbumScreen.routeName, arguments: album);
          return;
        }
      } catch (_) {}
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            albumName.isNotEmpty
                ? 'Álbum "$albumName" no disponible en el catálogo local'
                : 'Información del álbum no disponible',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF1E1E1E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _downloadSongOffline(
    BuildContext context,
    BaseItemDto? songDto,
    String trackId,
    String title,
  ) async {
    try {
      final jellyfin = GetIt.instance<JellyfinApiHelper>();
      BaseItemDto itemToDownload;
      if (songDto != null) {
        itemToDownload = songDto;
      } else {
        final fetched = await jellyfin.getItemById(trackId);
        itemToDownload = fetched ??
            BaseItemDto(
              id: trackId,
              name: title,
              type: 'Audio',
            );
      }

      final downloadLocation =
          FinampSettingsHelper.finampSettings.internalSongDir;
      BaseItemDto parentItem;
      final albumId = itemToDownload.albumId ?? itemToDownload.parentId;
      if (albumId != null && albumId.isNotEmpty) {
        try {
          parentItem = (await jellyfin.getItemById(albumId)) ?? itemToDownload;
        } catch (_) {
          parentItem = itemToDownload;
        }
      } else {
        parentItem = itemToDownload;
      }

      await checkedAddDownloads(
        context,
        downloadLocation: downloadLocation,
        parents: [parentItem],
        items: [
          [itemToDownload]
        ],
        viewId: parentItem.id,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Descargando "$title" para escuchar sin conexión'),
            duration: const Duration(seconds: 3),
            backgroundColor: const Color(0xFF1E1E1E),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar descarga offline: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: const Color(0xFFC62828),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
