with open('lib/screens/player_screen.dart', 'r') as f:
    content = f.read()

import re
pattern = r"class LyricLine \{.*?\}[\n\r]*"
content = re.sub(pattern, "", content, flags=re.DOTALL) # remove old LyricLine if exists

pattern = r"class _PlayerScreenAlbumImage extends ConsumerStatefulWidget \{.*?^\}"
match = re.search(pattern, content, flags=re.DOTALL | re.MULTILINE)
if match:
    old_widget = match.group(0)
else:
    print("Not found")
    exit(1)

# Make sure progress_state_stream is imported
if "progress_state_stream.dart" not in content:
    content = content.replace(
        "import '../services/synap_api_service.dart';",
        "import '../services/synap_api_service.dart';\nimport '../services/progress_state_stream.dart';\nimport 'dart:math';"
    )

new_widget = """class LyricLine {
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
  String? _currentItemId;
  final ScrollController _scrollController = ScrollController();
  int _lastActiveIndex = -1;

  Future<void> _fetchLyrics(String artist, String title) async {
    setState(() {
      _isLoadingLyrics = true;
      _realLyrics = [];
      _lastActiveIndex = -1;
    });
    
    try {
      final synapApi = SynapApiService();
      final lrcContent = await synapApi.getLyrics(artist, title);
      
      if (lrcContent != null && lrcContent.isNotEmpty) {
        final lines = lrcContent.split('\\n');
        final RegExp tagRegExp = RegExp(r'\\[(\\d+):(\\d+\\.\\d+)\\]');
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
        });
      } else {
        setState(() {
          _realLyrics = [LyricLine(Duration.zero, "(Letras no encontradas en el servidor)")];
        });
      }
    } catch (e) {
      setState(() {
        _realLyrics = [LyricLine(Duration.zero, "(Error cargando letras)")];
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
              _fetchLyrics(artist, title);
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
                                    final double offset = max(0.0, (activeIndex * 45.0) - 100.0);
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (_scrollController.hasClients) {
                                        _scrollController.animateTo(
                                          offset,
                                          duration: const Duration(milliseconds: 500),
                                          curve: Curves.easeOut,
                                        );
                                      }
                                    });
                                  }

                                  return ListView.builder(
                                    controller: _scrollController,
                                    padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 16),
                                    itemCount: _realLyrics.length,
                                    itemBuilder: (context, index) {
                                      final isCurrent = index == activeIndex;
                                      final isPast = index < activeIndex;
                                      
                                      double opacity = 0.5;
                                      if (isCurrent) opacity = 1.0;
                                      else if (isPast) opacity = 0.8;
                                      
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Text(
                                          _realLyrics[index].text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: isCurrent ? 24 : 18,
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
                                    },
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
                      _fetchLyrics(artist, title);
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
}"""

content = content.replace(old_widget, new_widget)

with open('lib/screens/player_screen.dart', 'w') as f:
    f.write(content)

print("Patch 4 applied successfully.")
