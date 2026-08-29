with open('lib/screens/settings_screen.dart', 'r') as f:
    content = f.read()

import re

old_future = """            FutureBuilder<bool>(
              future: Future<bool>.value(true),
              builder: (context, snapshot) {"""

new_future = """            FutureBuilder<bool>(
              future: () async {
                try {
                  final userHelper = GetIt.instance<FinampUserHelper>();
                  final currentUser = userHelper.currentUser;
                  if (currentUser == null) return false;
                  
                  final url = Uri.parse('${currentUser.baseUrl}/Users/${currentUser.id}');
                  final response = await http.get(url, headers: {
                    'X-Emby-Token': currentUser.accessToken,
                  });
                  
                  if (response.statusCode == 200) {
                    final data = json.decode(response.body);
                    return data['Policy']?['IsAdministrator'] ?? false;
                  }
                  return false;
                } catch (e) {
                  return false;
                }
              }(),
              builder: (context, snapshot) {"""

content = content.replace(old_future, new_future)

with open('lib/screens/settings_screen.dart', 'w') as f:
    f.write(content)

print("Restored real admin check")
