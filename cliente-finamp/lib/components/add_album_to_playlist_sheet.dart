import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/jellyfin_models.dart';
import '../services/jellyfin_api_helper.dart';
import '../services/likes_playlist_helper.dart';
import '../services/synap_events.dart';
import '../services/synap_api_service.dart';
import '../services/finamp_user_helper.dart';
import '../services/playback_download_coordinator.dart';
import 'album_image.dart';

class AlbumTrackInfo {
  final String? id; // Jellyfin item ID si existe
  final String title;
  final String artist;
  final String? queryString;
  final String? coverUrl;

  AlbumTrackInfo({
    this.id,
    required this.title,
    required this.artist,
    this.queryString,
    this.coverUrl,
  });

  factory AlbumTrackInfo.fromBaseItemDto(BaseItemDto dto) {
    final artist = (dto.artists != null && dto.artists!.isNotEmpty)
        ? dto.artists!.first
        : (dto.albumArtist ?? '');
    return AlbumTrackInfo(
      id: dto.id,
      title: dto.name ?? '',
      artist: artist,
    );
  }

  factory AlbumTrackInfo.fromMap(Map<String, dynamic> map, {String? defaultArtist, String? defaultCoverUrl}) {
    final title = map['title']?.toString() ?? '';
    final artist = map['artist']?.toString() ?? defaultArtist ?? '';
    String? jfId;
    final lm = map['local_match'];
    if (lm is Map && lm['exists'] == true && lm['jellyfin_data'] is Map) {
      jfId = lm['jellyfin_data']['Id']?.toString();
    }
    return AlbumTrackInfo(
      id: jfId ?? map['id']?.toString(),
      title: title,
      artist: artist,
      queryString: map['query_string']?.toString(),
      coverUrl: map['cover_url']?.toString() ?? defaultCoverUrl,
    );
  }
}

class AlbumPlaylistStatus {
  final BaseItemDto playlist;
  int presentCount;
  final int totalCount;
  bool isAdding;
  final Set<String> existingSongIds;
  final Set<String> existingSongKeys;

  AlbumPlaylistStatus({
    required this.playlist,
    required this.presentCount,
    required this.totalCount,
    this.isAdding = false,
    required this.existingSongIds,
    required this.existingSongKeys,
  });

  bool get isFullyPresent => presentCount >= totalCount && totalCount > 0;
  bool get isPartiallyPresent => presentCount > 0 && !isFullyPresent;
  bool get isNonePresent => presentCount == 0;
  int get missingCount => (totalCount - presentCount).clamp(0, totalCount);
}

class AddAlbumToPlaylistSheet extends StatefulWidget {
  final String albumTitle;
  final String albumArtist;
  final String? albumCoverUrl;
  final BaseItemDto? albumItem;
  final List<AlbumTrackInfo> tracks;

  const AddAlbumToPlaylistSheet({
    Key? key,
    required this.albumTitle,
    required this.albumArtist,
    this.albumCoverUrl,
    this.albumItem,
    required this.tracks,
  }) : super(key: key);

  factory AddAlbumToPlaylistSheet.fromAlbumData({
    Key? key,
    required Map<String, dynamic> albumData,
    required List<dynamic> tracks,
  }) {
    final albumTitle = albumData['title']?.toString() ?? 'Álbum';
    final albumArtist = albumData['artist']?.toString() ?? '';
    final albumCoverUrl = albumData['cover_url']?.toString();

    final trackInfos = tracks.map((t) {
      if (t is Map<String, dynamic>) {
        return AlbumTrackInfo.fromMap(t, defaultArtist: albumArtist, defaultCoverUrl: albumCoverUrl);
      } else if (t is Map) {
        return AlbumTrackInfo.fromMap(Map<String, dynamic>.from(t), defaultArtist: albumArtist, defaultCoverUrl: albumCoverUrl);
      } else if (t is BaseItemDto) {
        return AlbumTrackInfo.fromBaseItemDto(t);
      }
      return AlbumTrackInfo(title: t.toString(), artist: albumArtist);
    }).toList();

    return AddAlbumToPlaylistSheet(
      key: key,
      albumTitle: albumTitle,
      albumArtist: albumArtist,
      albumCoverUrl: albumCoverUrl,
      tracks: trackInfos,
    );
  }

