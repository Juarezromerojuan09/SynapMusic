import re

with open('cliente-finamp/lib/services/synap_api_service.dart', 'r') as f:
    content = f.read()

# Add path_provider import
if "import 'package:path_provider/path_provider.dart';" not in content:
    content = content.replace("import 'dart:io';", "import 'dart:io';\nimport 'package:path_provider/path_provider.dart';")

cache_method = """  Future<List<dynamic>> _fetchAndCache(String endpoint, String cacheKey) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFile = File('${cacheDir.path}/$cacheKey.json');
      
      try {
        final uri = Uri.parse('$_baseUrl$endpoint');
        final request = await HttpClient().getUrl(uri);
        request.headers.add('X-API-Key', _apiKey);
        final response = await request.close();
        if (response.statusCode == 200) {
          final responseBody = await response.transform(utf8.decoder).join();
          
          // Guardar en caché
          await cacheFile.writeAsString(responseBody);
          
          return json.decode(responseBody) as List<dynamic>;
        }
      } catch (e) {
        print('Error de red para $endpoint: $e, intentando usar caché...');
      }
      
      // Leer de caché si existe
      if (await cacheFile.exists()) {
        try {
          final cachedData = await cacheFile.readAsString();
          return json.decode(cachedData) as List<dynamic>;
        } catch (e) {
          print('Error de caché para $cacheKey: $e');
        }
      }
    } catch (e) {
      print('Error fatal en _fetchAndCache: $e');
    }
    
    return [];
  }

  Future<List<dynamic>> getTopSongs(String userId) async {
    return _fetchAndCache('/home/top-songs?user_id=$userId', 'top_songs_$userId');
  }

  Future<List<dynamic>> getTopArtists(String userId) async {
    return _fetchAndCache('/home/top-artists?user_id=$userId', 'top_artists_$userId');
  }

  Future<List<dynamic>> getTopAlbums(String userId) async {
    return _fetchAndCache('/home/top-albums?user_id=$userId', 'top_albums_$userId');
  }

  Future<List<dynamic>> getNewReleases(String userId) async {
    return _fetchAndCache('/home/new-releases?user_id=$userId', 'new_releases_$userId');
  }

  Future<List<dynamic>> getGlobalAlbums() async {
    return _fetchAndCache('/search/global-albums', 'global_albums');
  }

  Future<List<dynamic>> getTopMexico() async {
    return _fetchAndCache('/home/top-mexico', 'top_mexico');
  }
"""

# Replace the methods from getTopSongs to getTopMexico (inclusive)
pattern = r'  Future<List<dynamic>> getTopSongs\(String userId\) async \{.*?(?=  Future<Map<String, dynamic>\?> getArtistProfile)'
content = re.sub(pattern, cache_method, content, flags=re.DOTALL)

with open('cliente-finamp/lib/services/synap_api_service.dart', 'w') as f:
    f.write(content)
