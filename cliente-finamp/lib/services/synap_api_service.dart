import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/synap_search_result.dart';

class SynapApiService {
  // Ajusta esta URL a la IP de tu servidor si pruebas en un dispositivo físico
  static const String _baseUrl = 'http://100.81.156.126:8000';
  static const String _apiKey = 'juarezromerojuan160311';

  String get baseUrl => _baseUrl;
  String get apiKey => _apiKey;

  Future<Map<String, dynamic>?> searchExternal(String query, {String source = 'deezer', int limit = 15, int offset = 0}) async {
    if (query.isEmpty) return null;

    try {
      final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: {
        'q': query, 
        'source': source,
        'limit': limit.toString(),
        'offset': offset.toString(),
      });
      final request = await HttpClient().getUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        return json.decode(responseBody) as Map<String, dynamic>;
      } else {
        print('Error en búsqueda externa: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción en búsqueda externa: $e');
      return null;
    }
  }

  Future<List<dynamic>?> searchAlbums(String query) async {
    if (query.isEmpty) return null;
    try {
      final uri = Uri.parse('$_baseUrl/search/albums?q=${Uri.encodeQueryComponent(query)}');
      final request = await HttpClient().getUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody) as Map<String, dynamic>;
        return data['results'] as List<dynamic>?;
      } else {
        print('Error en búsqueda de álbumes: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción en búsqueda de álbumes: $e');
      return null;
    }
  }

  Future<List<dynamic>> getGlobalAlbums() async {
    try {
      final uri = Uri.parse('$_baseUrl/search/global-albums');
      final request = await HttpClient().getUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        return json.decode(responseBody) as List<dynamic>;
      } else {
        print('Error en getGlobalAlbums: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Excepción en getGlobalAlbums: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getAlbumDetails(String albumId) async {
    try {
      final uri = Uri.parse('$_baseUrl/album/$albumId');
      final request = await HttpClient().getUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        return json.decode(responseBody) as Map<String, dynamic>;
      } else {
        print('Error obteniendo detalles del álbum: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción obteniendo detalles del álbum: $e');
      return null;
    }
  }

  Future<bool> downloadMedia(String queryText) async {
    try {
      final uri = Uri.parse('$_baseUrl/download');
      final request = await HttpClient().postUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      request.headers.contentType = ContentType.json;
      
      // Enviar el body en formato JSON que espera FastAPI
      final body = jsonEncode({"query": queryText});
      request.write(body);
      
      final response = await request.close();

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error al solicitar descarga: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción al solicitar descarga: $e');
      return false;
    }
  }

  Future<bool> migratePlaylist(String url, String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/download/playlist-migration');
      final request = await HttpClient().postUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      request.headers.contentType = ContentType.json;
      
      final body = jsonEncode({
        "url": url,
        "user_id": userId
      });
      request.write(body);
      
      final response = await request.close();
      return response.statusCode == 200;
    } catch (e) {
      print('Excepción en migratePlaylist: $e');
      return false;
    }
  }

  Future<bool> downloadMusicBulk(List<String> queries) async {
    if (queries.isEmpty) return true;
    
    try {
      final uri = Uri.parse('$_baseUrl/download/bulk');
      final request = await HttpClient().postUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      request.headers.contentType = ContentType.json;
      
      final body = jsonEncode({"queries": queries});
      request.write(body);
      
      final response = await request.close();

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error al solicitar descarga por lote: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción al solicitar descarga por lote: $e');
      return false;
    }
  }

  Future<String?> createPlaylist(String name, {String? userId}) async {
    if (name.isEmpty) return null;
    
    try {
      final uri = Uri.parse('$_baseUrl/playlist');
      final request = await HttpClient().postUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      request.headers.contentType = ContentType.json;
      
      final Map<String, dynamic> bodyMap = {"name": name};
      if (userId != null) {
        bodyMap["user_id"] = userId;
      }
      final body = jsonEncode(bodyMap);
      request.write(body);
      
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody) as Map<String, dynamic>;
        return data['playlist_id'] as String?;
      } else {
        print('Error al crear playlist: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción al crear playlist: $e');
      return null;
    }
  }

  Future<bool> deletePlaylist(String playlistId) async {
    try {
      final uri = Uri.parse('$_baseUrl/playlist/$playlistId');
      final request = await HttpClient().deleteUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      final response = await request.close();

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error al eliminar playlist: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción al eliminar playlist: $e');
      return false;
    }
  }

  Future<List<dynamic>> getUserPlaylists({String? userId}) async {
    try {
      final query = userId != null ? '?user_id=$userId' : '';
      final uri = Uri.parse('$_baseUrl/playlists$query');
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 4);
      final request = await client.getUrl(uri).timeout(const Duration(seconds: 4));
      request.headers.add('X-API-Key', _apiKey);
      final response = await request.close().timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        return json.decode(responseBody) as List<dynamic>;
      } else {
        print('Error obteniendo playlists: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Excepción obteniendo playlists: $e');
      return [];
    }
  }
  Future<String?> getLyrics(String artist, String title) async {
    try {
      final uri = Uri.parse('$_baseUrl/lyrics?artist=${Uri.encodeComponent(artist)}&title=${Uri.encodeComponent(title)}');
      final request = await HttpClient().getUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody) as Map<String, dynamic>;
        if (data['status'] == 'success') {
          return data['lyrics'] as String?;
        }
      }
      return null;
    } catch (e) {
      print('Error obteniendo letras: $e');
      return null;
    }
  }

  Stream<List<dynamic>> _fetchAndCacheStream(String endpoint, String cacheKey) async* {
    final cacheDir = await getTemporaryDirectory();
    final cacheFile = File('${cacheDir.path}/$cacheKey.json');
    
    // 1. Mostrar caché primero si existe
    if (await cacheFile.exists()) {
      try {
        final cachedData = await cacheFile.readAsString();
        yield json.decode(cachedData) as List<dynamic>;
      } catch (e) {
        print('Error de caché inicial para $cacheKey: $e');
      }
    }

    // 2. Intentar red con timeout corto
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final request = await HttpClient().getUrl(uri).timeout(const Duration(seconds: 5));
      request.headers.add('X-API-Key', _apiKey);
      final response = await request.close().timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        
        // Guardar en caché
        await cacheFile.writeAsString(responseBody);
        
        yield json.decode(responseBody) as List<dynamic>;
      }
    } catch (e) {
      print('Red falló para $endpoint: $e');
    }
  }

  Stream<List<dynamic>> getTopSongsStream(String userId) {
    return _fetchAndCacheStream('/home/top-songs?user_id=$userId', 'top_songs_$userId');
  }

  Stream<List<dynamic>> getTopArtistsStream(String userId) {
    return _fetchAndCacheStream('/home/top-artists?user_id=$userId', 'top_artists_$userId');
  }

  Stream<List<dynamic>> getTopAlbumsStream(String userId) {
    return _fetchAndCacheStream('/home/top-albums?user_id=$userId', 'top_albums_$userId');
  }

  Stream<List<dynamic>> getNewReleasesStream(String userId) {
    return _fetchAndCacheStream('/home/new-releases?user_id=$userId', 'new_releases_$userId');
  }

  Stream<List<dynamic>> getTopMexicoStream() {
    return _fetchAndCacheStream('/home/top-mexico', 'top_mexico');
  }


  Future<Map<String, dynamic>?> getArtistProfile(String artistName) async {
    try {
      final uri = Uri.parse('$_baseUrl/artist/${Uri.encodeComponent(artistName)}/profile');
      final request = await HttpClient().getUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        return json.decode(responseBody) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error getArtistProfile: $e');
    }
    return null;
  }

  Future<bool> checkMetadataEditable(String itemId) async {
    try {
      final uri = Uri.parse('$_baseUrl/metadata/check/$itemId');
      final request = await HttpClient().getUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody);
        return data['editable'] == true;
      }
      return false;
    } catch (e) {
      print('Error checkMetadataEditable: $e');
      return false;
    }
  }

  Future<bool> editMetadata({
    required String itemId,
    required String query,
    String? manualCoverUrl,
    String? manualLyrics,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/metadata/edit/$itemId');
      final request = await HttpClient().postUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      request.headers.contentType = ContentType.json;

      final body = jsonEncode({
        "query": query,
        "manual_cover_url": manualCoverUrl,
        "manual_lyrics": manualLyrics,
      });
      request.write(body);

      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('Error editMetadata: $e');
      return false;
    }
  }

  Future<bool> updateUserName(String userId, String newName) async {
    try {
      final uri = Uri.parse('$_baseUrl/users/$userId/name');
      final request = await HttpClient().postUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({"name": newName}));
      final response = await request.close();
      return response.statusCode == 200;
    } catch (e) {
      print('Error updateUserName: $e');
      return false;
    }
  }

  Future<bool> updateUserAvatar(String userId, List<int> imageBytes, {String mimeType = 'image/jpeg'}) async {
    try {
      final uri = Uri.parse('$_baseUrl/users/$userId/avatar');
      final request = await HttpClient().postUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      request.headers.set('content-type', mimeType);
      request.add(imageBytes);
      final response = await request.close();
      return response.statusCode == 200;
    } catch (e) {
      print('Error updateUserAvatar: $e');
      return false;
    }
  }

  Future<bool> sendFeedback({
    required String userId,
    required String userName,
    required String title,
    required String message,
    List<File>? images,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/feedback');
      final request = http.MultipartRequest('POST', uri);
      request.headers['X-API-Key'] = _apiKey;
      request.fields['user_id'] = userId;
      request.fields['user_name'] = userName;
      request.fields['title'] = title;
      request.fields['message'] = message;

      if (images != null) {
        for (final file in images) {
          if (await file.exists()) {
            final multipartFile = await http.MultipartFile.fromPath(
              'files',
              file.path,
            );
            request.files.add(multipartFile);
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return response.statusCode == 200;
    } catch (e) {
      print('Error al enviar feedback: $e');
      return false;
    }
  }

  Future<List<dynamic>> getFeedbackList() async {
    try {
      final uri = Uri.parse('$_baseUrl/feedback');
      final response = await http.get(uri, headers: {
        'X-API-Key': _apiKey,
      });
      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Error al obtener feedback: $e');
      return [];
    }
  }

  Future<bool> deleteFeedback(int feedbackId) async {
    try {
      final uri = Uri.parse('$_baseUrl/feedback/$feedbackId');
      final response = await http.delete(uri, headers: {
        'X-API-Key': _apiKey,
      });
      return response.statusCode == 200;
    } catch (e) {
      print('Error al eliminar feedback: $e');
      return false;
    }
  }

  String getFeedbackImageUrl(String filename) {
    return '$_baseUrl/feedback/images/$filename';
  }
}
