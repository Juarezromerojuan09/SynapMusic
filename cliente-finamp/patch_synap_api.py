with open('lib/services/synap_api_service.dart', 'r') as f:
    content = f.read()

import re

old_create = """  Future<String?> createPlaylist(String name) async {
    if (name.isEmpty) return null;
    
    try {
      final uri = Uri.parse('$_baseUrl/playlist');
      final request = await HttpClient().postUrl(uri);
      request.headers.add('X-API-Key', _apiKey);
      request.headers.contentType = ContentType.json;
      
      final body = jsonEncode({"name": name});"""

new_create = """  Future<String?> createPlaylist(String name, {String? userId}) async {
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
      final body = jsonEncode(bodyMap);"""

content = content.replace(old_create, new_create)

with open('lib/services/synap_api_service.dart', 'w') as f:
    f.write(content)

print("Frontend api service patched for user_id")
