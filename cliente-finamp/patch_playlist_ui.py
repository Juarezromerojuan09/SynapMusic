with open('lib/screens/synap_music/playlist_detail_screen.dart', 'r') as f:
    content = f.read()

import re

# We will replace the return SliverList block.
old_sliver = """              final tracks = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final track = tracks[index];
                    final artist = (track.artists?.isNotEmpty == true) ? track.artists![0] : 'Desconocido';
                    final trackImageUrl = 'http://192.168.3.23:8096/Items/${track.id}/Images/Primary';
                    
                    return TrackListItem("""

new_sliver = """              final tracks = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) {
                      return ValueListenableBuilder<Box<DownloadedParent>>(
                        valueListenable: _downloadsHelper.downloadedParentsListenable,
                        builder: (context, box, child) {
                          final isDownloaded = box.containsKey(widget.playlist.id);
                          return SwitchListTile(
                            title: const Text('Disponible sin conexión', style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: const Text('Descarga las canciones y letras locales'),
                            activeColor: _synapColor,
                            value: isDownloaded,
                            onChanged: _isDownloading ? null : (val) => _toggleDownload(val, tracks),
                          );
                        },
                      );
                    }
                    
                    final trackIndex = index - 1;
                    final track = tracks[trackIndex];
                    final artist = (track.artists?.isNotEmpty == true) ? track.artists![0] : 'Desconocido';
                    final trackImageUrl = 'http://192.168.3.23:8096/Items/${track.id}/Images/Primary';
                    
                    return TrackListItem("""

content = content.replace(old_sliver, new_sliver)

# Also need to update childCount
old_child_count = """                  childCount: tracks.length,
                ),
              );
            },
          ),
        ],"""

new_child_count = """                  childCount: tracks.length + 1,
                ),
              );
            },
          ),
        ],"""

if old_child_count in content:
    content = content.replace(old_child_count, new_child_count)
else:
    # Let's find childCount manually if it looks different
    content = re.sub(r"                  childCount: tracks\.length,\n                \),\n              \);\n            \},\n          \),\n        \],", new_child_count, content)

with open('lib/screens/synap_music/playlist_detail_screen.dart', 'w') as f:
    f.write(content)

print("Playlist UI patched with proper sliver logic")
