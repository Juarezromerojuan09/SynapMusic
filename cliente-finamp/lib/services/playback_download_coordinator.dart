import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/jellyfin_models.dart';
import 'audio_service_helper.dart';
import 'jellyfin_api_helper.dart';
import 'synap_api_service.dart';
import 'likes_playlist_helper.dart';
import 'synap_events.dart';

class LocalTrackReadyEvent {
  final String title;
  final String artist;
  final String localId;
  final dynamic jellyfinItem;

  LocalTrackReadyEvent({
    required this.title,
    required this.artist,
    required this.localId,
    this.jellyfinItem,
  });
}

class PlaybackDownloadCoordinator {
  static final PlaybackDownloadCoordinator _instance = PlaybackDownloadCoordinator._internal();
  factory PlaybackDownloadCoordinator() => _instance;
  PlaybackDownloadCoordinator._internal();

  final SynapApiService _apiService = SynapApiService();
  int _latestJobId = 0;

  // Stream broadcast para notificar a cualquier pantalla activa
  final StreamController<LocalTrackReadyEvent> _trackReadyController =
      StreamController<LocalTrackReadyEvent>.broadcast();
  Stream<LocalTrackReadyEvent> get onTrackReady => _trackReadyController.stream;

  // Claves únicas o títulos en proceso de descarga
  final Set<String> _activeDownloads = {};
  final ValueNotifier<Set<String>> activeDownloadsNotifier = ValueNotifier<Set<String>>({});

  // Registro de playlists a las que debe agregarse una canción cuando finalice la descarga
  final Map<String, Set<String>> _pendingPlaylistTargets = {};

  static String buildKey({
    required String title,
    String? artist,
    String? queryString,
    String? trackId,
  }) {
    if (queryString != null && queryString.trim().isNotEmpty) {
      return queryString.trim().toLowerCase();
    }
    if (trackId != null && trackId.trim().isNotEmpty) {
      return trackId.trim().toLowerCase();
    }
    final t = title.trim().toLowerCase();
    final a = (artist ?? '').trim().toLowerCase();
    if (a.isNotEmpty) {
      return '$t - $a';
    }
    return t;
  }

  bool isDownloading(String keyOrTitle) {
    final k = keyOrTitle.trim().toLowerCase();
    return _activeDownloads.contains(k);
  }

  bool isDownloadingTrack({
    required String title,
    String? artist,
    String? queryString,
    String? trackId,
  }) {
    final key = buildKey(title: title, artist: artist, queryString: queryString, trackId: trackId);
    return _activeDownloads.contains(key);
  }

  String normalize(String text) => text.toLowerCase().trim();
  String _normalize(String text) => normalize(text);

  void _addActiveDownload(String key) {
    _activeDownloads.add(key.trim().toLowerCase());
    activeDownloadsNotifier.value = Set.from(_activeDownloads);
  }

  void _removeActiveDownload(String key) {
    _activeDownloads.remove(key.trim().toLowerCase());
    activeDownloadsNotifier.value = Set.from(_activeDownloads);
  }

