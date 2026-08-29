import re

with open('lib/screens/player_screen.dart', 'r') as f:
    content = f.read()

new_widget = """class _PlayerScreenAlbumImage extends ConsumerStatefulWidget {
  const _PlayerScreenAlbumImage({Key? key}) : super(key: key);

  @override
  ConsumerState<_PlayerScreenAlbumImage> createState() => _PlayerScreenAlbumImageState();
}

class _PlayerScreenAlbumImageState extends ConsumerState<_PlayerScreenAlbumImage> {
  bool _isShowingLyrics = false;
  bool _isLoadingLyrics = false;
  List<String> _realLyrics = [];
  String? _currentItemId;

  Future<void> _fetchLyrics(String artist, String title) async {
    setState(() {
      _isLoadingLyrics = true;
      _realLyrics = [];
    });
    
    try {
      final synapApi = SynapApiService();
      final lrcContent = await synapApi.getLyrics(artist, title);
      
      if (lrcContent != null && lrcContent.isNotEmpty) {
        // Parse simple LRC
        final lines = lrcContent.split('\\n');
        final RegExp tagRegExp = RegExp(r'\\[\\d+:\\d+\\.\\d+\\]');
        final parsed = lines.map((line) {
          return line.replaceAll(tagRegExp, '').trim();
        }).where((line) => line.isNotEmpty).toList();
        
        setState(() {
          _realLyrics = parsed;
        });
      } else {
        setState(() {
          _realLyrics = ["(Letras no encontradas en el servidor)"];
        });
      }
    } catch (e) {
      setState(() {
        _realLyrics = ["(Error cargando letras)"];
      });
    } finally {
      setState(() {
        _isLoadingLyrics = false;
      });
    }
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
            // Si la vista de letras estaba abierta, cargar la nueva
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
                            color: Colors.black.withOpacity(0.2), // Mucho más tenue como pidio el usuario
                            borderRadius: AlbumImage.borderRadius,
                          ),
                          child: _isLoadingLyrics 
                            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF144477))))
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                                itemCount: _realLyrics.length,
                                itemBuilder: (context, index) {
                                  // Sin sincronización de tiempos real aún, todas se ven igual
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      _realLyrics[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: 3.0,
                                            color: Colors.black.withOpacity(0.8),
                                          ),
                                        ]
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

pattern = r"class _PlayerScreenAlbumImage extends ConsumerStatefulWidget \{.*?^\}"
new_content = re.sub(pattern, new_widget, content, flags=re.DOTALL | re.MULTILINE)

# Also need to import SynapApiService at the top
if "synap_api_service.dart" not in new_content:
    new_content = new_content.replace(
        "import '../models/jellyfin_models.dart';",
        "import '../models/jellyfin_models.dart';\nimport '../services/synap_api_service.dart';"
    )

with open('lib/screens/player_screen.dart', 'w') as f:
    f.write(new_content)

print("Patch 2 applied successfully.")