  factory AddAlbumToPlaylistSheet.fromBaseItemDto({
    Key? key,
    required BaseItemDto album,
    required List<BaseItemDto> tracks,
  }) {
    return AddAlbumToPlaylistSheet(
      key: key,
      albumTitle: album.name ?? 'Álbum',
      albumArtist: album.albumArtist ?? (album.artists?.isNotEmpty == true ? album.artists!.first : ''),
      albumItem: album,
      tracks: tracks.map((t) => AlbumTrackInfo.fromBaseItemDto(t)).toList(),
    );
  }

  @override
  State<AddAlbumToPlaylistSheet> createState() => _AddAlbumToPlaylistSheetState();
}

class _AddAlbumToPlaylistSheetState extends State<AddAlbumToPlaylistSheet> {
  final Color _synapColor = const Color(0xFF8B93FF);
  List<AlbumPlaylistStatus>? _statuses;
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<void>? _refreshSub;

  static String normalizeId(String id) {
    return id.toLowerCase().replaceAll('-', '').trim();
  }

  static String normalizeKey(String? title, String? artist) {
    final t = (title ?? '').toLowerCase().trim();
    final a = (artist ?? '').toLowerCase().trim();
    return '$t||$a';
  }

  @override
  void initState() {
    super.initState();
    _refreshSub = SynapEvents.onLibraryRefresh.listen((_) {
      if (mounted) {
        _fetchPlaylists();
      }
    });
    _fetchPlaylists();
  }

  @override
  void dispose() {
    _refreshSub?.cancel();
    super.dispose();
  }

