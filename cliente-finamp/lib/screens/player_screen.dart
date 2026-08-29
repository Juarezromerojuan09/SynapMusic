import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:octo_image/octo_image.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/favourite_button.dart';
import '../services/finamp_settings_helper.dart';
import '../services/music_player_background_task.dart';
import '../models/jellyfin_models.dart';
import '../services/synap_api_service.dart';
import '../services/progress_state_stream.dart';
import 'dart:math';
import '../components/album_image.dart';
import '../components/PlayerScreen/song_name.dart';
import '../components/PlayerScreen/progress_slider.dart';
import '../components/PlayerScreen/player_buttons.dart';
import '../components/PlayerScreen/queue_button.dart';
import '../components/PlayerScreen/playback_mode.dart';
import '../components/PlayerScreen/add_to_playlist_button.dart';
import '../components/PlayerScreen/sleep_timer_button.dart';

final _albumImageProvider =
    StateProvider.autoDispose<ImageProvider?>((_) => null);

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  static const routeName = "/nowplaying";

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return SimpleGestureDetector(
      onVerticalSwipe: (direction) {
        if (!FinampSettingsHelper.finampSettings.disableGesture &&
            direction == SwipeDirection.down) {
          Navigator.of(context).pop();
        }
      },
      onHorizontalSwipe: (direction) {
        if (!FinampSettingsHelper.finampSettings.disableGesture) {
          switch (direction) {
            case SwipeDirection.left:
              audioHandler.skipToNext();
              break;
            case SwipeDirection.right:
              audioHandler.skipToPrevious();
              break;
            default:
              break;
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: const [
            SleepTimerButton(),
            AddToPlaylistButton(),
          ],
        ),
        // Required for sleep timer input
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            if (FinampSettingsHelper.finampSettings.showCoverAsPlayerBackground)
              const _BlurredPlayerScreenBackground(),
            const SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _PlayerScreenAlbumImage(),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SongName(),
                            ProgressSlider(),
                            PlayerButtons(),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: PlaybackMode(),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: _PlayerScreenFavoriteButton(),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: QueueButton(),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// This widget is just an AlbumImage in a StreamBuilder to get the song id.
class LyricLine {
  final Duration time;
  final String text;
  LyricLine(this.time, this.text);
}

class _PlayerScreenAlbumImage extends ConsumerStatefulWidget {
  const _PlayerScreenAlbumImage({Key? key}) : super(key: key);

  @override
  ConsumerState<_PlayerScreenAlbumImage> createState() => _PlayerScreenAlbumImageState();
}

class _PlayerScreenAlbumImageState extends ConsumerState<_PlayerScreenAlbumImage> {
  bool _isShowingLyrics = false;
  bool _isLoadingLyrics = false;
  List<LyricLine> _realLyrics = [];
  List<GlobalKey> _lyricKeys = [];
  String? _currentItemId;
  final ScrollController _scrollController = ScrollController();
  int _lastActiveIndex = -1;

  Future<void> _fetchLyrics(String artist, String title, String itemId) async {
    setState(() {
      _isLoadingLyrics = true;
      _realLyrics = [];
      _lyricKeys = [];
      _lastActiveIndex = -1;
    });
    
    try {
      String? lrcContent;
      try {
        final directory = await getApplicationDocumentsDirectory();
        final lyricsDir = Directory('${directory.path}/lyrics');
        final file = File('${lyricsDir.path}/$itemId.lrc');
        
        if (await file.exists()) {
          lrcContent = await file.readAsString();
        } else {
          final synapApi = SynapApiService();
          lrcContent = await synapApi.getLyrics(artist, title);
          if (lrcContent != null && lrcContent.isNotEmpty) {
            if (!await lyricsDir.exists()) await lyricsDir.create(recursive: true);
            await file.writeAsString(lrcContent);
          }
        }
      } catch (e) {
        final synapApi = SynapApiService();
        lrcContent = await synapApi.getLyrics(artist, title);
      }
      
      if (lrcContent != null && lrcContent.isNotEmpty) {
        final lines = lrcContent.split('\n');
        final RegExp tagRegExp = RegExp(r'\[(\d+):(\d+\.\d+)\]');
        List<LyricLine> parsedLyrics = [];
        
        for (var line in lines) {
          final match = tagRegExp.firstMatch(line);
          if (match != null) {
            final int minutes = int.parse(match.group(1)!);
            final double seconds = double.parse(match.group(2)!);
            final duration = Duration(milliseconds: (minutes * 60000 + seconds * 1000).round());
            final text = line.replaceAll(tagRegExp, '').trim();
            if (text.isNotEmpty) {
              parsedLyrics.add(LyricLine(duration, text));
            }
          } else {
             final text = line.trim();
             if (text.isNotEmpty && !text.startsWith('[')) {
               parsedLyrics.add(LyricLine(Duration.zero, text));
             }
          }
        }
        
        setState(() {
          _realLyrics = parsedLyrics;
          _lyricKeys = List.generate(parsedLyrics.length, (index) => GlobalKey());
        });
      } else {
        setState(() {
          _realLyrics = [LyricLine(Duration.zero, "(Letras no encontradas en el servidor)")];
          _lyricKeys = [GlobalKey()];
        });
      }
    } catch (e) {
      setState(() {
        _realLyrics = [LyricLine(Duration.zero, "(Error cargando letras)")];
        _lyricKeys = [GlobalKey()];
      });
    } finally {
      setState(() {
        _isLoadingLyrics = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          final item = snapshot.data?.extras?["itemJson"] == null
              ? null
              : BaseItemDto.fromJson(snapshot.data!.extras!["itemJson"]);

          if (item != null && item.id != _currentItemId) {
            _currentItemId = item.id;
            if (_isShowingLyrics) {
              final artist = (item.artists != null && item.artists!.isNotEmpty) ? item.artists![0] : "";
              final title = item.name ?? "";
              _fetchLyrics(artist, title, item.id);
            }
          }

          final Widget originalImage = item == null
              ? AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: AlbumImage.borderRadius,
                    child: Container(color: Theme.of(context).cardColor),
                  ),
                )
              : AlbumImage(
                  item: item,
                  imageProviderCallback: (imageProvider) =>
                      WidgetsBinding.instance.addPostFrameCallback((_) => ref
                          .read(_albumImageProvider.notifier)
                          .state = imageProvider),
                  itemsToPrecache: audioHandler.queue.value
                      .sublist(min(
                          (audioHandler.playbackState.value.queueIndex ?? 0) + 1,
                          audioHandler.queue.value.length))
                      .take(3)
                      .map((e) => BaseItemDto.fromJson(e.extras!["itemJson"]))
                      .toList(),
                );

          return Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _isShowingLyrics
                    ? AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: AlbumImage.borderRadius,
                          ),
                          child: _isLoadingLyrics 
                            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF144477))))
                            : StreamBuilder<ProgressState>(
                                stream: progressStateStream,
                                builder: (context, progressSnapshot) {
                                  final currentDuration = progressSnapshot.data?.position ?? Duration.zero;
                                  
                                  int activeIndex = -1;
                                  for (int i = 0; i < _realLyrics.length; i++) {
                                    if (currentDuration >= _realLyrics[i].time && _realLyrics[i].time != Duration.zero) {
                                      activeIndex = i;
                                    } else if (_realLyrics[i].time != Duration.zero && currentDuration < _realLyrics[i].time) {
                                      break;
                                    }
                                  }
                                  
                                  if (activeIndex != -1 && activeIndex != _lastActiveIndex && _scrollController.hasClients) {
                                    _lastActiveIndex = activeIndex;
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (activeIndex < _lyricKeys.length) {
                                        final key = _lyricKeys[activeIndex];
                                        if (key.currentContext != null) {
                                          Scrollable.ensureVisible(
                                            key.currentContext!,
                                            alignment: 0.35, // 0.5 is exact center. 0.35 elevates it approx 15% upwards
                                            duration: const Duration(milliseconds: 600),
                                            curve: Curves.easeOutCubic,
                                          );
                                        }
                                      }
                                    });
                                  }

                                  return SingleChildScrollView(
                                    controller: _scrollController,
                                    padding: const EdgeInsets.symmetric(vertical: 180, horizontal: 16),
                                    child: Column(
                                      children: List.generate(_realLyrics.length, (index) {
                                        final isCurrent = index == activeIndex;
                                        final isPast = index < activeIndex;
                                        
                                        double opacity = 0.5;
                                        if (isCurrent) opacity = 1.0;
                                        else if (isPast) opacity = 0.8;
                                        
                                        return Padding(
                                          key: _lyricKeys[index],
                                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                                          child: Text(
                                            _realLyrics[index].text,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: isCurrent ? 30 : 22,
                                              fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                                              color: isCurrent ? const Color(0xFF144477) : Colors.white.withOpacity(opacity),
                                              shadows: [
                                                Shadow(
                                                  offset: const Offset(0, 1),
                                                  blurRadius: 4.0,
                                                  color: Colors.black.withOpacity(isCurrent ? 0.9 : 0.6),
                                                ),
                                              ]
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                },
                              ),
                        ),
                      )
                    : originalImage,
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: InkWell(
                  onTap: () {
                    final isNowShowing = !_isShowingLyrics;
                    setState(() {
                      _isShowingLyrics = isNowShowing;
                    });
                    
                    if (isNowShowing && item != null && _realLyrics.isEmpty) {
                      final artist = (item.artists != null && item.artists!.isNotEmpty) ? item.artists![0] : "";
                      final title = item.name ?? "";
                      _fetchLyrics(artist, title, item.id);
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isShowingLyrics ? const Color(0xFF144477) : Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Letra",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}



/// Same as [_PlayerScreenAlbumImage], but with a BlurHash instead. We also
/// filter the BlurHash so that it works as a background image.
class _BlurredPlayerScreenBackground extends ConsumerWidget {
  const _BlurredPlayerScreenBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageProvider = ref.watch(_albumImageProvider);

    return ClipRect(
      child: imageProvider == null
          ? const SizedBox.shrink()
          : OctoImage(
              image: imageProvider,
              fit: BoxFit.cover,
              placeholderBuilder: (_) => const SizedBox.shrink(),
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              imageBuilder: (context, child) => ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.35)
                        : Colors.white.withOpacity(0.75),
                    BlendMode.srcOver),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 85,
                    sigmaY: 85,
                    tileMode: TileMode.mirror,
                  ),
                  child: SizedBox.expand(child: child),
                ),
              ),
            ),
    );
  }
}

class _PlayerScreenFavoriteButton extends StatelessWidget {
  const _PlayerScreenFavoriteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          return FavoriteButton(
            item: snapshot.data?.extras?["itemJson"] == null
                ? null
                : BaseItemDto.fromJson(snapshot.data!.extras!["itemJson"]),
            inPlayer: true,
          );
        });
  }
}
