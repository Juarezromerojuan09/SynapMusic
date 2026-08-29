with open('lib/screens/synap_music/download_screen.dart', 'r') as f:
    content = f.read()

import re

# Update _isSpotifyUrl to _isDirectUrl globally
content = content.replace("_isSpotifyUrl", "_isDirectUrl")

# Update the check logic
old_check = """    // Detectar si es una URL de Spotify
    if (query.contains('spotify.com/')) {"""

new_check = """    // Detectar si es una URL de Spotify o Deezer
    if (query.contains('spotify.com/') || query.contains('deezer.com/') || query.contains('youtube.com/') || query.contains('youtu.be/')) {"""

content = content.replace(old_check, new_check)

# Update the widget name and text
old_widget = """  Widget _buildSpotifyUrlCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.link, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Enlace de Spotify Detectado',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),"""

new_widget = """  Widget _buildSpotifyUrlCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.link, size: 64, color: _synapColor),
            const SizedBox(height: 16),
            const Text(
              'Enlace Externo Detectado',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),"""

content = content.replace(old_widget, new_widget)

with open('lib/screens/synap_music/download_screen.dart', 'w') as f:
    f.write(content)

print("Download screen URL detection patched")
