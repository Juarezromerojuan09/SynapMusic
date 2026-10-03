import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'finamp_user_helper.dart';
import 'synap_api_service.dart';
import 'synap_events.dart';

class SynapFavoritesHelper {
  static final ValueNotifier<List<dynamic>> favoriteAlbums = ValueNotifier<List<dynamic>>([]);
  static final ValueNotifier<List<dynamic>> favoriteArtists = ValueNotifier<List<dynamic>>([]);

  static final SynapApiService _apiService = SynapApiService();
  static bool _isSyncing = false;

  /// Obtiene el archivo local de álbumes favoritos
  static Future<File> _getFavoriteAlbumsFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/synap_favorite_albums.json');
  }

  /// Obtiene el archivo local de artistas favoritos
  static Future<File> _getFavoriteArtistsFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/synap_favorite_artists.json');
  }

  /// Carga inicial: primero lee de la memoria/archivo local (0 ms) y luego sincroniza con la nube
  static Future<void> init() async {
    await loadFromLocal();
    // Sincronizar en segundo plano con la nube
    syncWithCloud();
  }

  /// Carga los favoritos desde el almacenamiento local
  static Future<void> loadFromLocal() async {
    try {
      final albumsFile = await _getFavoriteAlbumsFile();
      if (await albumsFile.exists()) {
        final content = await albumsFile.readAsString();
        favoriteAlbums.value = json.decode(content);
      }

      final artistsFile = await _getFavoriteArtistsFile();
      if (await artistsFile.exists()) {
        final content = await artistsFile.readAsString();
        favoriteArtists.value = json.decode(content);
      }
    } catch (e) {
      print('Error al cargar favoritos locales: $e');
    }
  }

  /// Guarda los datos actuales en el almacenamiento local
  static Future<void> _saveToLocal() async {
    try {
      final albumsFile = await _getFavoriteAlbumsFile();
      await albumsFile.writeAsString(json.encode(favoriteAlbums.value));

      final artistsFile = await _getFavoriteArtistsFile();
      await artistsFile.writeAsString(json.encode(favoriteArtists.value));
    } catch (e) {
      print('Error al guardar favoritos locales: $e');
    }
  }

  /// Sincroniza bidireccionalmente los favoritos locales con el servidor en la nube
  static Future<void> syncWithCloud() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final userHelper = GetIt.instance<FinampUserHelper>();
      final userId = userHelper.currentUser?.id;
      if (userId == null || userId.isEmpty) {
        _isSyncing = false;
        return;
      }

      final result = await _apiService.syncUserFavorites(
        userId,
        albums: favoriteAlbums.value,
        artists: favoriteArtists.value,
      );

      if (result != null) {
        if (result['albums'] != null) {
          favoriteAlbums.value = List<dynamic>.from(result['albums']);
        }
        if (result['artists'] != null) {
          favoriteArtists.value = List<dynamic>.from(result['artists']);
        }
        await _saveToLocal();
        SynapEvents.fireLibraryRefresh();
      }
    } catch (e) {
      print('Error al sincronizar favoritos con la nube: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Comprueba si un álbum está en favoritos (O(n) rápido en memoria)
  static bool isAlbumFavorite(String? albumId) {
    if (albumId == null || albumId.isEmpty) return false;
    final aid = albumId.trim();
    return favoriteAlbums.value.any((a) => a['id']?.toString() == aid);
  }

  /// Comprueba si un artista está en favoritos (por nombre insensible a mayúsculas)
  static bool isArtistFavorite(String? artistName) {
    if (artistName == null || artistName.isEmpty) return false;
    final normName = artistName.trim().toLowerCase();
    return favoriteArtists.value.any((a) {
      final name = (a['name']?.toString() ?? '').trim().toLowerCase();
      return name == normName;
    });
  }

  /// Añade o quita un álbum de favoritos, actualizando memoria, archivo local y nube
  static Future<void> toggleAlbumFavorite(BuildContext? context, Map<String, dynamic> albumData) async {
    final albumId = albumData['id']?.toString();
    if (albumId == null || albumId.isEmpty) return;

    final userHelper = GetIt.instance<FinampUserHelper>();
    final userId = userHelper.currentUser?.id;

    final currentList = List<dynamic>.from(favoriteAlbums.value);
    final isFav = isAlbumFavorite(albumId);

    if (isFav) {
      currentList.removeWhere((a) => a['id']?.toString() == albumId);
      favoriteAlbums.value = currentList;
      await _saveToLocal();
      SynapEvents.fireLibraryRefresh();

      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Álbum removido de favoritos')),
        );
      }

      if (userId != null && userId.isNotEmpty) {
        _apiService.removeUserFavoriteAlbum(userId, albumId);
      }
    } else {
      currentList.insert(0, {
        'id': albumId,
        'title': albumData['title'] ?? '',
        'artist': albumData['artist'] ?? '',
        'cover_url': albumData['cover_url'] ?? '',
        'year': albumData['year']?.toString() ?? '',
        'added_at': DateTime.now().toIso8601String(),
      });
      favoriteAlbums.value = currentList;
      await _saveToLocal();
      SynapEvents.fireLibraryRefresh();

      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Álbum añadido a favoritos')),
        );
      }

      if (userId != null && userId.isNotEmpty) {
        _apiService.addUserFavoriteAlbum(userId, albumData);
      }
    }
  }

  /// Añade o quita un artista de favoritos, actualizando memoria, archivo local y nube
  static Future<void> toggleArtistFavorite(BuildContext? context, Map<String, dynamic> artistData) async {
    final artistName = artistData['name']?.toString();
    if (artistName == null || artistName.isEmpty) return;

    final userHelper = GetIt.instance<FinampUserHelper>();
    final userId = userHelper.currentUser?.id;

    final currentList = List<dynamic>.from(favoriteArtists.value);
    final isFav = isArtistFavorite(artistName);

    if (isFav) {
      currentList.removeWhere((a) {
        final name = (a['name']?.toString() ?? '').trim().toLowerCase();
        return name == artistName.trim().toLowerCase();
      });
      favoriteArtists.value = currentList;
      await _saveToLocal();
      SynapEvents.fireLibraryRefresh();

      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eliminado de tus artistas favoritos')),
        );
      }

      if (userId != null && userId.isNotEmpty) {
        _apiService.removeUserFavoriteArtist(userId, artistName);
      }
    } else {
      currentList.insert(0, {
        'id': artistData['id']?.toString() ?? '',
        'name': artistName,
        'picture_url': artistData['picture_url'] ?? artistData['picture'] ?? '',
        'picture_medium': artistData['picture_medium'] ?? artistData['picture_url'] ?? '',
        'fans': artistData['fans']?.toString() ?? '',
        'added_at': DateTime.now().toIso8601String(),
      });
      favoriteArtists.value = currentList;
      await _saveToLocal();
      SynapEvents.fireLibraryRefresh();

      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Añadido a tus artistas favoritos')),
        );
      }

      if (userId != null && userId.isNotEmpty) {
        _apiService.addUserFavoriteArtist(userId, artistData);
      }
    }
  }
}
