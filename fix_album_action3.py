import re

with open('cliente-finamp/lib/screens/synap_music/album_detail_screen.dart', 'r') as f:
    content = f.read()

pattern = r"                          Widget actionButton;.*?if \(_tracks\.length\)"
replacement = """                          Widget actionButton;
                          if (existsLocal) {
                            actionButton = IconButton(
                              icon: const Icon(Icons.more_vert, color: Colors.white),
                              onPressed: () {},
                            );
                          } else {
                            actionButton = IconButton(
                              icon: const Icon(Icons.download, color: Color(0xFF1DB954)),
                              onPressed: () {
                                _apiService.downloadMedia(track['query_string']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Descarga de pista encolada: ${track['title']}')),
                                );
                              },
                            );
                          }

                          final trackId = existsLocal ? track['local_match']['jellyfin_data']['Id'] : null;

                          return TrackListItem(
                            trackId: trackId,
                            title: track['title'] ?? 'Unknown Track',
                            artist: track['artist'] ?? '',
                            duration: durationStr,
                            isAvailableInServer: existsLocal,
                            trackNumber: (track['track_number'] != null && track['track_number'] != 0) ? track['track_number'] : index + 1,
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
                          );
                        },
                        childCount: _tracks.length,
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                  ],
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
"""

content = re.sub(r"                          Widget actionButton;.*?\}\n}\n", replacement, content, flags=re.DOTALL)

with open('cliente-finamp/lib/screens/synap_music/album_detail_screen.dart', 'w') as f:
    f.write(content)
