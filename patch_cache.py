import re

with open('cliente-finamp/lib/services/synap_api_service.dart', 'r') as f:
    content = f.read()

# Replace _fetchAndCache with a stream version
pattern = r'  Future<List<dynamic>> _fetchAndCache.*?return \[\];\n  \}'
new_method = """  Stream<List<dynamic>> _fetchAndCacheStream(String endpoint, String cacheKey) async* {
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
  }"""

content = re.sub(pattern, new_method, content, flags=re.DOTALL)

# Now remove the old Future methods
content = re.sub(r'  Future<List<dynamic>> getTopSongs.*?getTopMexico\(\) async \{.*?\n  \}', '', content, flags=re.DOTALL)


with open('cliente-finamp/lib/services/synap_api_service.dart', 'w') as f:
    f.write(content)

