with open('lib/screens/synap_music/library_playlists_screen.dart', 'r') as f:
    content = f.read()

import re

# Add imports
if "import '../../services/finamp_settings_helper.dart';" not in content:
    content = content.replace("import '../../services/synap_api_service.dart';", "import '../../services/synap_api_service.dart';\nimport '../../services/finamp_settings_helper.dart';\nimport '../../services/downloads_helper.dart';\nimport 'package:hive_flutter/hive_flutter.dart';\nimport 'package:hive/hive.dart';")

old_load = """  void _loadPlaylists() {
    setState(() {
      _playlistsFuture = GetIt.instance<JellyfinApiHelper>().getItems(
        includeItemTypes: "Playlist",
        isGenres: false,
      ).then((value) => value ?? []);
    });
  }"""

new_load = """  void _loadPlaylists() {
    setState(() {
      if (FinampSettingsHelper.finampSettings.isOffline) {
        // En modo offline, cargamos las playlists desde la base de datos local (Hive)
        final downloadsHelper = GetIt.instance<DownloadsHelper>();
        final List<BaseItemDto> offlinePlaylists = [];
        final downloadedParents = downloadsHelper.downloadedParents;
        for (var parentInfo in downloadedParents) {
          if (parentInfo.parent.type == "Playlist") {
            offlinePlaylists.add(parentInfo.parent);
          }
        }
        _playlistsFuture = Future.value(offlinePlaylists);
      } else {
        _playlistsFuture = GetIt.instance<JellyfinApiHelper>().getItems(
          includeItemTypes: "Playlist",
          isGenres: false,
        ).then((value) {
          if (value == null) return <BaseItemDto>[];
          return value;
        }).catchError((error) {
          // Si falla por falta de internet estando "online", fallback a offline
          final downloadsHelper = GetIt.instance<DownloadsHelper>();
          final List<BaseItemDto> offlinePlaylists = [];
          for (var parentInfo in downloadsHelper.downloadedParents) {
            if (parentInfo.parent.type == "Playlist") {
              offlinePlaylists.add(parentInfo.parent);
            }
          }
          return offlinePlaylists;
        });
      }
    });
  }"""

content = content.replace(old_load, new_load)

with open('lib/screens/synap_music/library_playlists_screen.dart', 'w') as f:
    f.write(content)

print("Library playlists patched for offline")
