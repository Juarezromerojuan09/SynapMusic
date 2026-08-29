with open('lib/components/create_playlist_dialog.dart', 'r') as f:
    content = f.read()

import re

if "import 'package:get_it/get_it.dart';" not in content:
    content = content.replace("import '../services/synap_api_service.dart';", "import '../services/synap_api_service.dart';\nimport 'package:get_it/get_it.dart';\nimport '../services/finamp_user_helper.dart';")

old_create = """    final playlistId = await _apiService.createPlaylist(name);"""

new_create = """    final userHelper = GetIt.instance<FinampUserHelper>();
    final userId = userHelper.currentUser?.id;
    final playlistId = await _apiService.createPlaylist(name, userId: userId);"""

content = content.replace(old_create, new_create)

with open('lib/components/create_playlist_dialog.dart', 'w') as f:
    f.write(content)

print("Dialog patched")
