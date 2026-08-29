with open('lib/screens/player_screen.dart', 'r') as f:
    content = f.read()

import re

# Add imports to player_screen.dart
if "import 'dart:io';" not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'dart:io';\nimport 'package:path_provider/path_provider.dart';")

# Find the getLyrics fetch
old_fetch = """      final synapApi = SynapApiService();
      final lrcContent = await synapApi.getLyrics(artist, title);"""

new_fetch = """      String? lrcContent;
      try {
        final directory = await getApplicationDocumentsDirectory();
        final lyricsDir = Directory('${directory.path}/lyrics');
        final file = File('${lyricsDir.path}/${item.id}.lrc');
        
        if (await file.exists()) {
          lrcContent = await file.readAsString();
        } else {
          final synapApi = SynapApiService();
          lrcContent = await synapApi.getLyrics(artist, title);
          if (lrcContent != null && lrcContent.isNotEmpty) {
            if (!await lyricsDir.exists()) await lyricsDir.create(recursive: true);
            await file.writeAsString(lrcContent);
          }
        }
      } catch (e) {
        final synapApi = SynapApiService();
        lrcContent = await synapApi.getLyrics(artist, title);
      }"""

content = content.replace(old_fetch, new_fetch)

with open('lib/screens/player_screen.dart', 'w') as f:
    f.write(content)

print("Player screen patched")
