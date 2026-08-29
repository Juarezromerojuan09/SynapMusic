import re

with open('cliente-finamp/lib/screens/synap_music/album_detail_screen.dart', 'r') as f:
    content = f.read()

old_block = """                          final tile = ListTile(
                            leading: SizedBox(
                              width: 30,
                              child: Center(
                                child: Text(
                                  '${track['track_number'] ?? index + 1}',
                                  style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
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
                              final mediaItem = snapshot.data?.mediaItem;
                              final playingId = mediaItem?.extras?['itemJson']?['Id'];
                              final isPlaying = playingId != null && playingId == trackId;
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

new_block = """                          return TrackListItem(
                            trackId: trackId,
                            title: track['title'] ?? 'Unknown Track',
                            artist: track['artist'] ?? '',
                            duration: durationStr,
                            isAvailableInServer: (track['local_match'] != null && track['local_match']['exists'] == true),
                            trackNumber: track['track_number'] ?? index + 1,
                            trailingWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                actionButton,
                              ],
                            ),
                            onPlayPressed: () async {
                              try {
                                List<BaseItemDto> availableTracks = [];
                                int targetIndex = 0;
                                for (int i = 0; i < _tracks.length; i++) {
                                  final t = _tracks[i];
                                  final lm = t['local_match'];
                                  if (lm != null && lm['exists'] == true && lm['jellyfin_data'] != null) {
                                    availableTracks.add(BaseItemDto.fromJson(lm['jellyfin_data']));
                                    if (i == index) targetIndex = availableTracks.length - 1;
                                  }
                                }
                                await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
                                  itemList: availableTracks,
                                  initialIndex: targetIndex,
                                );
                                if (mounted) {
                                  Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al reproducir: $e')));
                                }
                              }
                            },
                          );"""

content = content.replace(old_block, new_block)

with open('cliente-finamp/lib/screens/synap_music/album_detail_screen.dart', 'w') as f:
    f.write(content)
