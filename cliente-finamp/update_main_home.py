with open('lib/screens/synap_music/main_home_screen.dart', 'r') as f:
    content = f.read()

imports_to_add = """
import 'package:get_it/get_it.dart';
import '../../screens/splash_screen.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/music_player_background_task.dart';
"""

if "import 'package:get_it/get_it.dart';" not in content:
    content = content.replace("import 'package:flutter/material.dart';", f"import 'package:flutter/material.dart';\n{imports_to_add}")


# Find the _pages initialization
old_pages = """  final List<Widget> _pages = [
    const Scaffold(body: Center(child: Text('Inicio', style: TextStyle(fontSize: 24)))),
    const DownloadScreen(),
    const LibraryPlaylistsScreen(),
  ];"""

# We cannot easily add context inside the State class initialization for a button press if we extract a method without context? Wait, the pages are initialized in `initState()` or as fields. Wait, we can't use `Navigator.of(context)` inside a `const Widget`.
# I should create a separate stateless widget for the Home Page (`HomeTab`) inside the same file, to have access to `context` inside its `build` method.

new_pages = """
class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Inicio', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF144477),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cerrar Sesión'),
                    content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
                        onPressed: () async {
                          try {
                            final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
                            if (audioHandler.playbackState.valueOrNull?.playing == true) {
                              await audioHandler.stop();
                            }
                            final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
                            await jellyfinApiHelper.logoutCurrentUser().onError((_, __) {});
                            
                            if (!context.mounted) return;
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              SplashScreen.routeName, (route) => false);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

  final List<Widget> _pages = const [
    HomeTab(),
    DownloadScreen(),
    LibraryPlaylistsScreen(),
  ];"""

# Replace the _pages field, but wait, `_pages` can just be replaced entirely.
import re
content = re.sub(r"  final List<Widget> _pages = \[\n.*?const Scaffold\(body: Center\(child: Text\('Inicio'.*?\n.*?\];", new_pages, content, flags=re.DOTALL)

with open('lib/screens/synap_music/main_home_screen.dart', 'w') as f:
    f.write(content)

print("Updated main_home_screen.dart")