  Future<void> downloadAndAutoPlay({
    required BuildContext context,
    required String title,
    required String artist,
    String? queryString,
    String? coverUrl,
  }) async {
    final trackKey = buildKey(title: title, artist: artist, queryString: queryString);

    // Evitar descargas o reproducciones duplicadas si la canción ya se está procesando
    if (_activeDownloads.contains(trackKey)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Descargando "$title"... Se reproducirá en breve.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: const Color(0xFF1E1E1E),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    _addActiveDownload(trackKey);

    final cleanQuery = (queryString != null && queryString.isNotEmpty)
        ? queryString
        : '$title $artist';
    final currentJob = ++_latestJobId;

    // Notificación visual al usuario
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Descargando "$title"... Se reproducirá en breve.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 10),
          backgroundColor: const Color(0xFF1E1E1E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    _apiService.downloadMedia(cleanQuery).then((success) {
      if (!success) {
        print('Fallo al solicitar descarga para $title');
      }
    });

    // Iniciar sondeo en segundo plano
    _pollAndPlayWhenReady(
      jobId: currentJob,
      title: title,
      artist: artist,
      trackKey: trackKey,
      coverUrl: coverUrl,
      context: context,
    );
  }

  Future<void> _pollAndPlayWhenReady({
    required int jobId,
    required String title,
    required String artist,
    required String trackKey,
    String? coverUrl,
    required BuildContext context,
  }) async {
    const int maxAttempts = 75; // hasta ~150 segundos máximo
    const Duration pollInterval = Duration(milliseconds: 2000);

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      await Future.delayed(pollInterval);

      try {
        final check = await _apiService.checkLocalTrack(title, artist);
        if (check != null && check['exists'] == true && check['local_id'] != null) {
          final isReady = check['is_ready'] == true;
          // Si Jellyfin recién detectó el archivo pero aún está extrayendo metadatos/portada (is_ready == false),
          // esperar 1-2 ciclos más para obtener la portada nativa de Jellyfin si aún tenemos tiempo.
          if (!isReady && attempt < 3) {
            continue;
          }

          _removeActiveDownload(trackKey);

          final localId = check['local_id'].toString();
          final jellyfinItem = check['jellyfin_item'];

          // Notificar a las pantallas abiertas que esta pista ya está disponible en local
          _trackReadyController.add(LocalTrackReadyEvent(
            title: title,
            artist: artist,
            localId: localId,
            jellyfinItem: jellyfinItem,
          ));

          // Si había solicitudes de agregar a playlist mientras se descargaba, procesarlas exactamente una vez
          final pendingPlaylists = _pendingPlaylistTargets.remove(trackKey);
          if (pendingPlaylists != null && pendingPlaylists.isNotEmpty) {
            final jellyfin = GetIt.instance<JellyfinApiHelper>();
            for (final pid in pendingPlaylists) {
              try {
                await jellyfin.addItemstoPlaylist(
                  playlistId: pid,
                  ids: [localId],
                );
              } catch (e) {
                print('Error al agregar a playlist pendiente ($pid): $e');
              }
            }
            SynapEvents.fireLibraryRefresh();
          }

          // Solo reproducir si esta pista sigue siendo la última seleccionada por el usuario
          if (_latestJobId == jobId) {
            BaseItemDto? trackDto;
            try {
              final jellyfinHelper = GetIt.instance<JellyfinApiHelper>();
              trackDto = await jellyfinHelper.getItemById(localId);
            } catch (e) {
              print('Error al obtener item completo de Jellyfin: $e');
            }

            if (trackDto == null && jellyfinItem != null) {
              try {
                trackDto = BaseItemDto.fromJson(Map<String, dynamic>.from(jellyfinItem));
              } catch (_) {}
            }

            trackDto ??= BaseItemDto(
              id: localId,
              name: title,
              type: 'Audio',
            );

            // Garantizar metadatos completos para que la UI nunca muestre "Sin artista" o "Unknown Album"
            final finalArtists = (trackDto.artists != null && trackDto.artists!.isNotEmpty)
                ? trackDto.artists
                : [artist];
            final finalAlbumArtist = (trackDto.albumArtist != null && trackDto.albumArtist!.isNotEmpty)
                ? trackDto.albumArtist
                : artist;
            final finalTitle = (trackDto.name != null && trackDto.name!.isNotEmpty)
                ? trackDto.name
                : title;
            final finalAlbum = (trackDto.album != null && trackDto.album!.isNotEmpty)
                ? trackDto.album
                : title;
            final finalArtistItems = (trackDto.artistItems != null && trackDto.artistItems!.isNotEmpty)
                ? trackDto.artistItems
                : [NameIdPair(name: artist, id: "")];

            // Garantizar respaldo de portada en overview si está disponible
            final fallbackOverview = (coverUrl != null && coverUrl.isNotEmpty)
                ? coverUrl
                : trackDto.overview;

            final enrichedDto = BaseItemDto(
              id: trackDto.id,
              name: finalTitle,
              type: 'Audio',
              artists: finalArtists,
              albumArtist: finalAlbumArtist,
              artistItems: finalArtistItems,
              album: finalAlbum,
              albumId: trackDto.albumId,
              albumPrimaryImageTag: trackDto.albumPrimaryImageTag,
              imageTags: trackDto.imageTags,
              parentPrimaryImageItemId: trackDto.parentPrimaryImageItemId,
              overview: fallbackOverview,
              runTimeTicks: trackDto.runTimeTicks,
              mediaSources: trackDto.mediaSources,
            );

            final audioHandler = GetIt.instance<AudioServiceHelper>();
            await audioHandler.replaceQueueWithItem(itemList: [enrichedDto]);

            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Reproduciendo "$title"',
                    style: const TextStyle(color: Colors.white),
                  ),
                  duration: const Duration(seconds: 2),
                  backgroundColor: const Color(0xFF2E7D32),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
          return;
        }
      } catch (e) {
        print('Error en sondeo de canción descargada: $e');
      }
    }

    _removeActiveDownload(trackKey);
    _pendingPlaylistTargets.remove(trackKey);
    if (_latestJobId == jobId && context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La descarga de "$title" tardó demasiado o no pudo completarse.'),
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xFFC62828),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> downloadAndAddToLikes({
    required String title,
    required String artist,
    String? queryString,
    String? coverUrl,
    BuildContext? context,
  }) async {
    final trackKey = buildKey(title: title, artist: artist, queryString: queryString);
    final cleanQuery = (queryString != null && queryString.isNotEmpty)
        ? queryString
        : '$title $artist';

    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF8B93FF)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Guardando "$title" en My likes (descargando)...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xFF1E1E1E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (_activeDownloads.contains(trackKey)) {
      return;
    }

    _addActiveDownload(trackKey);
    _apiService.downloadMedia(cleanQuery).then((success) {
      if (!success) {
        print('Fallo al solicitar descarga para My likes de $title');
      }
    });

    _pollAndAddToLikesWhenReady(
      title: title,
      artist: artist,
      trackKey: trackKey,
      context: context,
    );
  }

