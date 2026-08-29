with open('lib/screens/settings_screen.dart', 'r') as f:
    content = f.read()

import re

# Insert import
if "admin_dashboard_screen.dart" not in content:
    content = content.replace("import 'language_selection_screen.dart';", "import 'language_selection_screen.dart';\nimport 'synap_music/admin_dashboard_screen.dart';\nimport '../services/jellyfin_api_helper.dart';\nimport 'package:get_it/get_it.dart';")

# Add the admin list tile
old_list = "children: ["
new_list = """children: [
            FutureBuilder<bool>(
              future: () async {
                try {
                  final jellyfinApi = GetIt.instance<JellyfinApiHelper>();
                  return jellyfinApi.userDto?.policy?.isAdmin ?? false;
                } catch (e) {
                  return false;
                }
              }(),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return ListTile(
                    leading: const Icon(Icons.admin_panel_settings, color: Color(0xFF144477)),
                    title: const Text('Panel de Administrador (Sala de Espera)'),
                    onTap: () => Navigator.of(context).pushNamed(AdminDashboardScreen.routeName),
                  );
                }
                return const SizedBox.shrink();
              },
            ),"""

content = content.replace(old_list, new_list)

with open('lib/screens/settings_screen.dart', 'w') as f:
    f.write(content)

print("Settings patched successfully")
