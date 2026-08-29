import re

with open('cliente-finamp/lib/screens/synap_music/album_detail_screen.dart', 'r') as f:
    content = f.read()

# Add import
imports_pattern = "import 'package:flutter/material.dart';"
imports_new = """import 'package:flutter/material.dart';
import '../../services/media_state_stream.dart';"""
if "services/media_state_stream.dart" not in content:
    content = content.replace(imports_pattern, imports_new)

# Replace ListTile
listtile_pattern = """                          return ListTile(
                            leading: SizedBox(
                              width: 30,
                              child: Center(
                                child: Text(
                                  '${track['track_number'] ?? index + 1}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            title: Text(track['title'] ?? 'Unknown Track'),
                            subtitle: Text(track['artist'] ?? ''),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(durationStr, style: const TextStyle(color: Colors.grey)),
                                actionButton,
                              ],
                            ),
                          );"""

listtile_new = """                          final trackId = (track['local_match'] != null && track['local_match']['exists'] == true) 
                              ? track['local_match']['jellyfin_data']['Id'] 
                              : null;

                          final tile = ListTile(
                            leading: SizedBox(
                              width: 30,
                              child: Center(
                                child: Text(
                                  '${track['track_number'] ?? index + 1}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            title: Text(track['title'] ?? 'Unknown Track'),
                            subtitle: Text(track['artist'] ?? ''),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(durationStr, style: const TextStyle(color: Colors.grey)),
                                actionButton,
                              ],
                            ),
                          );

                          if (trackId == null) return tile;

                          return StreamBuilder<MediaState>(
                            stream: mediaStateStream,
                            builder: (context, snapshot) {
                              final isPlaying = snapshot.data?.mediaItem?.id == trackId;
                              final color = isPlaying ? const Color(0xFF144477).withOpacity(0.2) : Colors.transparent;
                              return Container(
                                color: color,
                                child: Row(
                                  children: [
                                    if (isPlaying)
                                      Container(width: 4, height: 40, color: const Color(0xFF144477), margin: const EdgeInsets.only(left: 4)),
                                    Expanded(child: tile),
                                  ],
                                ),
                              );
                            },
                          );"""
content = content.replace(listtile_pattern, listtile_new)

with open('cliente-finamp/lib/screens/synap_music/album_detail_screen.dart', 'w') as f:
    f.write(content)
