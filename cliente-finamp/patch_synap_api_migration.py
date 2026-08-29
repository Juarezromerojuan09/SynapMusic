with open('lib/services/synap_api_service.dart', 'r') as f:
    content = f.read()

import re

new_method = """  Future<bool> migratePlaylist(String url, String userId) async {
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

  Future<bool> downloadMusicBulk"""

content = content.replace("  Future<bool> downloadMusicBulk", new_method)

with open('lib/services/synap_api_service.dart', 'w') as f:
    f.write(content)

print("SynapApiService updated with migratePlaylist")