  Future<void> _pollAndAddToLikesWhenReady({
    required String title,
    required String artist,
    required String trackKey,
    BuildContext? context,
  }) async {
    const int maxAttempts = 75; // hasta ~150 segundos máximo
    const Duration pollInterval = Duration(milliseconds: 2000);

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      await Future.delayed(pollInterval);

      try {
        final check = await _apiService.checkLocalTrack(title, artist);
        if (check != null && check['exists'] == true && check['local_id'] != null) {
          final isReady = check['is_ready'] == true;
          if (!isReady && attempt < 3) {
            continue;
          }

          _removeActiveDownload(trackKey);
          final localId = check['local_id'].toString();
          final jellyfinItem = check['jellyfin_item'];

          _trackReadyController.add(LocalTrackReadyEvent(
            title: title,
            artist: artist,
            localId: localId,
            jellyfinItem: jellyfinItem,
          ));

          final key = LikesPlaylistHelper.normalizeKey(title, artist);
          if (LikesPlaylistHelper.pendingLikeKeys.contains(key) ||
              LikesPlaylistHelper.likedSongKeys.value.contains(key)) {
            await LikesPlaylistHelper.addSongToLikes(localId, title: title, artist: artist);
            LikesPlaylistHelper.pendingLikeKeys.remove(key);
            if (context != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"$title" se guardó en My likes'),
                  duration: const Duration(seconds: 3),
                  backgroundColor: const Color(0xFF1E1E1E),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
          return;
        }
      } catch (e) {
        print('Error en sondeo para My likes ($title): $e');
      }
    }

    _removeActiveDownload(trackKey);
    final key = LikesPlaylistHelper.normalizeKey(title, artist);
    LikesPlaylistHelper.pendingLikeKeys.remove(key);
    final updatedKeys = Set<String>.from(LikesPlaylistHelper.likedSongKeys.value)..remove(key);
    LikesPlaylistHelper.likedSongKeys.value = updatedKeys;

    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo completar la descarga de "$title" para My likes.'),
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xFFC62828),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> downloadAndPlayNext({
    required BuildContext context,
    required String title,
    required String artist,
    String? queryString,
    String? coverUrl,
  }) async {
    final trackKey = buildKey(title: title, artist: artist, queryString: queryString);
    final cleanQuery = (queryString != null && queryString.isNotEmpty)
        ? queryString
        : '$title $artist';

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF8B93FF)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Agregando "$title" a Reproducir siguiente (descargando)...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xFF1E1E1E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (_activeDownloads.contains(trackKey)) {
      return;
    }

    _addActiveDownload(trackKey);
    _apiService.downloadMedia(cleanQuery).then((success) {
      if (!success) {
        print('Fallo al solicitar descarga para PlayNext de $title');
      }
    });

    _pollAndPlayNextWhenReady(
      title: title,
      artist: artist,
      trackKey: trackKey,
      coverUrl: coverUrl,
      context: context,
    );
  }