  Future<void> _fetchPlaylists() async {
    try {
      final jellyfin = GetIt.instance<JellyfinApiHelper>();
      final playlists = await jellyfin.getItems(includeItemTypes: "Playlist", isGenres: false) ?? [];

      if (!mounted) return;

      // Asegurar que "My likes" esté presente
      final hasLikes = playlists.any((p) => LikesPlaylistHelper.isLikesPlaylist(p));
      if (!hasLikes) {
        LikesPlaylistHelper.getOrCreateLikesPlaylist().then((created) {
          if (created != null && mounted) {
            _fetchPlaylists();
          }
        });
      }

      // Ordenar y deduplicar
      final uniquePlaylists = <BaseItemDto>[];
      final seenIds = <String>{};
      for (final pl in playlists) {
        if (!seenIds.contains(pl.id)) {
          seenIds.add(pl.id);
          uniquePlaylists.add(pl);
        }
      }

      uniquePlaylists.sort((a, b) {
        final aIs = LikesPlaylistHelper.isLikesPlaylist(a);
        final bIs = LikesPlaylistHelper.isLikesPlaylist(b);
        if (aIs && !bIs) return -1;
        if (!aIs && bIs) return 1;
        return (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase());
      });

      // Crear estado inicial con verificación rápida en memoria
      final statuses = <AlbumPlaylistStatus>[];
      for (final pl in uniquePlaylists) {
        final isLikes = LikesPlaylistHelper.isLikesPlaylist(pl);
        final existingIds = <String>{};
        final existingKeys = <String>{};
        int count = 0;

        if (isLikes) {
          for (final t in widget.tracks) {
            if (LikesPlaylistHelper.isSongLiked(trackId: t.id, title: t.title, artist: t.artist)) {
              count++;
              if (t.id != null) existingIds.add(normalizeId(t.id!));
              existingKeys.add(normalizeKey(t.title, t.artist));
            }
          }
        }

        statuses.add(AlbumPlaylistStatus(
          playlist: pl,
          presentCount: count,
          totalCount: widget.tracks.length,
          existingSongIds: existingIds,
          existingSongKeys: existingKeys,
        ));
      }

      if (mounted) {
        setState(() {
          _statuses = statuses;
          _isLoading = false;
          _errorMessage = null;
        });
      }

      // Cargar contenidos de las playlists regulares en paralelo
      _loadTracksForPlaylists(statuses);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _loadTracksForPlaylists(List<AlbumPlaylistStatus> statuses) async {
    final jellyfin = GetIt.instance<JellyfinApiHelper>();

    await Future.wait(statuses.map((status) async {
      if (LikesPlaylistHelper.isLikesPlaylist(status.playlist)) return;

      try {
        final items = await jellyfin.getItems(parentItem: status.playlist, isGenres: false) ?? [];
        final existingIds = <String>{};
        final existingKeys = <String>{};

        for (final item in items) {
          existingIds.add(normalizeId(item.id));
          final artist = (item.artists?.isNotEmpty == true) ? item.artists![0] : (item.albumArtist ?? '');
          existingKeys.add(normalizeKey(item.name, artist));
        }

        int count = 0;
        for (final track in widget.tracks) {
          final idMatch = track.id != null && existingIds.contains(normalizeId(track.id!));
          final keyMatch = existingKeys.contains(normalizeKey(track.title, track.artist));
          if (idMatch || keyMatch) {
            count++;
          }
        }

        status.existingSongIds.addAll(existingIds);
        status.existingSongKeys.addAll(existingKeys);
        status.presentCount = count;
      } catch (_) {}
    }));

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _addAlbumToPlaylist(AlbumPlaylistStatus status) async {
    if (status.isAdding) return;

    final playlistName = status.playlist.name ?? 'Playlist';
    final isLikes = LikesPlaylistHelper.isLikesPlaylist(status.playlist);
    final messenger = ScaffoldMessenger.of(context);

    if (status.isFullyPresent) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Todas las canciones de este álbum ya están en "$playlistName".'),
          backgroundColor: const Color(0xFF2C2C2C),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Filtrar canciones que NO están en la playlist
    final missingTracks = widget.tracks.where((track) {
      final idMatch = track.id != null && status.existingSongIds.contains(normalizeId(track.id!));
      final keyMatch = status.existingSongKeys.contains(normalizeKey(track.title, track.artist));
      return !idMatch && !keyMatch;
    }).toList();

    if (missingTracks.isEmpty) {
      setState(() {
        status.presentCount = widget.tracks.length;
      });
      return;
    }

    setState(() {
      status.isAdding = true;
    });

    final jellyfin = GetIt.instance<JellyfinApiHelper>();

    try {
      final localMissingIds = <String>[];
      final remoteTracksToDownload = <AlbumTrackInfo>[];

      for (final t in missingTracks) {
        if (t.id != null && t.id!.isNotEmpty) {
          localMissingIds.add(t.id!);
        } else {
          remoteTracksToDownload.add(t);
        }
      }

      if (isLikes) {
        for (final t in missingTracks) {
          if (t.id != null) {
            try {
              await jellyfin.addFavourite(t.id!);
            } catch (_) {}
            LikesPlaylistHelper.addSongToLikes(t.id!, title: t.title, artist: t.artist);
          }
        }
        if (localMissingIds.isNotEmpty) {
          await jellyfin.addItemstoPlaylist(
            playlistId: status.playlist.id,
            ids: localMissingIds,
          );
        }
      } else {
        if (localMissingIds.isNotEmpty) {
          await jellyfin.addItemstoPlaylist(
            playlistId: status.playlist.id,
            ids: localMissingIds,
          );
        }
      }

      // Si hay canciones remotas que aún no están en Jellyfin, encolar su descarga a la playlist
      if (remoteTracksToDownload.isNotEmpty) {
        final coordinator = PlaybackDownloadCoordinator();
        for (final r in remoteTracksToDownload) {
          coordinator.downloadAndAddToPlaylist(
            playlistId: status.playlist.id,
            playlistName: playlistName,
            title: r.title,
            artist: r.artist,
            queryString: r.queryString,
            coverUrl: r.coverUrl,
            context: context,
          );
        }
      }

      // Actualizar estado local
      for (final t in missingTracks) {
        if (t.id != null) status.existingSongIds.add(normalizeId(t.id!));
        status.existingSongKeys.add(normalizeKey(t.title, t.artist));
      }
      status.presentCount = widget.tracks.length;
      status.isAdding = false;

      if (mounted) {
        setState(() {});
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              missingTracks.length == 1
                  ? 'Se agregó 1 canción a "$playlistName"'
                  : 'Se agregaron ${missingTracks.length} canciones a "$playlistName"',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      SynapEvents.fireLibraryRefresh();
    } catch (e) {
      if (mounted) {
        setState(() {
          status.isAdding = false;
        });
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error al agregar canciones: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showCreatePlaylistDialog() async {
    final controller = TextEditingController();
    bool isCreating = false;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
              title: const Text('Crear nueva playlist', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              content: TextField(
                controller: controller,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nombre de la playlist',
                  hintStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white24)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSubmitted: (_) async {
                  if (controller.text.trim().isEmpty || isCreating) return;
                  setDialogState(() => isCreating = true);
                  await _handleCreateNewPlaylist(controller.text.trim(), dialogCtx);
                },
              ),
              actions: [
                TextButton(
                  onPressed: isCreating ? null : () => Navigator.of(dialogCtx).pop(),
                  child: const Text('Cancelar', style: TextStyle(color: Color(0xFFA0A0A0))),
                ),
                ElevatedButton(
                  onPressed: isCreating
                      ? null
                      : () async {
                          if (controller.text.trim().isEmpty) return;
                          setDialogState(() => isCreating = true);
                          await _handleCreateNewPlaylist(controller.text.trim(), dialogCtx);
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: _synapColor),
                  child: isCreating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Text('Crear y agregar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _handleCreateNewPlaylist(String name, BuildContext dialogCtx) async {
    final messenger = ScaffoldMessenger.of(context);
    final dialogMessenger = ScaffoldMessenger.of(dialogCtx);
    final dialogNav = Navigator.of(dialogCtx);

    final userHelper = GetIt.instance<FinampUserHelper>();
    final userId = userHelper.currentUser?.id;
    final apiService = SynapApiService();

    final playlistId = await apiService.createPlaylist(name, userId: userId);
    if (!mounted) return;

    if (playlistId != null) {
      dialogNav.pop();

      final jellyfin = GetIt.instance<JellyfinApiHelper>();
      final localIds = widget.tracks
          .where((t) => t.id != null && t.id!.isNotEmpty)
          .map((t) => t.id!)
          .toList();

      try {
        if (localIds.isNotEmpty) {
          await jellyfin.addItemstoPlaylist(playlistId: playlistId, ids: localIds);
        }
        messenger.showSnackBar(
          SnackBar(
            content: Text('Playlist "$name" creada con ${widget.tracks.length} canciones.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Playlist creada, pero ocurrió un error al agregar canciones: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }

      SynapEvents.fireLibraryRefresh();
      _fetchPlaylists();
    } else {
      dialogMessenger.showSnackBar(
        const SnackBar(
          content: Text('Error al crear la playlist.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle gris superior
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Encabezado con información del Álbum
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 52,
                      height: 52,
                      child: widget.albumCoverUrl != null && widget.albumCoverUrl!.isNotEmpty
                          ? Image.network(
                              widget.albumCoverUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[900],
                                child: const Icon(Icons.album, color: Colors.white54),
                              ),
                            )
                          : (widget.albumItem != null
                              ? AlbumImage(item: widget.albumItem!)
                              : Container(
                                  color: Colors.grey[900],
                                  child: const Icon(Icons.album, color: Colors.white54),
                                )),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.albumTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.albumArtist.isNotEmpty
                              ? '${widget.albumArtist} • ${widget.tracks.length} canciones'
                              : '${widget.tracks.length} canciones',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Listo',
                      style: TextStyle(
                        color: _synapColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white12, height: 1),

            // Opción para Crear Nueva Playlist
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _synapColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.add, color: _synapColor, size: 26),
              ),
              title: Text(
                'Crear nueva playlist',
                style: TextStyle(fontWeight: FontWeight.bold, color: _synapColor, fontSize: 15),
              ),
              subtitle: const Text(
                'Crea una playlist y agrega este álbum',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              onTap: _showCreatePlaylistDialog,
            ),

            const Divider(color: Colors.white12, height: 1),

            // Lista de playlists del usuario
            Flexible(
              child: _buildPlaylistsList(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistsList() {
    if (_isLoading && (_statuses == null || _statuses!.isEmpty)) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_synapColor),
          ),
        ),
      );
    } else if (_errorMessage != null && (_statuses == null || _statuses!.isEmpty)) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text('Error al cargar playlists: $_errorMessage', style: const TextStyle(color: Colors.red)),
        ),
      );
    } else if (_statuses == null || _statuses!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Text('No tienes playlists creadas todavía.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    final statuses = _statuses!;
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: statuses.length,
      separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1, indent: 76),
      itemBuilder: (context, index) {
        final status = statuses[index];
        final playlist = status.playlist;
        final isLikes = LikesPlaylistHelper.isLikesPlaylist(playlist);

        Widget leadingIcon;
        if (status.isAdding) {
          leadingIcon = SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(_synapColor)),
          );
        } else if (status.isFullyPresent) {
          leadingIcon = Icon(
            isLikes ? Icons.favorite : Icons.check_circle,
            color: _synapColor,
            size: 26,
          );
        } else if (status.isPartiallyPresent) {
          leadingIcon = Icon(
            isLikes ? Icons.favorite_border : Icons.add_circle_outline,
            color: Colors.amber[400],
            size: 26,
          );
        } else {
          leadingIcon = Icon(
            isLikes ? Icons.favorite_border : Icons.queue_music,
            color: Colors.grey[500],
            size: 26,
          );
        }

        Widget trailingWidget;
        if (status.isAdding) {
          trailingWidget = const SizedBox.shrink();
        } else if (status.isFullyPresent) {
          trailingWidget = Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _synapColor.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _synapColor.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, size: 14, color: _synapColor),
                const SizedBox(width: 4),
                Text(
                  'En la playlist',
                  style: TextStyle(color: _synapColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          );
        } else if (status.isPartiallyPresent) {
          trailingWidget = Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 14, color: Colors.amber[300]),
                const SizedBox(width: 4),
                Text(
                  '+${status.missingCount}',
                  style: TextStyle(color: Colors.amber[300], fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          );
        } else {
          trailingWidget = Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 14, color: Colors.white70),
                SizedBox(width: 4),
                Text(
                  'Agregar',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          );
        }

        String subtitleText;
        Color subtitleColor;
        if (status.isFullyPresent) {
          subtitleText = 'Todas las canciones agregadas (${status.totalCount}/${status.totalCount})';
          subtitleColor = _synapColor;
        } else if (status.isPartiallyPresent) {
          subtitleText = '${status.presentCount} de ${status.totalCount} agregadas • Faltan ${status.missingCount} canciones';
          subtitleColor = Colors.amber[300]!;
        } else {
          subtitleText = '${status.totalCount} canciones del álbum';
          subtitleColor = Colors.grey[500]!;
        }

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: leadingIcon),
          ),
          title: Text(
            playlist.name ?? 'Sin nombre',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: status.isFullyPresent ? _synapColor : Colors.white,
              fontWeight: status.isFullyPresent ? FontWeight.bold : FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              subtitleText,
              style: TextStyle(color: subtitleColor, fontSize: 12),
            ),
          ),
          trailing: trailingWidget,
          onTap: () => _addAlbumToPlaylist(status),
        );
      },
    );
  }
}
