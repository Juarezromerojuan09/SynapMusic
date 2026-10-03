import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/synap_api_service.dart';
import 'album_detail_screen.dart';
import 'artist_top_tracks_screen.dart';
import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/playback_download_coordinator.dart';
import '../../components/track_options_menu_sheet.dart';
import '../../services/likes_playlist_helper.dart';
import '../../services/synap_favorites_helper.dart';

class ArtistProfileScreen extends StatefulWidget {
  final String artistName;
  final String? artistId;

  const ArtistProfileScreen({
    Key? key,
    required this.artistName,
    this.artistId,
  }) : super(key: key);

  @override
  _ArtistProfileScreenState createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen> {
  final SynapApiService _apiService = SynapApiService();
  final Color _synapColor = const Color(0xFF8B93FF);

  bool _isLoading = true;
  bool _isFavorite = false;
  Map<String, dynamic>? _profileData;
  StreamSubscription<LocalTrackReadyEvent>? _trackReadySubscription;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _checkIfFavorite();

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

  void _checkIfFavorite() {
    if (mounted) {
      setState(() {
        _isFavorite = SynapFavoritesHelper.isArtistFavorite(widget.artistName);
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final artistInfo = _profileData?['artist'] ?? {};
    final artistName = artistInfo['name'] ?? widget.artistName;
    final pictureUrl = artistInfo['picture_url'] ?? '';
    final artistId = artistInfo['id']?.toString() ?? widget.artistId ?? '';

    await SynapFavoritesHelper.toggleArtistFavorite(context, {
      'id': artistId,
      'name': artistName,
      'picture_url': pictureUrl,
      'picture_medium': pictureUrl,
      'fans': artistInfo['nb_fan'],
      'added_at': DateTime.now().toIso8601String(),
    });

    _checkIfFavorite();
  }

  Future<void> _loadProfile() async {
    final data = await _apiService.getArtistProfile(widget.artistName, artistId: widget.artistId);
    if (mounted) {
      setState(() {
        _profileData = data;
        _isLoading = false;
      });
      _checkLocalLibrary();
    }
  }

  Future<void> _checkLocalLibrary() async {
    if (_profileData == null || _profileData!['top_tracks'] == null) return;
    final topTracks = _profileData!['top_tracks'] as List<dynamic>;
    bool anyUpdated = false;

    for (var track in topTracks) {
      if (track['local_id'] == null) {
        final title = track['title'] ?? '';
        final local = await _apiService.checkLocalTrack(title, widget.artistName);
        if (local != null && local['exists'] == true) {
          track['local_id'] = local['local_id'];
          track['jellyfin_item'] = local['jellyfin_item'];
          anyUpdated = true;
        }
      }
    }

    if (anyUpdated && mounted) {
      setState(() {});
    }
  }

  String _formatFans(dynamic fans) {
    if (fans == null) return '';
    final int count = int.tryParse(fans.toString()) ?? 0;
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)} M oyentes';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)} K oyentes';
    }
    return '$count oyentes';
  }

  String _formatReleaseDate(dynamic date) {
    if (date == null) return '';
    final parts = date.toString().split('-');
    return parts.isNotEmpty ? parts[0] : '';
  }

  Future<void> _shareArtist() async {
    final artist = _profileData?['artist'];
    final name = artist?['name'] ?? widget.artistName;
    final id = artist?['id'];
    final url = id != null ? 'https://www.deezer.com/artist/$id' : '';
    await Share.share('¡Escucha a $name en SynapMusic! $url');
  }

  Future<void> _playShuffleTopTracks() async {
    final topTracks = _profileData?['top_tracks'] as List<dynamic>? ?? [];
    if (topTracks.isEmpty) return;

    List<BaseItemDto> localTracks = [];
    for (var t in topTracks) {
      if (t['local_id'] != null) {
        BaseItemDto? dto;
        if (t['jellyfin_item'] != null) {
          try {
            dto = BaseItemDto.fromJson(Map<String, dynamic>.from(t['jellyfin_item']));
          } catch (_) {}
        }
        if (dto != null) {
          localTracks.add(dto);
        } else {
          localTracks.add(BaseItemDto(
            id: t['local_id'],
            name: t['title'],
            type: 'Audio',
            artists: [widget.artistName],
            albumArtist: widget.artistName,
          ));
        }
      }
    }

    if (localTracks.isNotEmpty) {
      final audioHandler = GetIt.instance<AudioServiceHelper>();
      await audioHandler.replaceQueueWithItem(itemList: localTracks, shuffle: true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reproduciendo en aleatorio...')),
        );
      }
    } else {
      // Descarga y reproduce el primero
      _playTrack(topTracks.first);
    }
  }

