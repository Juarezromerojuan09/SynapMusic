with open('lib/screens/settings_screen.dart', 'r') as f:
    content = f.read()

import re

# We need to replace the FutureBuilder logic.
# First, ensure 'package:http/http.dart' and 'dart:convert' are imported.
if "import 'package:http/http.dart' as http;" not in content:
    content = content.replace("import '../services/jellyfin_api_helper.dart';", "import '../services/jellyfin_api_helper.dart';\nimport 'package:http/http.dart' as http;\nimport 'dart:convert';\nimport '../services/finamp_user_helper.dart';")

old_future = """              future: () async {
                try {
                  final jellyfinApi = GetIt.instance<JellyfinApiHelper>();
                  return jellyfinApi.userDto?.policy?.isAdmin ?? false;
                } catch (e) {
                  return false;
                }
              }(),"""

new_future = """              future: () async {
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
              }(),"""

# Let's handle the typo fix we did earlier too, just in case
old_future_is_administrator = old_future.replace("isAdmin", "isAdministrator")

content = content.replace(old_future, new_future)
content = content.replace(old_future_is_administrator, new_future)

with open('lib/screens/settings_screen.dart', 'w') as f:
    f.write(content)

print("Admin settings patched for network check.")
