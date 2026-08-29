with open('lib/services/downloads_helper.dart', 'r') as f:
    content = f.read()

# Turn on notifications for flutter_downloader
content = content.replace("showNotification: false", "showNotification: true")
# Also change it for images just in case, or maybe only for songs.
# Since we replaced all, it applies to both.

with open('lib/services/downloads_helper.dart', 'w') as f:
    f.write(content)

with open('lib/screens/synap_music/main_home_screen.dart', 'r') as f:
    home_content = f.read()

# Add DownloadsScreen import and button
if "import '../../screens/downloads_screen.dart';" not in home_content:
    home_content = home_content.replace("import '../../screens/settings_screen.dart';", "import '../../screens/settings_screen.dart';\nimport '../../screens/downloads_screen.dart';")

old_actions = """        actions: [
          IconButton(
            icon: const Icon(Icons.settings),"""

new_actions = """        actions: [
          IconButton(
            icon: const Icon(Icons.downloading),
            onPressed: () {
              Navigator.of(context).pushNamed(DownloadsScreen.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),"""

home_content = home_content.replace(old_actions, new_actions)

with open('lib/screens/synap_music/main_home_screen.dart', 'w') as f:
    f.write(home_content)

print("Notifications and download manager button added")
