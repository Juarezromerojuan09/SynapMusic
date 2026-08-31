import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/synap_api_service.dart';
import '../../models/synap_search_result.dart';
import '../../components/track_list_item.dart';
import '../../components/track_options_menu_sheet.dart';
import 'package:get_it/get_it.dart';
import '../../services/audio_service_helper.dart';
import '../../models/jellyfin_models.dart';
import '../player_screen.dart';
import 'album_detail_screen.dart';
import '../../services/finamp_user_helper.dart';
import '../../services/jellyfin_api_helper.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final SynapApiService _apiService = SynapApiService();
  final TextEditingController _searchController = TextEditingController();
  
  Timer? _debounce;
  bool _isLoading = false;
  bool _isAlbumLoading = false;
  bool _isLoadingMoreDeezer = false;
  bool _isLoadingYoutube = false;
  bool _isDirectUrl = false;
  
  // States for search
  Map<String, dynamic>? _localJellyfinData;
  List<dynamic> _localJellyfinDataList = [];
  bool _showAllLocalMatches = false;
  List<SynapSearchResult> _deezerResults = [];
  List<SynapSearchResult> _youtubeResults = [];
  List<dynamic> _albumResults = [];
  
  int _deezerOffset = 0;

  // States for Discovery & Recommendations
  List<BaseItemDto>? _recommendations;
  List<BaseItemDto>? _discoveries;
  bool _isInitialLoading = true;
  Future<List<dynamic>>? _globalAlbumsFuture;

  final Color _synapColor = const Color(0xFF144477); 

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      _globalAlbumsFuture = _apiService.getGlobalAlbums();
      final helper = GetIt.instance<JellyfinApiHelper>();
      
      final responses = await Future.wait([
        helper.getItems(
          includeItemTypes: "Audio",
          sortBy: "DatePlayed,PlayCount",
          sortOrder: "Descending",
          limit: 5,
          isGenres: false,
        ),
        helper.getItems(
          includeItemTypes: "Audio",
          sortBy: "Random",
          limit: 5,
          isGenres: false,
        )
      ]);

      if (mounted) {
        setState(() {
          _recommendations = responses[0] ?? [];
          _discoveries = responses[1] ?? [];
          _isInitialLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recommendations = [];
          _discoveries = [];
          _isInitialLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    if (query.contains('spotify.com/') || query.contains('deezer.com/') || query.contains('youtube.com/') || query.contains('youtu.be/')) {
      setState(() {
        _isDirectUrl = true;
        _deezerResults = [];
        _youtubeResults = [];
        _albumResults = [];
        _localJellyfinData = null;
      });
      return;
    } else {
      setState(() {
        _isDirectUrl = false;
      });
    }

    if (query.isEmpty) {
      setState(() {
        _deezerResults = [];
        _youtubeResults = [];
        _albumResults = [];
        _localJellyfinData = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query, reset: true);
    });
  }

  Future<void> _performSearch(String query, {bool reset = true}) async {
    if (reset) {
      setState(() {
        _isLoading = true;
        _isAlbumLoading = true;
        _deezerOffset = 0;
        _youtubeResults.clear();
      });
    }

    try {
      final responseMapFuture = _apiService.searchExternal(query, source: 'deezer', limit: 15, offset: _deezerOffset);
      final albumResultsFuture = reset ? _apiService.searchAlbums(query) : Future.value(null);

      final responses = await Future.wait([responseMapFuture, albumResultsFuture]);
      final responseMap = responses[0] as Map<String, dynamic>?;
      final albumResults = responses[1] as List<dynamic>?;
      
      setState(() {
        if (responseMap != null) {
          if (reset) {
            final localMatch = responseMap['local_match'];
            if (localMatch != null && localMatch['exists'] == true) {
              _localJellyfinData = localMatch['jellyfin_data'];
              _localJellyfinDataList = localMatch['jellyfin_data_list'] ?? [_localJellyfinData];
              _showAllLocalMatches = false;
            } else {
              _localJellyfinData = null;
              _localJellyfinDataList = [];
              _showAllLocalMatches = false;
            }
          }
          
          final List<dynamic> remoteResults = responseMap['remote_results'] ?? [];
          final newItems = remoteResults.map((json) => SynapSearchResult.fromJson(json)).toList();
          
          if (reset) {
            _deezerResults = newItems;
          } else {
            _deezerResults.addAll(newItems);
          }
        }

        if (reset) {
          _albumResults = albumResults ?? [];
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isAlbumLoading = false;
        _isLoadingMoreDeezer = false;
      });
    }
  }

  Future<void> _loadMoreDeezer() async {
    setState(() {
      _isLoadingMoreDeezer = true;
      _deezerOffset += 15;
    });
    await _performSearch(_searchController.text, reset: false);
  }

  Future<void> _loadYoutubeResults() async {
    setState(() {
      _isLoadingYoutube = true;
    });
    
    try {
      final responseMap = await _apiService.searchExternal(_searchController.text, source: 'youtube', limit: 15);
      if (responseMap != null) {
        final List<dynamic> remoteResults = responseMap['remote_results'] ?? [];
        setState(() {
          _youtubeResults = remoteResults.map((json) => SynapSearchResult.fromJson(json)).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar en YouTube: $e')),
      );
    } finally {
      setState(() {
        _isLoadingYoutube = false;
      });
    }
  }

  Future<void> _handleDownload(String query) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Encolando tarea en el servidor...')),
    );

    bool success = false;
    final isPlaylist = query.contains('playlist');
    
    if (_isDirectUrl && isPlaylist) {
      final userHelper = GetIt.instance<FinampUserHelper>();
      final userId = userHelper.currentUser?.id;
      if (userId != null) {
        success = await _apiService.migratePlaylist(query, userId);
      } else {
        success = await _apiService.downloadMedia(query);
      }
    } else {
      success = await _apiService.downloadMedia(query);
    }
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Descarga iniciada exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fallo al solicitar la descarga.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Buscar canción, artista o pegar URL...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                ),
                const SizedBox(height: 16),
                TabBar(
                  labelColor: _synapColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: _synapColor,
                  tabs: const [
                    Tab(text: 'Canciones'),
                    Tab(text: 'Álbumes'),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildSongsTab(),
                      _buildAlbumsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongsTab() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_isDirectUrl) return _buildSpotifyUrlCard();

    final isSearching = _searchController.text.isNotEmpty;

    if (!isSearching) {
      // Estado Inicial: Recomendaciones y Descubrimiento
      if (_isInitialLoading) return const Center(child: CircularProgressIndicator());
      
      return ListView(
        children: [
          if (_recommendations != null && _recommendations!.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Recomendaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            ),
            ..._recommendations!.map((item) => _buildLocalJellyfinTrack(item)).toList(),
            const SizedBox(height: 16),
          ],
          
          if (_discoveries != null && _discoveries!.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Descubrimiento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            ),
            ..._discoveries!.map((item) => _buildLocalJellyfinTrack(item)).toList(),
            const SizedBox(height: 16),
          ],
        ],
      );
    }

    // Resultados de Búsqueda
    return ListView(
      children: [
        if (_localJellyfinDataList.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('En tu biblioteca', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ..._buildLocalFileList(),
          if (_deezerResults.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Más opciones', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
            ),
          ],
        ],

        if (_deezerResults.isNotEmpty) ...[
          ..._deezerResults.map((item) => _buildExternalResultTile(item)).toList(),
          
          // Botones Mas y Youtube
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoadingMoreDeezer ? null : _loadMoreDeezer,
                  icon: _isLoadingMoreDeezer 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.add, color: Colors.white),
                  label: const Text('Más', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: _synapColor),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoadingYoutube || _youtubeResults.isNotEmpty ? null : _loadYoutubeResults,
                  icon: _isLoadingYoutube
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.play_circle_filled, color: Colors.white),
                  label: const Text('YouTube', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
          
          if (_youtubeResults.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Resultados de YouTube', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
            ),
            ..._youtubeResults.map((item) => _buildExternalResultTile(item)).toList(),
          ]
        ] else if (_localJellyfinDataList.isEmpty) ...[
          const Center(child: Text('No se encontraron resultados')),
        ]
      ],
    );
  }

  Widget _buildAlbumsTab() {
    if (_isAlbumLoading) return const Center(child: CircularProgressIndicator());
    
    if (_searchController.text.isEmpty) {
      return FutureBuilder<List<dynamic>>(
        future: _globalAlbumsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron álbumes globales'));
          }
          final globals = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Top Álbumes Globales', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              ),
              Expanded(
                child: _buildAlbumsGrid(globals),
              ),
            ],
          );
        },
      );
    }
    
    if (_albumResults.isEmpty) {
      return const Center(child: Text('No se encontraron álbumes'));
    }

    return _buildAlbumsGrid(_albumResults);
  }

  Widget _buildAlbumsGrid(List<dynamic> albums) {

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AlbumDetailScreen(
                  albumId: album['id'],
                ),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      album['cover_url'] ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (c, e, s) => Container(color: Colors.grey[800], child: const Icon(Icons.album, size: 50)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        album['title'] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        album['artist'] ?? 'Unknown',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpotifyUrlCard() {
    return ListView(
      children: [
        Card(
          color: Theme.of(context).cardColor,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.link, size: 40, color: Colors.blueAccent),
            title: const Text('Enlace Detectado', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_searchController.text, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                _handleDownload(_searchController.text);
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildLocalFileList() {
    final listToDisplay = _showAllLocalMatches || _localJellyfinDataList.length <= 3 
        ? _localJellyfinDataList 
        : _localJellyfinDataList.take(3).toList();
        
    final widgets = listToDisplay.map((itemInfo) {
      final BaseItemDto track = BaseItemDto.fromJson(itemInfo);
      return _buildLocalJellyfinTrack(track);
    }).toList();
    
    if (!_showAllLocalMatches && _localJellyfinDataList.length > 3) {
      widgets.add(
        TextButton.icon(
          onPressed: () {
            setState(() {
              _showAllLocalMatches = true;
            });
          },
          icon: const Icon(Icons.expand_more, color: Colors.grey),
          label: Text('Ver ${_localJellyfinDataList.length - 3} resultados locales más', style: const TextStyle(color: Colors.grey)),
        ) as Widget
      );
    } else if (_showAllLocalMatches && _localJellyfinDataList.length > 3) {
      widgets.add(
        TextButton.icon(
          onPressed: () {
            setState(() {
              _showAllLocalMatches = false;
            });
          },
          icon: const Icon(Icons.expand_less, color: Colors.grey),
          label: const Text('Ocultar', style: TextStyle(color: Colors.grey)),
        ) as Widget
      );
    }
    
    return widgets;
  }

  Widget _buildLocalJellyfinTrack(BaseItemDto track) {
    final artist = (track.artists?.isNotEmpty == true) ? track.artists![0] : 'Desconocido';
    final coverUrl = 'http://100.81.156.126:8096/Items/${track.id}/Images/Primary';
    
    return TrackListItem(
      title: track.name ?? 'Canción',
      artist: artist,
      isAvailableInServer: true,
      coverUrl: coverUrl,
      onPlayPressed: () async {
        try {
          await GetIt.instance<AudioServiceHelper>().replaceQueueWithItem(
            itemList: [track],
            initialIndex: 0,
          );
          if (mounted) {
            Navigator.of(context, rootNavigator: true).pushNamed(PlayerScreen.routeName);
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
          }
        }
      },
      onMenuPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => TrackOptionsMenuSheet(itemId: track.id!),
        );
      },
    );
  }

  Widget _buildExternalResultTile(SynapSearchResult result) {
    final isYoutube = result.source == 'youtube';
    final durationText = result.duration ?? '';
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            result.coverUrl ?? '',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60, height: 60, color: Colors.grey[800],
              child: const Icon(Icons.music_note, color: Colors.white),
            ),
          ),
        ),
        title: Text(result.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                if (durationText.isNotEmpty) ...[
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(durationText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(width: 12),
                ],
                if (isYoutube) ...[
                  const Icon(Icons.play_circle_filled, size: 14, color: Colors.red),
                  const SizedBox(width: 4),
                  const Text('YouTube', style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.download, color: Colors.white),
              onPressed: () {
                final query = result.url.isNotEmpty ? result.url : (result.queryString ?? (isYoutube ? result.title : '${result.artist} ${result.title}'));
                _handleDownload(query);
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showExternalOptionsMenu(result);
              },
            ),
          ],
        ),
        onTap: () {
          final query = result.url.isNotEmpty ? result.url : (result.queryString ?? (isYoutube ? result.title : '${result.artist} ${result.title}'));
          _handleDownload(query);
        },
      ),
    );
  }

  void _showExternalOptionsMenu(SynapSearchResult result) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Descargar a Biblioteca'),
                onTap: () {
                  Navigator.pop(context);
                  final query = result.url.isNotEmpty ? result.url : (result.queryString ?? (result.source == 'youtube' ? result.title : '${result.artist} ${result.title}'));
                  _handleDownload(query);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text('Fuente: ${result.source?.toUpperCase() ?? "Desconocida"}'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
