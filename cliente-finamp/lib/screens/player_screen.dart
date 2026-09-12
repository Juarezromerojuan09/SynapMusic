import 'dart:math';
import 'dart:ui';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:octo_image/octo_image.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/favourite_button.dart';
import '../services/finamp_settings_helper.dart';
import '../services/music_player_background_task.dart';
import '../models/jellyfin_models.dart';
import '../models/lyric_line.dart';
import '../services/synap_api_service.dart';
import '../services/progress_state_stream.dart';
import '../services/likes_playlist_helper.dart';
import '../components/album_image.dart';
import '../components/PlayerScreen/song_name.dart';
import '../components/PlayerScreen/progress_slider.dart';
import '../components/PlayerScreen/player_buttons.dart';
import '../components/PlayerScreen/queue_button.dart';
import '../components/PlayerScreen/player_options_menu_sheet.dart';
import '../components/PlayerScreen/full_screen_lyrics_view.dart';

final _albumImageProvider =
    StateProvider.autoDispose<ImageProvider?>((_) => null);

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  static const routeName = "/nowplaying";

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  bool _isShowingLyrics = false;
  bool _isFullScreenLyrics = false;
  bool _isLoadingLyrics = false;
  List<LyricLine> _realLyrics = [];
  String? _loadedLyricsItemId;
  String? _fetchingItemId;

  Future<void> _fetchLyricsForTrack(String artist, String title, String itemId) async {
    if (_fetchingItemId == itemId && _isLoadingLyrics) return;

    _fetchingItemId = itemId;
    if (mounted) {
      setState(() {
        _isLoadingLyrics = true;
        _realLyrics = [];
        _loadedLyricsItemId = null;
      });
    }

    try {
      String? lrcContent;
      try {
        final directory = await getApplicationDocumentsDirectory();
        final lyricsDir = Directory('${directory.path}/lyrics');
        final file = File('${lyricsDir.path}/$itemId.lrc');

        if (await file.exists()) {
          final content = await file.readAsString();
          if (content.trim().isNotEmpty) {
            lrcContent = content;
          }
        }

        if (lrcContent == null || lrcContent.trim().isEmpty) {
          final synapApi = SynapApiService();
          lrcContent = await synapApi.getLyrics(artist, title);
          if (lrcContent != null && lrcContent.trim().isNotEmpty) {
            if (!await lyricsDir.exists()) await lyricsDir.create(recursive: true);
            await file.writeAsString(lrcContent);
          }
        }
      } catch (e) {
        try {
          final synapApi = SynapApiService();
          lrcContent = await synapApi.getLyrics(artist, title);
        } catch (_) {}
      }

      // Si el usuario cambió de canción mientras se cargaba, descartar respuesta
      if (!mounted || _fetchingItemId != itemId) return;

      if (lrcContent != null && lrcContent.trim().isNotEmpty) {
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

        if (parsedLyrics.isNotEmpty) {
          setState(() {
            _realLyrics = parsedLyrics;
            _loadedLyricsItemId = itemId;
            _isLoadingLyrics = false;
          });
          return;
        }
      }

      setState(() {
        _realLyrics = [const LyricLine(Duration.zero, "(Letras no disponibles)")];
        _loadedLyricsItemId = itemId;
        _isLoadingLyrics = false;
      });
    } catch (e) {
      if (!mounted || _fetchingItemId != itemId) return;
      setState(() {
        _realLyrics = [const LyricLine(Duration.zero, "(Error al cargar letras)")];
        _loadedLyricsItemId = itemId;
        _isLoadingLyrics = false;
      });
    } finally {
      if (mounted && _fetchingItemId == itemId && _isLoadingLyrics) {
        setState(() {
          _isLoadingLyrics = false;
        });
      }
    }
  }

  void _toggleLyrics(String? currentTrackId, String artist, String title) {
    final nextShowing = !_isShowingLyrics;
    setState(() {
      _isShowingLyrics = nextShowing;
    });

    if (nextShowing && currentTrackId != null) {
      if (_loadedLyricsItemId != currentTrackId) {
        if (artist.isNotEmpty && title.isNotEmpty) {
          _fetchLyricsForTrack(artist, title, currentTrackId);
        }
      }
    }
  }

  void _openFullScreenLyrics() {
    setState(() {
      _isFullScreenLyrics = true;
    });
  }

  void _closeFullScreenLyrics() {
    setState(() {
      _isFullScreenLyrics = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, mediaSnapshot) {
        final mediaItem = mediaSnapshot.data;
        BaseItemDto? item;
        if (mediaItem?.extras?["itemJson"] != null) {
          try {
            item = BaseItemDto.fromJson(mediaItem!.extras!["itemJson"]);
          } catch (_) {}
        }

        final currentTrackId = item?.id ?? mediaItem?.id;
        final artist = (item?.artists != null && item!.artists!.isNotEmpty)
            ? item.artists![0]
            : (item?.albumArtist ?? mediaItem?.artist ?? "");
        final title = item?.name ?? mediaItem?.title ?? "";

        // Sincronización reactiva de pista
        if (currentTrackId != null &&
            currentTrackId != _loadedLyricsItemId &&
            currentTrackId != _fetchingItemId) {
          if (_isShowingLyrics || _isFullScreenLyrics) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && artist.isNotEmpty && title.isNotEmpty) {
                _fetchLyricsForTrack(artist, title, currentTrackId);
              }
            });
          } else {
            _realLyrics = [];
            _loadedLyricsItemId = null;
          }
        }

        return WillPopScope(
          onWillPop: () async {
            if (_isFullScreenLyrics) {
              _closeFullScreenLyrics();
              return false;
            }
            return true;
          },
          child: SimpleGestureDetector(
            onVerticalSwipe: (direction) {
              if (_isFullScreenLyrics) return;
              if (!FinampSettingsHelper.finampSettings.disableGesture &&
                  direction == SwipeDirection.down) {
                Navigator.of(context).pop();
              }
            },
            onHorizontalSwipe: (direction) {
              if (_isFullScreenLyrics) return;
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
              backgroundColor: const Color(0xFF0A0A0A),
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  if (FinampSettingsHelper.finampSettings.showCoverAsPlayerBackground)
                    const RepaintBoundary(child: _BlurredPlayerScreenBackground()),
                  Visibility(
                    visible: !_isFullScreenLyrics,
                    maintainState: true,
                    child: SafeArea(
                      child: Column(
                        children: [
                          // Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.white, size: 30),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "NOW PLAYING",
                                        style: TextStyle(
                                          color: Color(0xFFA0A0A0),
                                          fontSize: 11,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        mediaItem?.album ?? "SynapMusic",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert, color: Colors.white),
                                  tooltip: 'Más opciones',
                                  onPressed: mediaItem == null
                                      ? null
                                      : () => PlayerOptionsMenuSheet.show(context, mediaItem),
                                ),
                              ],
                            ),
                          ),

                          // Artwork / Fase 1 Lyrics
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 16.0),
                              child: _PlayerScreenAlbumImage(
                                item: item,
                                mediaItem: mediaItem,
                                isShowingLyrics: _isShowingLyrics,
                                isLoadingLyrics: _isLoadingLyrics,
                                lyrics: _realLyrics,
                                onToggleLyrics: () =>
                                    _toggleLyrics(currentTrackId, artist, title),
                                onOpenFullScreen: _openFullScreenLyrics,
                              ),
                            ),
                          ),

                          // Controls Section
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Info Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Expanded(child: SongName()),
                                      const SizedBox(width: 8),
                                      const _PlayerScreenFavoriteButton(),
                                    ],
                                  ),

                                  // Progress Bar
                                  const ProgressSlider(),

                                  // Playback Controls
                                  const PlayerButtons(),

                                  // Bottom Actions
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.cast, color: Color(0xFFA0A0A0)),
                                      const QueueButton(),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Fase 2: Vista de pantalla completa para letras (Full Screen)
                  if (_isFullScreenLyrics)
                    Positioned.fill(
                      child: FullScreenLyricsView(
                        onClose: _closeFullScreenLyrics,
                        lyrics: _realLyrics,
                        isLoading: _isLoadingLyrics,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PlayerScreenAlbumImage extends ConsumerWidget {
  final BaseItemDto? item;
  final MediaItem? mediaItem;
  final bool isShowingLyrics;
  final bool isLoadingLyrics;
  final List<LyricLine> lyrics;
  final VoidCallback onToggleLyrics;
  final VoidCallback onOpenFullScreen;

  const _PlayerScreenAlbumImage({
    Key? key,
    required this.item,
    required this.mediaItem,
    required this.isShowingLyrics,
    required this.isLoadingLyrics,
    required this.lyrics,
    required this.onToggleLyrics,
    required this.onOpenFullScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    final bool hasImage = item != null &&
        (item!.imageId != null ||
            (item!.overview != null &&
                (item!.overview!.startsWith('http://') ||
                    item!.overview!.startsWith('https://'))));

    final Widget originalImage = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.55),
            blurRadius: 28,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: hasImage
              ? LayoutBuilder(builder: (context, constraints) {
                  final MediaQueryData mediaQuery = MediaQuery.of(context);
                  final int physicalWidth =
                      (constraints.maxWidth * mediaQuery.devicePixelRatio).toInt();
                  final int physicalHeight =
                      (constraints.maxHeight * mediaQuery.devicePixelRatio).toInt();

                  return BareAlbumImage(
                    item: item!,
                    maxWidth: physicalWidth,
                    maxHeight: physicalHeight,
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
                })
              : (mediaItem?.artUri != null)
                  ? Image.network(
                      mediaItem!.artUri.toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF1A1A1A),
                        child: const Icon(Icons.music_note, size: 80, color: Color(0xFFA0A0A0)),
                      ),
                    )
                  : Container(
                      color: const Color(0xFF1A1A1A),
                      child: const Icon(Icons.music_note, size: 80, color: Color(0xFFA0A0A0)),
                    ),
        ),
      ),
    );

    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Mantener originalImage activo para que el fondo difuminado continúe
            // actualizándose al cambiar de canción, pero oculto si se muestra la letra.
            Visibility(
              visible: !isShowingLyrics,
              maintainState: true,
              maintainSize: true,
              maintainAnimation: true,
              child: originalImage,
            ),

            // Fase 1: Letra activa sobre fondo transparente (directamente sobre la portada difuminada)
            if (isShowingLyrics)
              Positioned.fill(
                child: GestureDetector(
                  onTap: onOpenFullScreen,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: isLoadingLyrics
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : lyrics.isEmpty
                            ? Text(
                                "(Letras no disponibles)",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : StreamBuilder<ProgressState>(
                                stream: progressStateStream,
                                builder: (context, progressSnapshot) {
                                  final currentDuration =
                                      progressSnapshot.data?.position ?? Duration.zero;

                                  int activeIndex = -1;
                                  for (int i = 0; i < lyrics.length; i++) {
                                    if (currentDuration >= lyrics[i].time &&
                                        lyrics[i].time != Duration.zero) {
                                      activeIndex = i;
                                    } else if (lyrics[i].time != Duration.zero &&
                                        currentDuration < lyrics[i].time) {
                                      break;
                                    }
                                  }

                                  String activeText = "...";
                                  if (activeIndex >= 0) {
                                    activeText = lyrics[activeIndex].text;
                                  } else if (lyrics.isNotEmpty) {
                                    activeText = lyrics[0].text;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 350),
                                      transitionBuilder: (child, animation) => FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                      child: Text(
                                        activeText,
                                        key: ValueKey<String>(activeText),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 27,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white, // Presente: FULL BLANCO
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0, 2),
                                              blurRadius: 10.0,
                                              color: Colors.black87,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
              ),

            // Pastilla "Letra" en la esquina inferior izquierda
            Positioned(
              bottom: 12,
              left: 12,
              child: InkWell(
                onTap: onToggleLyrics,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isShowingLyrics ? Colors.white : Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isShowingLyrics
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    "Letra",
                    style: TextStyle(
                      color: isShowingLyrics ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        final mediaItem = snapshot.data;
        if (mediaItem == null) {
          return const SizedBox(width: 44, height: 44);
        }

        BaseItemDto? item;
        if (mediaItem.extras?["itemJson"] != null) {
          try {
            item = BaseItemDto.fromJson(mediaItem.extras!["itemJson"]);
          } catch (_) {}
        }

        final trackId = item?.id ?? mediaItem.id;
        final title = item?.name ?? mediaItem.title;
        final artist = (item?.artists != null && item!.artists!.isNotEmpty)
            ? item.artists!.first
            : (item?.albumArtist ?? mediaItem.artist ?? '');

        return ValueListenableBuilder<Set<String>>(
          valueListenable: LikesPlaylistHelper.likedSongKeys,
          builder: (context, likedKeys, _) {
            return ValueListenableBuilder<Set<String>>(
              valueListenable: LikesPlaylistHelper.likedSongIds,
              builder: (context, likedIds, _) {
                final isLiked = LikesPlaylistHelper.isSongLiked(
                  trackId: trackId,
                  title: title,
                  artist: artist,
                );

                return IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? const Color(0xFF8B93FF) : const Color(0xFFA0A0A0),
                    size: 28.0,
                  ),
                  tooltip: isLiked ? 'Eliminar de My likes' : 'Guardar en My likes',
                  padding: const EdgeInsets.all(8.0),
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  splashRadius: 24,
                  onPressed: () async {
                    await LikesPlaylistHelper.toggleLike(
                      trackId: trackId,
                      title: title,
                      artist: artist,
                      context: context,
                    );
                    try {
                      final extras = audioHandler.mediaItem.valueOrNull?.extras;
                      if (extras != null && extras['itemJson'] != null) {
                        final map = Map<String, dynamic>.from(extras['itemJson']);
                        map['UserData'] = {
                          ...(map['UserData'] ?? {}),
                          'IsFavorite': !isLiked,
                        };
                        extras['itemJson'] = map;
                      }
                    } catch (_) {}
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
