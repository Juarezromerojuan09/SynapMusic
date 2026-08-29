import re

with open('cliente-finamp/lib/screens/synap_music/album_detail_screen.dart', 'r') as f:
    content = f.read()

bad_block = """                          } else {
                            actionButton = const SizedBox.shrink();
                            /* IconButton(
                              icon: const Icon(Icons.download, color: Color(0xFF1DB954)),
                              onPressed: () {
                                _apiService.downloadMedia(track['query_string']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Descarga de pista encolada: ${track['title']}')),
                                );
                              },
                            );
                          }"""

good_block = """                          } else {
                            actionButton = IconButton(
                              icon: const Icon(Icons.download, color: Color(0xFF1DB954)),
                              onPressed: () {
                                _apiService.downloadMedia(track['query_string']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Descarga de pista encolada: ${track['title']}')),
                                );
                              },
                            );
                          }"""

content = content.replace(bad_block, good_block)

bad_block2 = """                          Widget actionButton;
                          if (track['local_match'] != null && track['local_match']['exists'] == true) {
                            actionButton = const SizedBox.shrink();
                            /* IconButton(
                              icon: const Icon(Icons.play_circle_fill, color: Color(0xFF1DB954)),
                              onPressed: () async {"""

good_block2 = """                          Widget actionButton;
                          if (track['local_match'] != null && track['local_match']['exists'] == true) {
                            actionButton = IconButton(
                              icon: const Icon(Icons.more_vert, color: Colors.white),
                              onPressed: () {},
                            );"""

content = re.sub(r"actionButton = const SizedBox\.shrink\(\);\s*/\* IconButton\(\s*icon: const Icon\(Icons\.play_circle_fill.*?(?=\} catch)", good_block2 + "\n", content, flags=re.DOTALL)

with open('cliente-finamp/lib/screens/synap_music/album_detail_screen.dart', 'w') as f:
    f.write(content)
