import re

with open('cliente-finamp/lib/screens/synap_music/album_detail_screen.dart', 'r') as f:
    content = f.read()

pattern = r"""                          if \(track\['local_match'\] != null && track\['local_match'\]\['exists'\] == true\) \{
                            actionButton = IconButton\(
                              icon: const Icon\(Icons\.play_circle_fill, color: Color\(0xFF1DB954\)\),
                              onPressed: \(\) async \{
                                try \{
                                  // Crear cola solo con canciones disponibles
                                  List<BaseItemDto> availableTracks = \[\];
                                  int targetIndex = 0;
                                  for \(int i = 0; i < _tracks\.length; i\+\+\) \{
                                    final t = _tracks\[i\];
                                    final lm = t\['local_match'\];
                                    if \(lm != null && lm\['exists'\] == true && lm\['jellyfin_data'\] != null\) \{
                                      availableTracks\.add\(BaseItemDto\.fromJson\(lm\['jellyfin_data'\]\)\);
                                      if \(i == index\) \{
                                        targetIndex = availableTracks\.length - 1;
                                      \}
                                    \}
                                  \}
                                  
                                  await GetIt\.instance<AudioServiceHelper>\(\)\.replaceQueueWithItem\(
                                    itemList: availableTracks,
                                    initialIndex: targetIndex,
                                  \);
                                  if \(mounted\) \{
                                    Navigator\.of\(context, rootNavigator: true\)\.pushNamed\(PlayerScreen\.routeName\);
                                  \}
                                \} catch \(e\) \{
                                  if \(mounted\) \{
                                    ScaffoldMessenger\.of\(context\)\.showSnackBar\(
                                      SnackBar\(content: Text\('Error al reproducir: \$e'\)\),
                                    \);
                                  \}
                                \}
                              \},
                            \);
                          \} else \{"""

replacement = """                          if (track['local_match'] != null && track['local_match']['exists'] == true) {
                            actionButton = IconButton(
                                icon: const Icon(Icons.more_vert, color: Colors.white),
                                onPressed: () {
                                  // TODO: Opciones de canción
                                },
                            );
                          } else {"""

content = re.sub(pattern, replacement, content, flags=re.MULTILINE)

with open('cliente-finamp/lib/screens/synap_music/album_detail_screen.dart', 'w') as f:
    f.write(content)
