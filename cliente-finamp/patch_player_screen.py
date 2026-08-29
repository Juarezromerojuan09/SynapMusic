import re

with open('lib/screens/player_screen.dart', 'r') as f:
    content = f.read()

# Define the new widget
new_widget = """class _PlayerScreenAlbumImage extends ConsumerStatefulWidget {
  const _PlayerScreenAlbumImage({Key? key}) : super(key: key);

  @override
  ConsumerState<_PlayerScreenAlbumImage> createState() => _PlayerScreenAlbumImageState();
}

class _PlayerScreenAlbumImageState extends ConsumerState<_PlayerScreenAlbumImage> {
  bool _isShowingLyrics = false;

  final List<String> mockLyrics = [
    "Is this the real life?",
    "Is this just fantasy?",
    "Caught in a landslide",
    "No escape from reality",
    "Open your eyes",
    "Look up to the skies and see"
  ];

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          final item = snapshot.data?.extras?["itemJson"] == null
              ? null
              : BaseItemDto.fromJson(snapshot.data!.extras!["itemJson"]);

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
                          (audioHandler.playbackState.value.queueIndex ?? 0) +
                              1,
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
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: AlbumImage.borderRadius,
                          ),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                            itemCount: mockLyrics.length,
                            itemBuilder: (context, index) {
                              final isCurrent = index == 2; // Mocking line 3
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  mockLyrics[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isCurrent ? 24 : 18,
                                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                                    color: isCurrent ? const Color(0xFF144477) : Colors.white.withOpacity(0.7),
                                  ),
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
                    setState(() {
                      _isShowingLyrics = !_isShowingLyrics;
                    });
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

# Use regex to replace the old widget
pattern = r"class _PlayerScreenAlbumImage extends ConsumerWidget \{.*?^\}"
new_content = re.sub(pattern, new_widget, content, flags=re.DOTALL | re.MULTILINE)

with open('lib/screens/player_screen.dart', 'w') as f:
    f.write(new_content)

print("Patch applied successfully.")
