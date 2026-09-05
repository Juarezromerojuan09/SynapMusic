import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../services/finamp_settings_helper.dart';
import '../services/media_state_stream.dart';
import '../services/progress_state_stream.dart';
import 'album_image.dart';
import '../models/jellyfin_models.dart';
import '../services/process_artist.dart';
import '../services/music_player_background_task.dart';
import '../screens/player_screen.dart';
import 'PlayerScreen/progress_slider.dart';

class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // BottomNavBar's default elevation is 8 (https://api.flutter.dev/flutter/material/BottomNavigationBar/elevation.html)
    const elevation = 8.0;
    final color = Theme.of(context).bottomNavigationBarTheme.backgroundColor;

    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return SimpleGestureDetector(
      onVerticalSwipe: (direction) {
        if (direction == SwipeDirection.up) {
          Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
        }
      },
      child: StreamBuilder<MediaState>(
        stream: mediaStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final playing = snapshot.data!.playbackState.playing;

            // If we have a media item and the player hasn't finished, show
            // the now playing bar.
            if (snapshot.data!.mediaItem != null) {
              final item = BaseItemDto.fromJson(
                  snapshot.data!.mediaItem!.extras!["itemJson"]);

              return Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Dismissible(
                        key: const Key("NowPlayingBar"),
                        direction: FinampSettingsHelper.finampSettings.disableGesture ? DismissDirection.none : DismissDirection.horizontal,
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            audioHandler.skipToNext();
                          } else {
                            audioHandler.skipToPrevious();
                          }
                          return false;
                        },
                        background: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Icon(Icons.skip_previous, color: Colors.white),
                                  ),
                                ),
                              ),
                              AspectRatio(
                                aspectRatio: 1,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Icon(Icons.skip_next, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: InkWell(
                          onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: AlbumImage(item: item),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.mediaItem!.title,
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        processArtist(
                                            snapshot.data!.mediaItem!.artist, context),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFFA0A0A0),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    playing ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    if (playing) {
                                      audioHandler.pause();
                                    } else {
                                      audioHandler.play();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.skip_next, color: Colors.white, size: 28),
                                  onPressed: () => audioHandler.skipToNext(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 2,
                          child: StreamBuilder<ProgressState>(
                            stream: progressStateStream,
                            builder: (context, progressSnapshot) {
                              final duration = progressSnapshot.data?.total ?? progressSnapshot.data?.mediaItem?.duration ?? Duration.zero;
                              final position = progressSnapshot.data?.position ?? Duration.zero;
                              double value = 0.0;
                              if (duration.inMilliseconds > 0) {
                                value = position.inMilliseconds / duration.inMilliseconds;
                              }
                              return LinearProgressIndicator(
                                value: value.clamp(0.0, 1.0),
                                backgroundColor: const Color(0xFF252525),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B93FF)),
                                minHeight: 2,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}