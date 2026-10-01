import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'create_playlist_dialog.dart';
import '../services/jellyfin_api_helper.dart';
import '../services/likes_playlist_helper.dart';
import '../services/synap_events.dart';
import '../services/playback_download_coordinator.dart';
import '../models/jellyfin_models.dart';

class PlaylistStatus {
  final BaseItemDto playlist;
  bool containsItem;
  String? entryId; // El ID de la canción DENTRO de la playlist

  PlaylistStatus(this.playlist, this.containsItem, this.entryId);
}

class AddToPlaylistSheet extends StatefulWidget {
  final String? itemId;
  final String? title;
  final String? artist;
  final String? queryString;
  final String? coverUrl;
  final BaseItemDto? track;

  const AddToPlaylistSheet({
    Key? key,
    this.itemId,
    this.title,
    this.artist,
    this.queryString,
    this.coverUrl,
    this.track,
  }) : super(key: key);

  /// Método estático para precargar o actualizar la caché de playlists desde cualquier parte de la app
  static void updateCachedPlaylists(List<BaseItemDto> playlists) {
    _AddToPlaylistSheetState.updateCache(playlists);
  }

  @override
  _AddToPlaylistSheetState createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends State<AddToPlaylistSheet> {
  final Color _synapColor = const Color(0xFF8B93FF);

  // Caché estático en memoria para apertura instantánea (0ms)
  static List<BaseItemDto>? _cachedPlaylists;
  static void updateCache(List<BaseItemDto> playlists) {
    _cachedPlaylists = List<BaseItemDto>.from(playlists);
  }

  List<PlaylistStatus>? _statuses;
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<void>? _refreshSub;

  String? get targetItemId => widget.itemId ?? widget.track?.id;
  String? get targetTitle => widget.title ?? widget.track?.name;
  String? get targetArtist =>
      widget.artist ??
      ((widget.track?.artists != null && widget.track!.artists!.isNotEmpty)
          ? widget.track!.artists!.first
          : null);

  @override
  void initState() {
    super.initState();

    _refreshSub = SynapEvents.onLibraryRefresh.listen((_) {
      _cachedPlaylists = null;
    });

    _initializePlaylists();
  }

  @override
  void dispose() {
    _refreshSub?.cancel();
    super.dispose();
  }

  void _initializePlaylists() {
    // Si ya tenemos playlists en caché en memoria, mostrarlas DE INMEDIATO (0ms)
    if (_cachedPlaylists != null && _cachedPlaylists!.isNotEmpty) {
      _buildStatusesFromPlaylists(_cachedPlaylists!);
      _isLoading = false;
      // Actualizar en segundo plano sin bloquear la UI
      _fetchPlaylistsNetwork(showLoading: false);
    } else {
      _isLoading = true;
      _fetchPlaylistsNetwork(showLoading: true);
    }
  }

  void _buildStatusesFromPlaylists(List<BaseItemDto> playlists) {
    final isLiked = LikesPlaylistHelper.isSongLiked(
      trackId: targetItemId,
      title: targetTitle,
      artist: targetArtist,
    );

    final list = playlists.map((pl) {
      final isLikes = LikesPlaylistHelper.isLikesPlaylist(pl);
      return PlaylistStatus(pl, isLikes ? isLiked : false, null);
    }).toList();

    _sortAndDeduplicate(list);

    if (mounted) {
      setState(() {
        _statuses = list;
      });
    }

    // Comprobar pertenencia para las demás playlists en paralelo y en segundo plano
    if (targetItemId != null) {
      _checkContainsInBackground(list);
    }
  }

  Future<void> _checkContainsInBackground(List<PlaylistStatus> currentList) async {
    final jellyfin = GetIt.instance<JellyfinApiHelper>();
    final targetId = targetItemId;
    if (targetId == null) return;

    // Solo comprobar las que NO son "My likes" (porque My likes ya se resolvió en memoria en 0ms)
    final checkList = currentList.where((s) => !LikesPlaylistHelper.isLikesPlaylist(s.playlist)).toList();
    if (checkList.isEmpty) return;

    // Ejecutar todas las comprobaciones en paralelo simultáneo
    await Future.wait(checkList.map((status) async {
      try {
        final items = await jellyfin.getItems(parentItem: status.playlist, isGenres: false) ?? [];
        for (final item in items) {
          if (item.id == targetId) {
            status.containsItem = true;
            status.entryId = item.playlistItemId;
            break;
          }
        }
      } catch (_) {}
    }));

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetchPlaylistsNetwork({required bool showLoading}) async {
    try {
      final jellyfin = GetIt.instance<JellyfinApiHelper>();
      final playlists = await jellyfin.getItems(includeItemTypes: "Playlist", isGenres: false) ?? [];

      if (!mounted) return;

      // Asegurar que My likes esté presente; si no está, crearla en background
      final hasLikes = playlists.any((p) => LikesPlaylistHelper.isLikesPlaylist(p));
      if (!hasLikes) {
        LikesPlaylistHelper.getOrCreateLikesPlaylist().then((created) {
          if (created != null && mounted) {
            _cachedPlaylists = null;
            _fetchPlaylistsNetwork(showLoading: false);
          }
        });
      }

      _cachedPlaylists = List<BaseItemDto>.from(playlists);

      _buildStatusesFromPlaylists(playlists);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted && (_statuses == null || _statuses!.isEmpty)) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _sortAndDeduplicate(List<PlaylistStatus> statuses) {
    // Deduplicar si Jellyfin tuviera duplicados de "My likes"
    final likesStatuses = statuses.where((s) => LikesPlaylistHelper.isLikesPlaylist(s.playlist)).toList();
    if (likesStatuses.length > 1) {
      likesStatuses.sort((a, b) => (b.playlist.childCount ?? 0).compareTo(a.playlist.childCount ?? 0));
      final duplicates = likesStatuses.sublist(1);
      for (final dup in duplicates) {
        statuses.removeWhere((s) => s.playlist.id == dup.playlist.id);
      }
    }

    // Ordenar para que "My likes" siempre aparezca de primero
    statuses.sort((a, b) {
      final aIs = LikesPlaylistHelper.isLikesPlaylist(a.playlist);
      final bIs = LikesPlaylistHelper.isLikesPlaylist(b.playlist);
      if (aIs && !bIs) return -1;
      if (!aIs && bIs) return 1;
      return (a.playlist.name ?? '').toLowerCase().compareTo((b.playlist.name ?? '').toLowerCase());
    });
  }

  Future<void> _togglePlaylist(PlaylistStatus status) async {
    final playlistName = status.playlist.name ?? 'Playlist';
    final isLikes = LikesPlaylistHelper.isLikesPlaylist(status.playlist);

    // Flujo para canciones remotas (aún no en el servidor):
    if (targetItemId == null) {
      Navigator.pop(context);
      if (isLikes) {
        await LikesPlaylistHelper.toggleLike(
          trackId: null,
          title: targetTitle ?? '',
          artist: targetArtist ?? '',
          queryString: widget.queryString,
          coverUrl: widget.coverUrl,
          context: context,
        );
      } else {
        await PlaybackDownloadCoordinator().downloadAndAddToPlaylist(
          playlistId: status.playlist.id,
          playlistName: playlistName,
          title: targetTitle ?? '',
          artist: targetArtist ?? '',
          queryString: widget.queryString,
          coverUrl: widget.coverUrl,
          context: context,
        );
      }
      return;
    }

    final jellyfin = GetIt.instance<JellyfinApiHelper>();
    final wasContained = status.containsItem;

    // Actualización optimista inmediata en la UI (0 ms)
    setState(() {
      status.containsItem = !wasContained;
    });

    try {
      if (wasContained) {
        // Remover de la playlist
        if (status.entryId != null) {
          await jellyfin.removeItemsFromPlaylist(
            playlistId: status.playlist.id,
            entryIds: [status.entryId!],
          );
          status.entryId = null;
        } else {
          final items = await jellyfin.getItems(parentItem: status.playlist, isGenres: false) ?? [];
          BaseItemDto? match;
          for (final i in items) {
            if (i.id == targetItemId) {
              match = i;
              break;
            }
          }
          if (match?.playlistItemId != null) {
            await jellyfin.removeItemsFromPlaylist(
              playlistId: status.playlist.id,
              entryIds: [match!.playlistItemId!],
            );
          }
        }
        if (isLikes) {
          try {
            await jellyfin.removeFavourite(targetItemId!);
          } catch (_) {}
          LikesPlaylistHelper.likedSongIds.value = Set<String>.from(LikesPlaylistHelper.likedSongIds.value)..remove(targetItemId);
        }
        SynapEvents.fireLibraryRefresh();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Removido de $playlistName'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Agregar a la playlist
        await jellyfin.addItemstoPlaylist(
          playlistId: status.playlist.id,
          ids: [targetItemId!],
        );
        if (isLikes) {
          try {
            await jellyfin.addFavourite(targetItemId!);
          } catch (_) {}
          LikesPlaylistHelper.likedSongIds.value = Set<String>.from(LikesPlaylistHelper.likedSongIds.value)..add(targetItemId!);
        }
        SynapEvents.fireLibraryRefresh();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Agregado a $playlistName'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          status.containsItem = wasContained;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A), // Tema oscuro consistente
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle gris en la parte superior
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              'Agregar a playlist',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const Divider(color: Colors.white24),

          // Opción Crear Nueva Playlist
          ListTile(
            leading: Icon(Icons.add_circle_outline, color: _synapColor),
            title: Text(
              'Crear playlist',
              style: TextStyle(fontWeight: FontWeight.w600, color: _synapColor),
            ),
            onTap: () async {
              Navigator.pop(context);
              await showDialog(
                context: context,
                builder: (context) => const CreatePlaylistDialog(),
              );
            },
          ),

          const Divider(color: Colors.white24),

          // Lista de playlists con Toggle
          Flexible(
            child: _buildPlaylistsBody(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPlaylistsBody() {
    if (_isLoading && (_statuses == null || _statuses!.isEmpty)) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_synapColor),
        ),
      );
    } else if (_errorMessage != null && (_statuses == null || _statuses!.isEmpty)) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text('Error: $_errorMessage', style: const TextStyle(color: Colors.red)),
      );
    } else if (_statuses == null || _statuses!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('No tienes playlists.', style: TextStyle(color: Colors.grey)),
      );
    }

    final statuses = _statuses!;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: statuses.length,
      itemBuilder: (context, index) {
        final status = statuses[index];
        final playlist = status.playlist;
        final isLikes = LikesPlaylistHelper.isLikesPlaylist(playlist);

        return ListTile(
          leading: Icon(
            isLikes
                ? (status.containsItem ? Icons.favorite : Icons.favorite_border)
                : (status.containsItem ? Icons.check_circle : Icons.queue_music),
            color: status.containsItem
                ? (isLikes ? const Color(0xFF8B93FF) : _synapColor)
                : Colors.grey[400],
          ),
          title: Text(
            playlist.name ?? 'Sin nombre',
            style: TextStyle(
              color: status.containsItem ? _synapColor : Colors.white,
              fontWeight: status.containsItem ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: isLikes
              ? const Text(
                  'Tus canciones favoritas',
                  style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                )
              : null,
          onTap: () => _togglePlaylist(status),
        );
      },
    );
  }
}
