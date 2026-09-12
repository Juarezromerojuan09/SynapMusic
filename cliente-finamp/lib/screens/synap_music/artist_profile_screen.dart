import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/synap_api_service.dart';
import 'album_detail_screen.dart';
import '../../models/jellyfin_models.dart';
import 'package:get_it/get_it.dart';
import '../../services/audio_service_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/playback_download_coordinator.dart';


class ArtistProfileScreen extends StatefulWidget {
  final String artistName;

  const ArtistProfileScreen({Key? key, required this.artistName}) : super(key: key);

  @override
  _ArtistProfileScreenState createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen> {
  final SynapApiService _apiService = SynapApiService();
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  StreamSubscription<LocalTrackReadyEvent>? _trackReadySubscription;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _trackReadySubscription = PlaybackDownloadCoordinator().onTrackReady.listen((event) {
      if (mounted && _profileData != null && _profileData!['top_tracks'] != null) {
        bool updated = false;
        final topTracks = _profileData!['top_tracks'] as List<dynamic>;
        for (var t in topTracks) {
          final title = t['title']?.toString().toLowerCase().trim() ?? '';
          final eventTitle = event.title.toLowerCase().trim();
          if (title == eventTitle || title.contains(eventTitle) || eventTitle.contains(title)) {
            t['local_id'] = event.localId;
            t['jellyfin_item'] = event.jellyfinItem;
            updated = true;
          }
        }
        if (updated) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _trackReadySubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final data = await _apiService.getArtistProfile(widget.artistName);
    if (mounted) {
      setState(() {
        _profileData = data;
        _isLoading = false;
      });
    }
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onMore}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          if (onMore != null)
            TextButton(
              onPressed: onMore,
              child: const Text('Más', style: TextStyle(color: Colors.blue)),
            ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<dynamic> items, {bool isAlbum = false}) {
    if (items.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () async {
              if (isAlbum) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AlbumDetailScreen(albumId: item['id']),
                ));
              } else {
                if (item['local_id'] != null) {
                  BaseItemDto? track;
                  if (item['jellyfin_item'] != null) {
                    try {
                      final dto = BaseItemDto.fromJson(Map<String, dynamic>.from(item['jellyfin_item']));
                      if (dto.artists != null && dto.artists!.isNotEmpty) {
                        track = dto;
                      }
                    } catch (e) {
                      print('Error parseando jellyfin_item: $e');
                    }
                  }

                  if (track == null) {
                    try {
                      final jellyfinHelper = GetIt.instance<JellyfinApiHelper>();
                      track = await jellyfinHelper.getItemById(item['local_id']);
                    } catch (e) {
                      print('Error obteniendo item por ID: $e');
                      track = BaseItemDto(
                        id: item['local_id'],
                        name: item['title'],
                        type: 'Audio',
                        artists: [widget.artistName],
                        albumArtist: widget.artistName,
                      );
                    }
                  }

                  final audioHandler = GetIt.instance<AudioServiceHelper>();
                  await audioHandler.replaceQueueWithItem(itemList: [track]);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reproduciendo canción...')));
                  }
                } else {
                  PlaybackDownloadCoordinator().downloadAndAutoPlay(
                    context: context,
                    title: item['title'] ?? '',
                    artist: widget.artistName,
                    queryString: item['query_string'] ?? '${item['title']} ${widget.artistName}',
                    coverUrl: item['cover_url'],
                  );
                }
              }
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['cover_url'] ?? '',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 120, height: 120, color: Colors.grey[800],
                        child: const Icon(Icons.music_note, color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item['release_date'] != null)
                    Text(
                      item['release_date'].toString().split('-')[0],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.artistName)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_profileData == null || _profileData!.containsKey('error')) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.artistName)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_off_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  _profileData?['error'] ?? 'No se pudo cargar la información del artista.',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _loadProfile();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final artist = _profileData!['artist'];
    final topTracks = _profileData!['top_tracks'] as List<dynamic>? ?? [];
    final albums = _profileData!['albums'] as List<dynamic>? ?? [];
    final singles = _profileData!['singles'] as List<dynamic>? ?? [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(artist['name'] ?? ''),
              background: artist['picture_url'] != null
                  ? Image.network(artist['picture_url'], fit: BoxFit.cover)
                  : Container(color: Colors.grey[800]),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              if (topTracks.isNotEmpty) ...[
                _buildSectionTitle('Canciones Populares'),
                _buildHorizontalList(topTracks),
              ],
              if (albums.isNotEmpty) ...[
                _buildSectionTitle('Álbumes', onMore: () {
                  // TODO: redirect to album search
                  Navigator.of(context).pop();
                }),
                _buildHorizontalList(albums, isAlbum: true),
              ],
              if (singles.isNotEmpty) ...[
                _buildSectionTitle('Sencillos / EPs'),
                _buildHorizontalList(singles, isAlbum: true),
              ],
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }
}
