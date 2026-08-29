with open('lib/screens/synap_music/download_screen.dart', 'r') as f:
    content = f.read()

import re

if "import 'package:get_it/get_it.dart';" not in content:
    content = content.replace("import '../../services/synap_api_service.dart';", "import '../../services/synap_api_service.dart';\nimport 'package:get_it/get_it.dart';\nimport '../../services/finamp_user_helper.dart';")

old_handle = """  Future<void> _handleDownload(String query) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Encolando descarga en el servidor...')),
    );

    final success = await _apiService.downloadMedia(query);
    
    if (success && mounted) {"""

new_handle = """  Future<void> _handleDownload(String query) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Encolando tarea en el servidor...')),
    );

    bool success = false;
    final isPlaylist = query.contains('playlist');
    
    if (_isDirectUrl && isPlaylist) {
      final userHelper = GetIt.instance<FinampUserHelper>();
      final userId = userHelper.currentUser?.id;
      if (userId != null) {
        success = await _apiService.migratePlaylist(query, userId);
      } else {
        success = await _apiService.downloadMedia(query);
      }
    } else {
      success = await _apiService.downloadMedia(query);
    }
    
    if (success && mounted) {"""

content = content.replace(old_handle, new_handle)

with open('lib/screens/synap_music/download_screen.dart', 'w') as f:
    f.write(content)

print("Download screen patched to use migratePlaylist")
