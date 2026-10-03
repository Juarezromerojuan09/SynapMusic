import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/synap_api_service.dart';
import 'package:finamp/services/synap_events.dart';
import 'package:finamp/services/playback_download_coordinator.dart';
import 'package:get_it/get_it.dart';

class LikesPlaylistHelper {
  static const String likesPlaylistName = 'My likes';

  // Reactividad global para actualización instantánea en toda la app
  static final ValueNotifier<Set<String>> likedSongIds = ValueNotifier<Set<String>>({});
  static final ValueNotifier<Set<String>> likedSongKeys = ValueNotifier<Set<String>>({});
  static final Set<String> pendingLikeKeys = {};
  static bool _isLoading = false;
  static StreamSubscription<LocalTrackReadyEvent>? _trackReadySub;

  static final Set<String> _inFlightAddingSongIds = {};

  /// Limpia sufijos típicos de YouTube y extras para normalizar coincidencias de canciones
  static String cleanTitle(String title) {
    String cleaned = title.replaceAll(
      RegExp(r'[\(\[][^\)\]]*(official|video|audio|lyric|lyrics|live|cover|hd|hq|1080p|4k|sub\.?\s*español|remastered)[^\)\]]*[\)\]]', caseSensitive: false),
      '',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'\s*-\s*(official|video|audio|lyric|lyrics|live|cover|hd|hq|sub\.?\s*español).*$', caseSensitive: false),
      '',
    );
    return cleaned.trim();
  }

  /// Inicializa el helper, carga los likes en memoria y escucha eventos de pistas descargadas
  static void init() {
    loadLikes();
    _trackReadySub?.cancel();
    _trackReadySub = PlaybackDownloadCoordinator().onTrackReady.listen((event) {
      final key = normalizeKey(event.title, event.artist);
      final rawKey = '${event.title.toLowerCase().trim()}||${event.artist.toLowerCase().trim()}';
      if (pendingLikeKeys.contains(key) || pendingLikeKeys.contains(rawKey)) {
        pendingLikeKeys.remove(key);
        pendingLikeKeys.remove(rawKey);
        addSongToLikes(event.localId, title: event.title, artist: event.artist);
      }
    });
  }

  /// Normaliza identificadores de Jellyfin (sin guiones y en minúsculas) para evitar discrepancias de GUID
  static String normalizeId(String id) {
    return id.toLowerCase().replaceAll('-', '').trim();
  }

  static String normalizeKey(String? title, String? artist) {
    final t = cleanTitle(title ?? '').toLowerCase().trim();
    final a = (artist ?? '').toLowerCase().trim();
    return '$t||$a';
  }

  /// Retorna verdadero si la playlist proporcionada es la playlist fija "My likes"
  static bool isLikesPlaylist(BaseItemDto? playlist) {
    if (playlist == null || playlist.name == null) return false;
    return playlist.name!.trim().toLowerCase() == likesPlaylistName.toLowerCase();
  }

  /// Pre-alimenta la lista reactiva de canciones con like a partir de una lista de tracks (p.ej. al abrir My likes)
  static void seedLikesFromTracks(List<BaseItemDto> tracks) {
    final newIds = Set<String>.from(likedSongIds.value);
    final newKeys = Set<String>.from(likedSongKeys.value);
    for (final item in tracks) {
      if (item.id.isNotEmpty) {
        newIds.add(normalizeId(item.id));
      }
      final artist = (item.artists?.isNotEmpty == true) ? item.artists![0] : (item.albumArtist ?? '');
      newKeys.add(normalizeKey(item.name, artist));
      newKeys.add('${(item.name ?? '').toLowerCase().trim()}||${artist.toLowerCase().trim()}');
      if (item.name != null && item.name!.isNotEmpty) {
        newKeys.add(cleanTitle(item.name!).toLowerCase().trim());
      }
    }
    likedSongIds.value = newIds;
    likedSongKeys.value = newKeys;
  }

  /// Consulta en memoria si una canción está marcada con like
  static bool isSongLiked({String? trackId, String? title, String? artist}) {
    if (trackId != null && trackId.isNotEmpty && likedSongIds.value.contains(normalizeId(trackId))) {
      return true;
    }
    if (title != null && title.isNotEmpty) {
      final key = normalizeKey(title, artist);
      if (likedSongKeys.value.contains(key) || pendingLikeKeys.contains(key)) {
        return true;
      }
      final rawKey = '${title.toLowerCase().trim()}||${(artist ?? '').toLowerCase().trim()}';
      if (likedSongKeys.value.contains(rawKey) || pendingLikeKeys.contains(rawKey)) {
        return true;
      }
      final cleanT = cleanTitle(title).toLowerCase().trim();
      if (likedSongKeys.value.contains(cleanT) || pendingLikeKeys.contains(cleanT)) {
        return true;
      }
    }
    return false;
  }

  /// Carga en memoria todas las canciones de la playlist "My likes" y limpia duplicados del servidor si existen
  static Future<void> loadLikes() async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      final likesPl = await getOrCreateLikesPlaylist();
      if (likesPl?.id == null) {
        _isLoading = false;
        return;
      }
      likesPl!.type ??= 'Playlist';

      // 1. Pre-cargar instantáneamente desde el caché local offline si existe (0 ms)
      try {
        final directory = await getApplicationDocumentsDirectory();
        final cacheFile = File('${directory.path}/synap_playlist_${likesPl.id}_tracks.json');
        if (await cacheFile.exists()) {
          final content = await cacheFile.readAsString();
          final List<dynamic> list = json.decode(content);
          final cachedTracks = list.map((e) => BaseItemDto.fromJson(e)).toList();
          if (cachedTracks.isNotEmpty) {
            seedLikesFromTracks(cachedTracks);
          }
        }
      } catch (_) {}

      // 2. Cargar lista actualizada del servidor Jellyfin
      final jellyfin = GetIt.instance<JellyfinApiHelper>();
      final items = await jellyfin.getItems(parentItem: likesPl, isGenres: false) ?? [];

      final newIds = <String>{};
      final newKeys = <String>{};
      final duplicateEntryIds = <String>[];

      for (final item in items) {
        final normId = normalizeId(item.id);
        if (newIds.contains(normId)) {
          // Duplicado detectado en el servidor Jellyfin
          if (item.playlistItemId != null) {
            duplicateEntryIds.add(item.playlistItemId!);
          }
          continue;
        }
        newIds.add(normId);
        final artist = (item.artists?.isNotEmpty == true) ? item.artists![0] : (item.albumArtist ?? '');
        newKeys.add(normalizeKey(item.name, artist));
        newKeys.add('${(item.name ?? '').toLowerCase().trim()}||${artist.toLowerCase().trim()}');
        if (item.name != null && item.name!.isNotEmpty) {
          newKeys.add(cleanTitle(item.name!).toLowerCase().trim());
        }
      }

      // Si habían duplicados en el servidor, eliminarlos en segundo plano
      if (duplicateEntryIds.isNotEmpty && likesPl.id != null) {
        jellyfin.removeItemsFromPlaylist(
          playlistId: likesPl.id!,
          entryIds: duplicateEntryIds,
        ).catchError((_) {});
      }

      likedSongIds.value = newIds;
      likedSongKeys.value = newKeys;
    } catch (e) {
      print('Error al cargar canciones de My likes: $e');
    } finally {
      _isLoading = false;
    }
  }

  static Future<BaseItemDto?>? _inFlightLikesPlaylistFuture;

  /// Obtiene la playlist "My likes" para el usuario actual o la crea en Jellyfin si no existe.
  static Future<BaseItemDto?> getOrCreateLikesPlaylist() async {
    if (_inFlightLikesPlaylistFuture != null) {
      return _inFlightLikesPlaylistFuture!;
    }
    _inFlightLikesPlaylistFuture = _getOrCreateLikesPlaylistInternal();
    try {
      return await _inFlightLikesPlaylistFuture!;
    } finally {
      _inFlightLikesPlaylistFuture = null;
    }
  }

  static Future<BaseItemDto?> _getOrCreateLikesPlaylistInternal() async {
    try {
      final userHelper = GetIt.instance<FinampUserHelper>();
      final userId = userHelper.currentUserId;
      final apiService = SynapApiService();
      final jellyfin = GetIt.instance<JellyfinApiHelper>();

      // 1. Buscar en las playlists del usuario a través de la API
      final playlistsData = await apiService.getUserPlaylists(userId: userId);
      for (final raw in playlistsData) {
        final dto = BaseItemDto.fromJson(raw);
        if (isLikesPlaylist(dto)) {
          dto.type ??= 'Playlist';
          return dto;
        }
      }

      // 2. Si la API devolvió lista vacía (posible timeout), consultar directo a Jellyfin antes de crear
      try {
        final jfPlaylists = await jellyfin.getItems(includeItemTypes: "Playlist", isGenres: false);
        if (jfPlaylists != null && jfPlaylists.isNotEmpty) {
          for (final dto in jfPlaylists) {
            if (isLikesPlaylist(dto)) {
              dto.type ??= 'Playlist';
              return dto;
            }
          }
        }
      } catch (_) {}

      // 3. Si verdaderamente no existe en ningún lado, crear la playlist "My likes"
      final newId = await apiService.createPlaylist(likesPlaylistName, userId: userId);
      if (newId != null) {
        SynapEvents.fireLibraryRefresh();
        try {
          final item = await jellyfin.getItemById(newId);
          item?.type ??= 'Playlist';
          return item;
        } catch (_) {
          return BaseItemDto(id: newId, name: likesPlaylistName, type: 'Playlist');
        }
      }
    } catch (e) {
      print('Error en getOrCreateLikesPlaylist: $e');
    }
    return null;
  }

  /// Agrega una pista por su ID a la playlist "My likes" si aún no está presente.
  static Future<void> addSongToLikes(String songId, {String? title, String? artist}) async {
    final normId = normalizeId(songId);
    if (_inFlightAddingSongIds.contains(normId)) return;
    _inFlightAddingSongIds.add(normId);

    try {
      // Optimista: actualizar estados en memoria de inmediato
      final updatedIds = Set<String>.from(likedSongIds.value)..add(normId);
      likedSongIds.value = updatedIds;

      if (title != null && title.isNotEmpty) {
        final key = normalizeKey(title, artist);
        final rawKey = '${title.toLowerCase().trim()}||${(artist ?? '').toLowerCase().trim()}';
        final cleanT = cleanTitle(title).toLowerCase().trim();
        final updatedKeys = Set<String>.from(likedSongKeys.value)
          ..add(key)
          ..add(rawKey)
          ..add(cleanT);
        likedSongKeys.value = updatedKeys;
        pendingLikeKeys.remove(key);
        pendingLikeKeys.remove(rawKey);
        pendingLikeKeys.remove(cleanT);
      }

      final jellyfin = GetIt.instance<JellyfinApiHelper>();
      try {
        await jellyfin.addFavourite(songId);
      } catch (_) {}

      final likesPl = await getOrCreateLikesPlaylist();
      if (likesPl?.id == null) return;
      likesPl!.type ??= 'Playlist';

      final items = await jellyfin.getItems(parentItem: likesPl, isGenres: false) ?? [];
      final alreadyIn = items.any((i) => normalizeId(i.id) == normId);

      if (!alreadyIn) {
        await jellyfin.addItemstoPlaylist(
          playlistId: likesPl.id,
          ids: [songId],
        );
        SynapEvents.fireLibraryRefresh();
      }
    } catch (e) {
      print('Error al agregar canción a My likes: $e');
    } finally {
      _inFlightAddingSongIds.remove(normId);
    }
  }

  /// Remueve una pista por su ID de la playlist "My likes".
  static Future<void> removeSongFromLikes(String songId, {String? title, String? artist}) async {
    final normId = normalizeId(songId);
    try {
      // Optimista: retirar de memoria
      final updatedIds = Set<String>.from(likedSongIds.value)..remove(normId);
      likedSongIds.value = updatedIds;

      if (title != null && title.isNotEmpty) {
        final key = normalizeKey(title, artist);
        final rawKey = '${title.toLowerCase().trim()}||${(artist ?? '').toLowerCase().trim()}';
        final cleanT = cleanTitle(title).toLowerCase().trim();
        final updatedKeys = Set<String>.from(likedSongKeys.value)
          ..remove(key)
          ..remove(rawKey)
          ..remove(cleanT);
        likedSongKeys.value = updatedKeys;
        pendingLikeKeys.remove(key);
        pendingLikeKeys.remove(rawKey);
        pendingLikeKeys.remove(cleanT);
      }

      final jellyfin = GetIt.instance<JellyfinApiHelper>();
      try {
        await jellyfin.removeFavourite(songId);
      } catch (_) {}

      final likesPl = await getOrCreateLikesPlaylist();
      if (likesPl?.id == null) return;
      likesPl!.type ??= 'Playlist';

      final items = await jellyfin.getItems(parentItem: likesPl, isGenres: false) ?? [];
      final match = items.where((i) => normalizeId(i.id) == normId).firstOrNull;

      if (match?.playlistItemId != null) {
        await jellyfin.removeItemsFromPlaylist(
          playlistId: likesPl.id,
          entryIds: [match!.playlistItemId!],
        );
        SynapEvents.fireLibraryRefresh();
      }
    } catch (e) {
      print('Error al remover canción de My likes: $e');
    }
  }

  /// Conmuta el estado de like de una canción (para canciones locales o externas)
  static Future<void> toggleLike({
    String? trackId,
    required String title,
    required String artist,
    String? queryString,
    String? coverUrl,
    BuildContext? context,
    bool? forceCurrentlyLiked,
  }) async {
    final key = normalizeKey(title, artist);
    final currentlyLiked = forceCurrentlyLiked ?? isSongLiked(trackId: trackId, title: title, artist: artist);

    if (currentlyLiked) {
      // Quitar like
      pendingLikeKeys.remove(key);
      final rawKey = '${title.toLowerCase().trim()}||${artist.toLowerCase().trim()}';
      final cleanT = cleanTitle(title).toLowerCase().trim();
      final updatedKeys = Set<String>.from(likedSongKeys.value)
        ..remove(key)
        ..remove(rawKey)
        ..remove(cleanT);
      likedSongKeys.value = updatedKeys;

      if (trackId != null && trackId.isNotEmpty) {
        final updatedIds = Set<String>.from(likedSongIds.value)..remove(normalizeId(trackId));
        likedSongIds.value = updatedIds;
        await removeSongFromLikes(trackId, title: title, artist: artist);
      }

      if (context != null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Eliminada de My likes'),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF1E1E1E),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      // Agregar like
      if (trackId != null && trackId.isNotEmpty) {
        // La canción ya existe en el servidor
        await addSongToLikes(trackId, title: title, artist: artist);
        if (context != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Guardada en My likes'),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFF1E1E1E),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        // La canción NO existe en el servidor:
        // 1. Pintar morado de inmediato
        pendingLikeKeys.add(key);
        final rawKey = '${title.toLowerCase().trim()}||${artist.toLowerCase().trim()}';
        final cleanT = cleanTitle(title).toLowerCase().trim();
        final updatedKeys = Set<String>.from(likedSongKeys.value)
          ..add(key)
          ..add(rawKey)
          ..add(cleanT);
        likedSongKeys.value = updatedKeys;

        // 2. Descargar en segundo plano y asociar a My likes al finalizar sin reproducir
        PlaybackDownloadCoordinator().downloadAndAddToLikes(
          title: title,
          artist: artist,
          queryString: queryString,
          coverUrl: coverUrl,
          context: context,
        );
      }
    }
  }
}
