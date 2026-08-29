with open('lib/screens/player_screen.dart', 'r') as f:
    content = f.read()

import re

# We need to replace the _PlayerScreenAlbumImageState
pattern = r"class _PlayerScreenAlbumImageState extends ConsumerState<_PlayerScreenAlbumImage> \{.*?^\}"
match = re.search(pattern, content, flags=re.DOTALL | re.MULTILINE)
if not match:
    print("Not found")
    exit(1)
old_state = match.group(0)

new_state = """class _PlayerScreenAlbumImageState extends ConsumerState<_PlayerScreenAlbumImage> {
  bool _isShowingLyrics = false;
  bool _isLoadingLyrics = false;
  List<LyricLine> _realLyrics = [];
  List<GlobalKey> _lyricKeys = [];
  String? _currentItemId;
  final ScrollController _scrollController = ScrollController();
  int _lastActiveIndex = -1;

  Future<void> _fetchLyrics(String artist, String title) async {
    setState(() {
      _isLoadingLyrics = true;
      _realLyrics = [];
      _lyricKeys = [];
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

content = content.replace(old_state, new_state)

with open('lib/screens/player_screen.dart', 'w') as f:
    f.write(content)

print("Patch applied for accurate lyric scrolling.")
