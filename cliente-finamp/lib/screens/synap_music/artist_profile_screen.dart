import 'package:flutter/material.dart';
import '../../services/synap_api_service.dart';
import 'album_detail_screen.dart';
import '../../models/jellyfin_models.dart';
import 'package:get_it/get_it.dart';
import '../../services/audio_service_helper.dart';


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

  @override
  void initState() {
    super.initState();
    _loadProfile();
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
            onTap: () {
              if (isAlbum) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AlbumDetailScreen(albumId: item['id']),
                ));
              } else {
                if (item['local_id'] != null) {
                  final track = BaseItemDto(
                    id: item['local_id'],
                    name: item['title'],
                    type: 'Audio',
                  );
                  final audioHandler = GetIt.instance<AudioServiceHelper>();
                  audioHandler.replaceQueueWithItem(itemList: [track]).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reproduciendo canción...')));
                  });
                } else {
                  _apiService.downloadMedia(item['query_string'] ?? '${item['title']} ${widget.artistName}').then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Descargando ${item['title']}...')));
                  });
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
        body: const Center(child: Text('Error cargando el perfil del artista.')),
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