  Future<void> _pollAndPlayNextWhenReady({
    required String title,
    required String artist,
    required String trackKey,
    String? coverUrl,
    required BuildContext context,
  }) async {
    const int maxAttempts = 75;
    const Duration pollInterval = Duration(milliseconds: 2000);

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      await Future.delayed(pollInterval);

      try {
        final check = await _apiService.checkLocalTrack(title, artist);
        if (check != null && check['exists'] == true && check['local_id'] != null) {
          final isReady = check['is_ready'] == true;
          if (!isReady && attempt < 3) {
            continue;
          }

          _removeActiveDownload(trackKey);
          final localId = check['local_id'].toString();
          final jellyfinItem = check['jellyfin_item'];

          _trackReadyController.add(LocalTrackReadyEvent(
            title: title,
            artist: artist,
            localId: localId,
            jellyfinItem: jellyfinItem,
          ));

          BaseItemDto? trackDto;
          try {
            final jellyfinHelper = GetIt.instance<JellyfinApiHelper>();
            trackDto = await jellyfinHelper.getItemById(localId);
          } catch (e) {
            print('Error al obtener item completo de Jellyfin para PlayNext: $e');
          }

          if (trackDto == null && jellyfinItem != null) {
            try {
              trackDto = BaseItemDto.fromJson(Map<String, dynamic>.from(jellyfinItem));
            } catch (_) {}
          }

          trackDto ??= BaseItemDto(
            id: localId,
            name: title,
            type: 'Audio',
          );

          final finalArtists = (trackDto.artists != null && trackDto.artists!.isNotEmpty)
              ? trackDto.artists
              : [artist];
          final finalAlbumArtist = (trackDto.albumArtist != null && trackDto.albumArtist!.isNotEmpty)
              ? trackDto.albumArtist
              : artist;
          final finalTitle = (trackDto.name != null && trackDto.name!.isNotEmpty)
              ? trackDto.name
              : title;
          final finalAlbum = (trackDto.album != null && trackDto.album!.isNotEmpty)
              ? trackDto.album
              : title;
          final finalArtistItems = (trackDto.artistItems != null && trackDto.artistItems!.isNotEmpty)
              ? trackDto.artistItems
              : [NameIdPair(name: artist, id: "")];
          final fallbackOverview = (coverUrl != null && coverUrl.isNotEmpty)
              ? coverUrl
              : trackDto.overview;

          final enrichedDto = BaseItemDto(
            id: trackDto.id,
            name: finalTitle,
            type: 'Audio',
            artists: finalArtists,
            albumArtist: finalAlbumArtist,
            artistItems: finalArtistItems,
            album: finalAlbum,
            albumId: trackDto.albumId,
            albumPrimaryImageTag: trackDto.albumPrimaryImageTag,
            imageTags: trackDto.imageTags,
            parentPrimaryImageItemId: trackDto.parentPrimaryImageItemId,
            overview: fallbackOverview,
            runTimeTicks: trackDto.runTimeTicks,
            mediaSources: trackDto.mediaSources,
          );

          final audioHandler = GetIt.instance<AudioServiceHelper>();
          await audioHandler.insertQueueItemsNext([enrichedDto]);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '"$title" se reproducirá a continuación',
                  style: const TextStyle(color: Colors.white),
                ),
                duration: const Duration(seconds: 3),
                backgroundColor: const Color(0xFF1E1E1E),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }
      } catch (e) {
        print('Error en sondeo para PlayNext ($title): $e');
      }
    }

    _removeActiveDownload(trackKey);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo completar la descarga de "$title" para Reproducir siguiente.'),
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xFFC62828),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> downloadAndAddToPlaylist({
    required String playlistId,
    required String playlistName,
    required String title,
    required String artist,
    String? queryString,
    String? coverUrl,
    BuildContext? context,
  }) async {
    final trackKey = buildKey(title: title, artist: artist, queryString: queryString);
    _pendingPlaylistTargets.putIfAbsent(trackKey, () => <String>{}).add(playlistId);

    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF8B93FF)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Agregando "$title" a $playlistName (descargando)...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xFF1E1E1E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (_activeDownloads.contains(trackKey)) {
      // Ya se encuentra en proceso de descarga; se agregará a la playlist automáticamente al finalizar.
      return;
    }

    _addActiveDownload(trackKey);

    final cleanQuery = (queryString != null && queryString.isNotEmpty)
        ? queryString
        : '$title $artist';

    _apiService.downloadMedia(cleanQuery).then((success) {
      if (!success) {
        print('Fallo al solicitar descarga para $title');
      }
    });

    _pollAndAddToPlaylistWhenReady(
      playlistId: playlistId,
      playlistName: playlistName,
      title: title,
      artist: artist,
      trackKey: trackKey,
      context: context,
    );
  }

  Future<void> _pollAndAddToPlaylistWhenReady({
    required String playlistId,
    required String playlistName,
    required String title,
    required String artist,
    required String trackKey,
    BuildContext? context,
  }) async {
    const int maxAttempts = 75;
    const Duration pollInterval = Duration(milliseconds: 2000);

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      await Future.delayed(pollInterval);

      try {
        final check = await _apiService.checkLocalTrack(title, artist);
        if (check != null && check['exists'] == true && check['local_id'] != null) {
          final isReady = check['is_ready'] == true;
          if (!isReady && attempt < 3) {
            continue;
          }

          _removeActiveDownload(trackKey);
          final localId = check['local_id'].toString();
          final jellyfinItem = check['jellyfin_item'];

          _trackReadyController.add(LocalTrackReadyEvent(
            title: title,
            artist: artist,
            localId: localId,
            jellyfinItem: jellyfinItem,
          ));

          final jellyfin = GetIt.instance<JellyfinApiHelper>();
          final targetPlaylists = _pendingPlaylistTargets.remove(trackKey) ?? {playlistId};
          for (final pid in targetPlaylists) {
            try {
              await jellyfin.addItemstoPlaylist(
                playlistId: pid,
                ids: [localId],
              );
            } catch (e) {
              print('Error agregando pista a playlist ($pid): $e');
            }
          }
          SynapEvents.fireLibraryRefresh();

          if (context != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('"$title" se agregó a $playlistName'),
                duration: const Duration(seconds: 3),
                backgroundColor: const Color(0xFF1E1E1E),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }
      } catch (e) {
        print('Error en sondeo para playlist ($title): $e');
      }
    }

    _removeActiveDownload(trackKey);
    _pendingPlaylistTargets.remove(trackKey);
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo completar la descarga de "$title" para $playlistName.'),
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xFFC62828),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
