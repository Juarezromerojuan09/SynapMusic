import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/lyric_line.dart';
import '../../services/music_player_background_task.dart';
import '../../services/progress_state_stream.dart';

class FullScreenLyricsView extends StatefulWidget {
  final VoidCallback onClose;
  final List<LyricLine> lyrics;
  final bool isLoading;

  const FullScreenLyricsView({
    Key? key,
    required this.onClose,
    required this.lyrics,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<FullScreenLyricsView> createState() => _FullScreenLyricsViewState();
}

class _FullScreenLyricsViewState extends State<FullScreenLyricsView> {
  final ScrollController _scrollController = ScrollController();
  List<GlobalKey> _lyricKeys = [];
  int _lastActiveIndex = -1;

  @override
  void initState() {
    super.initState();
    _initKeys();
  }

  @override
  void didUpdateWidget(covariant FullScreenLyricsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lyrics != oldWidget.lyrics) {
      _initKeys();
      _lastActiveIndex = -1;
    }
  }

  void _initKeys() {
    _lyricKeys = List.generate(widget.lyrics.length, (_) => GlobalKey());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return Container(
      color: Colors.black.withOpacity(0.35),
      child: Column(
        children: [
          // Header superior con botón X
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Cuerpo de la letra con scroll automático y 2 tonalidades
          Expanded(
            child: widget.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : widget.lyrics.isEmpty
                    ? Center(
                        child: Text(
                          "(Letras no disponibles)",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : StreamBuilder<ProgressState>(
                        stream: progressStateStream,
                        builder: (context, progressSnapshot) {
                          final currentDuration =
                              progressSnapshot.data?.position ?? Duration.zero;

                          int activeIndex = -1;
                          for (int i = 0; i < widget.lyrics.length; i++) {
                            if (currentDuration >= widget.lyrics[i].time &&
                                widget.lyrics[i].time != Duration.zero) {
                              activeIndex = i;
                            } else if (widget.lyrics[i].time != Duration.zero &&
                                currentDuration < widget.lyrics[i].time) {
                              break;
                            }
                          }

                          if (activeIndex != -1 &&
                              activeIndex != _lastActiveIndex &&
                              _scrollController.hasClients) {
                            _lastActiveIndex = activeIndex;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (activeIndex < _lyricKeys.length) {
                                final key = _lyricKeys[activeIndex];
                                if (key.currentContext != null) {
                                  Scrollable.ensureVisible(
                                    key.currentContext!,
                                    alignment: 0.38,
                                    duration: const Duration(milliseconds: 550),
                                    curve: Curves.easeOutCubic,
                                  );
                                }
                              }
                            });
                          }

                          return SingleChildScrollView(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                              vertical: 200,
                              horizontal: 24,
                            ),
                            child: Column(
                              children: List.generate(widget.lyrics.length, (index) {
                                final isCurrent = index == activeIndex;
                                final line = widget.lyrics[index];

                                return GestureDetector(
                                  onTap: () {
                                    if (line.time != Duration.zero) {
                                      audioHandler.seek(line.time);
                                    }
                                  },
                                  child: Padding(
                                    key: _lyricKeys.length > index
                                        ? _lyricKeys[index]
                                        : null,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Text(
                                      line.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: isCurrent ? 28 : 21,
                                        fontWeight: isCurrent
                                            ? FontWeight.w800
                                            : FontWeight.w600,
                                        color: isCurrent
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.40),
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: isCurrent ? 8.0 : 4.0,
                                            color: Colors.black.withOpacity(
                                                isCurrent ? 0.9 : 0.6),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
          ),

          // Barra inferior con Título, Artista, Play/Pausa y Next
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.55),
                  Colors.black.withOpacity(0.85),
                ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 14.0,
                ),
                child: Row(
                  children: [
                    // Título y Artista a la izquierda
                    Expanded(
                      child: StreamBuilder<MediaItem?>(
                        stream: audioHandler.mediaItem,
                        builder: (context, snapshot) {
                          final title = snapshot.data?.title ?? "Sin título";
                          final artist = snapshot.data?.artist ?? "";

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                artist,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.70),
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Botones Play/Pausa y Next a la derecha
                    StreamBuilder<PlaybackState>(
                      stream: audioHandler.playbackState.distinct((prev, curr) =>
                          prev.playing == curr.playing &&
                          prev.processingState == curr.processingState),
                      builder: (context, snapshot) {
                        final isPlaying = snapshot.data?.playing ?? false;

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (isPlaying) {
                                  await audioHandler.pause();
                                } else {
                                  await audioHandler.play();
                                }
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.22),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                size: 34,
                              ),
                              tooltip: 'Siguiente',
                              onPressed: () async {
                                await audioHandler.skipToNext();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