  Future<void> _playTrack(dynamic item) async {
    if (item['local_id'] != null) {
      BaseItemDto? track;
      if (item['jellyfin_item'] != null) {
        try {
          track = BaseItemDto.fromJson(Map<String, dynamic>.from(item['jellyfin_item']));
        } catch (_) {}
      }

      if (track == null) {
        try {
          final jellyfinHelper = GetIt.instance<JellyfinApiHelper>();
          track = await jellyfinHelper.getItemById(item['local_id']);
        } catch (_) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reproduciendo canción...')),
        );
      }
    } else {
      final query = item['query_string'] ?? '${item['title']} ${widget.artistName}';
      final trackKey = PlaybackDownloadCoordinator.buildKey(
        title: item['title'] ?? '',
        artist: widget.artistName,
        queryString: query,
      );
      if (PlaybackDownloadCoordinator().isDownloading(trackKey)) {
        return;
      }
      PlaybackDownloadCoordinator().downloadAndAutoPlay(
        context: context,
        title: item['title'] ?? '',
        artist: widget.artistName,
        queryString: query,
        coverUrl: item['cover_url'] ?? (item['album'] != null ? item['album']['cover_medium'] : null),
      );
    }
  }

  Widget _buildTopTrackRow(int index, dynamic track) {
    final title = track['title'] ?? 'Canción desconocida';
    final albumTitle = track['album'] != null ? track['album']['title'] ?? '' : '';
    final coverUrl = track['cover_url'] ?? (track['album'] != null ? track['album']['cover_medium'] : null);
    final isLocal = track['local_id'] != null;
    final trackId = track['local_id']?.toString();
    final queryString = track['query_string'] ?? '$title ${widget.artistName}';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: coverUrl != null
                ? Image.network(
                    coverUrl,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 44,
                      height: 44,
                      color: const Color(0xFF1E1E1E),
                      child: const Icon(Icons.music_note, color: Colors.white54, size: 20),
                    ),
                  )
                : Container(
                    width: 44,
                    height: 44,
                    color: const Color(0xFF1E1E1E),
                    child: const Icon(Icons.music_note, color: Colors.white54, size: 20),
                  ),
          ),
        ],
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        albumTitle.isNotEmpty ? albumTitle : widget.artistName,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<Set<String>>(
            valueListenable: LikesPlaylistHelper.likedSongKeys,
            builder: (context, likedKeys, _) {
              return ValueListenableBuilder<Set<String>>(
                valueListenable: LikesPlaylistHelper.likedSongIds,
                builder: (context, likedIds, _) {
                  final isLiked = LikesPlaylistHelper.isSongLiked(
                    trackId: trackId,
                    title: title,
                    artist: widget.artistName,
                  );

                  return IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? _synapColor : const Color(0xFFA0A0A0),
                      size: 22,
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                    tooltip: isLiked ? 'Eliminar de canciones que me gustan' : 'Me gusta',
                    onPressed: () {
                      LikesPlaylistHelper.toggleLike(
                        trackId: isLocal ? trackId : null,
                        title: title,
                        artist: widget.artistName,
                        queryString: queryString,
                        coverUrl: coverUrl,
                        context: context,
                      );
                    },
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFFA0A0A0)),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => TrackOptionsMenuSheet(
                  itemId: isLocal ? trackId : null,
                  title: title,
                  artist: widget.artistName,
                  queryString: queryString,
                  coverUrl: coverUrl,
                  currentArtist: widget.artistName,
                  showArtistProfile: false,
                ),
              );
            },
          ),
        ],
      ),
      onTap: () => _playTrack(track),
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onMore}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (onMore != null)
            TextButton(
              onPressed: onMore,
              child: Text('Más', style: TextStyle(color: _synapColor, fontWeight: FontWeight.bold)),
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
                _playTrack(item);
              }
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item['cover_url'] ?? '',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey[850],
                        child: const Icon(Icons.album, color: Colors.white, size: 40),
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
                      _formatReleaseDate(item['release_date']),
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

  void _openDiscographyView(String title, List<dynamic> items) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0A0A0A),
            title: Text('$title - ${widget.artistName}'),
          ),
          body: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AlbumDetailScreen(albumId: item['id']),
                  ));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item['cover_url'] ?? '',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[850],
                            child: const Center(
                              child: Icon(Icons.album, color: Colors.white, size: 48),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item['release_date'] != null)
                      Text(
                        _formatReleaseDate(item['release_date']),
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(backgroundColor: const Color(0xFF0A0A0A), title: Text(widget.artistName)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_profileData == null || _profileData!.containsKey('error')) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(backgroundColor: const Color(0xFF0A0A0A), title: Text(widget.artistName)),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _synapColor,
                    foregroundColor: Colors.black,
                  ),
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

    final artist = _profileData!['artist'] ?? {};
    final topTracks = _profileData!['top_tracks'] as List<dynamic>? ?? [];
    final albums = _profileData!['albums'] as List<dynamic>? ?? [];
    final singles = _profileData!['singles'] as List<dynamic>? ?? [];
    final fansCount = _formatFans(artist['nb_fan']);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF0A0A0A),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                artist['name'] ?? widget.artistName,
                style: const TextStyle(fontWeight: FontWeight.bold, shadows: [
                  Shadow(color: Colors.black, blurRadius: 10),
                ]),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  artist['picture_url'] != null
                      ? Image.network(artist['picture_url'], fit: BoxFit.cover)
                      : Container(color: Colors.grey[900]),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Color(0xFF0A0A0A)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (fansCount.isNotEmpty)
                    Text(
                      fansCount,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Botón Play
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _synapColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.play_arrow, size: 30, color: Colors.black),
                          onPressed: topTracks.isNotEmpty ? () => _playTrack(topTracks.first) : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Botón Aleatorio
                      IconButton(
                        icon: const Icon(Icons.shuffle, size: 26, color: Colors.white),
                        tooltip: 'Reproducción aleatoria',
                        onPressed: _playShuffleTopTracks,
                      ),
                      const SizedBox(width: 16),
                      // Botón Favorito
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 26,
                          color: _isFavorite ? Colors.redAccent : Colors.white,
                        ),
                        tooltip: _isFavorite ? 'Remover de favoritos' : 'Añadir a favoritos',
                        onPressed: _toggleFavorite,
                      ),
                      const SizedBox(width: 16),
                      // Botón Compartir
                      IconButton(
                        icon: const Icon(Icons.share, size: 24, color: Colors.white),
                        tooltip: 'Compartir artista',
                        onPressed: _shareArtist,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              if (topTracks.isNotEmpty) ...[
                _buildSectionTitle(
                  'Canciones Populares',
                  onMore: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ArtistTopTracksScreen(
                          artistName: widget.artistName,
                          artistId: widget.artistId ?? _profileData?['artist']?['id']?.toString(),
                          initialTracks: topTracks,
                        ),
                      ),
                    );
                  },
                ),
                ...topTracks.take(5).toList().asMap().entries.map(
                  (entry) => _buildTopTrackRow(entry.key, entry.value),
                ),
              ],
              if (albums.isNotEmpty) ...[
                _buildSectionTitle(
                  'Álbumes (${albums.length})',
                  onMore: albums.length > 3 ? () => _openDiscographyView('Álbumes', albums) : null,
                ),
                _buildHorizontalList(albums, isAlbum: true),
              ],
              if (singles.isNotEmpty) ...[
                _buildSectionTitle(
                  'Sencillos / EPs (${singles.length})',
                  onMore: singles.length > 3 ? () => _openDiscographyView('Sencillos / EPs', singles) : null,
                ),
                _buildHorizontalList(singles, isAlbum: true),
              ],
              const SizedBox(height: 48),
            ]),
          ),
        ],
      ),
    );
  }
}
