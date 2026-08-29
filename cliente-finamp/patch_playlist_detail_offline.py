with open('lib/screens/synap_music/playlist_detail_screen.dart', 'r') as f:
    content = f.read()

import re

if "import '../../services/finamp_settings_helper.dart';" not in content:
    content = content.replace("import '../../services/downloads_helper.dart';", "import '../../services/downloads_helper.dart';\nimport '../../services/finamp_settings_helper.dart';")

old_load = """  void _loadItems() {
    setState(() {
      _itemsFuture = GetIt.instance<JellyfinApiHelper>().getItems(
        parentItem: widget.playlist,
        isGenres: false,
      ).then((value) => value ?? []);
    });
  }"""

new_load = """  void _loadItems() {
    setState(() {
      if (FinampSettingsHelper.finampSettings.isOffline) {
        final parent = _downloadsHelper.getDownloadedParent(widget.playlist.id);
        if (parent != null) {
          _itemsFuture = Future.value(parent.downloadedChildren.values.toList());
        } else {
          _itemsFuture = Future.value([]);
        }
      } else {
        _itemsFuture = GetIt.instance<JellyfinApiHelper>().getItems(
          parentItem: widget.playlist,
          isGenres: false,
        ).then((value) => value ?? []).catchError((e) {
          final parent = _downloadsHelper.getDownloadedParent(widget.playlist.id);
          if (parent != null) {
            return parent.downloadedChildren.values.toList();
          }
          return <BaseItemDto>[];
        });
      }
    });
  }"""

content = content.replace(old_load, new_load)

# Fix _imageUrl if offline it should use local image if available, else network (which will fail if no internet, but errorBuilder will catch it)
# In Finamp, the image is loaded via AlbumImageProvider which handles local images gracefully, but since we manually used Image.network, let's just let errorBuilder catch it or we can use the DownloadedImage.
# I'll leave Image.network, offline it'll show the icon. That's fine for now, we want functionality over perfect images offline.

with open('lib/screens/synap_music/playlist_detail_screen.dart', 'w') as f:
    f.write(content)

print("Playlist detail patched for offline")
