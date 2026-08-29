import re

with open('lib/screens/synap_music/main_home_screen.dart', 'r') as f:
    content = f.read()

# Add SettingsScreen import if not exists
if "import '../../screens/settings_screen.dart';" not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../../screens/settings_screen.dart';")

# We want to add an AppBar to the HomeTab or MainHomeScreen.
# If we add it to MainHomeScreen, it stays across tabs. Let's add it there.
appbar_code = """
      appBar: AppBar(
        title: const Text('SynapMusic'),
        backgroundColor: synapColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          ),
        ],
      ),
      body: Column(
"""

content = content.replace("      body: Column(", appbar_code)

with open('lib/screens/synap_music/main_home_screen.dart', 'w') as f:
    f.write(content)

print("Settings button added to MainHomeScreen")
