import re

with open('lib/services/synap_api_service.dart', 'r') as f:
    content = f.read()

new_method = """  Future<String?> getLyrics(String artist, String title) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lyrics?artist=${Uri.encodeComponent(artist)}&title=${Uri.encodeComponent(title)}'),
        headers: {
          'X-API-Key': apiKey,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['lyrics'];
        }
      }
      return null;
    } catch (e) {
      print('Error obteniendo letras: $e');
      return null;
    }
  }
}"""

content = re.sub(r"\}\s*$", new_method, content)

with open('lib/services/synap_api_service.dart', 'w') as f:
    f.write(content)
