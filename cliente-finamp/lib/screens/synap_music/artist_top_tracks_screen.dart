import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/playback_download_coordinator.dart';
import '../../services/synap_api_service.dart';
import '../../components/track_options_menu_sheet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArtistTopTracksScreen extends StatefulWidget {
  final String artistName;
  final List<dynamic>? initialTracks;

  const ArtistTopTracksScreen({
    Key? key,
    required this.artistName,
    this.initialTracks,
  }) : super(key: key);

  @override
  _ArtistTopTracksScreenState createState() => _ArtistTopTracksScreenState();
}

class _ArtistTopTracksScreenState extends State<ArtistTopTracksScreen> {
  final Color _synapColor = const Color(0xFF8B93FF);
  final SynapApiService _apiService = SynapApiService();
  final ScrollController _scrollController = ScrollController();

  List<dynamic> _tracks = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _nextIndex = 0;
  String? _dzArtistId;

  @override
  void initState() {
    super.initState();
    if (widget.initialTracks != null && widget.initialTracks!.isNotEmpty) {
      _tracks = List<dynamic>.from(widget.initialTracks!);
      _nextIndex = _tracks.length;
    }
    _scrollController.addListener(_onScroll);
    if (_tracks.isEmpty) {
      _loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_dzArtistId == null) {
        final profile = await _apiService.getArtistProfile(widget.artistName);
        if (profile != null && profile['artist'] != null) {
          _dzArtistId = profile['artist']['id']?.toString();
        }
      }

      if (_dzArtistId != null) {
        final uri = Uri.parse('https://api.deezer.com/artist/$_dzArtistId/top?limit=25&index=$_nextIndex');
        final res = await http.get(uri);
        if (res.statusCode == 200) {
          final data = json.decode(res.body);
          final List<dynamic> newTracks = data['data'] ?? [];

          for (var t in newTracks) {
            final title = t['title'] ?? '';
            final check = await _apiService.checkLocalTrack(title, widget.artistName);
            if (check != null && check['exists'] == true) {
              t['local_id'] = check['local_id'];
              t['jellyfin_item'] = check['jellyfin_item'];
            }
          }

          if (mounted) {
            setState(() {
              _tracks.addAll(newTracks);
              _nextIndex += newTracks.length;
              if (newTracks.length < 25) {
                _hasMore = false;
              }
            });
          }
        } else {
          setState(() {
            _hasMore = false;
          });
        }
      } else {
        setState(() {
          _hasMore = false;
        });
      }
    } catch (e) {
      print('Error en ArtistTopTracksScreen._loadMore: $e');
      setState(() {
        _hasMore = false;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _playTrack(int index) async {
    final item = _tracks[index];
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
      PlaybackDownloadCoordinator().downloadAndAutoPlay(
        context: context,
        title: item['title'] ?? '',
        artist: widget.artistName,
        queryString: item['query_string'] ?? '${item['title']} ${widget.artistName}',
        coverUrl: item['cover_url'] ?? (item['album'] != null ? item['album']['cover_medium'] : null),
      );
    }
  }

  Widget _buildTrackTile(int index, dynamic track) {
    final title = track['title'] ?? 'Canción desconocida';
    final albumTitle = track['album'] != null ? track['album']['title'] ?? '' : '';
    final coverUrl = track['cover_url'] ?? (track['album'] != null ? track['album']['cover_medium'] : null);
    final isLocal = track['local_id'] != null;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: coverUrl != null
                ? Image.network(
                    coverUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: const Color(0xFF1E1E1E),
                      child: const Icon(Icons.music_note, color: Colors.white54, size: 24),
                    ),
                  )
                : Container(
                    width: 48,
                    height: 48,
                    color: const Color(0xFF1E1E1E),
                    child: const Icon(Icons.music_note, color: Colors.white54, size: 24),
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
          if (isLocal)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.check_circle, color: Color(0xFF8B93FF), size: 18),
            ),
          IconButton(
            icon: const Icon(Icons.play_circle_outline, color: Colors.white),
            onPressed: () => _playTrack(index),
          ),
        ],
      ),
      onTap: () => _playTrack(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Canciones populares', style: TextStyle(fontSize: 18)),
            Text(widget.artistName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      body: _tracks.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _tracks.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _tracks.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _buildTrackTile(index, _tracks[index]);
              },
            ),
    );
  }
}
