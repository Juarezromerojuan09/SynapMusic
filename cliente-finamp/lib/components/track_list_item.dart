import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import '../services/music_player_background_task.dart';
import '../services/likes_playlist_helper.dart';

class TrackListItem extends StatelessWidget {
  final String title;
  final String artist;
  final bool isAvailableInServer;
  final VoidCallback? onDownloadPressed;
  final VoidCallback? onPlayPressed;
  final VoidCallback? onMenuPressed;
  final String? duration;
  final String? coverUrl;
  final File? coverFile;
  final int? trackNumber;
  final String? trackId;
  final String? queryString;
  final Widget? trailingWidget;

  const TrackListItem({
    Key? key,
    required this.title,
    required this.artist,
    required this.isAvailableInServer,
    this.onDownloadPressed,
    this.onPlayPressed,
    this.onMenuPressed,
    this.duration,
    this.coverUrl,
    this.coverFile,
    this.trackNumber,
    this.trackId,
    this.queryString,
    this.trailingWidget,
  }) : super(key: key);

  Widget _buildPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.music_note, color: Color(0xFFA0A0A0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color synapAccent = Color(0xFF8B93FF);

    final Widget heartButton = ValueListenableBuilder<Set<String>>(
      valueListenable: LikesPlaylistHelper.likedSongKeys,
      builder: (context, likedKeys, _) {
        return ValueListenableBuilder<Set<String>>(
          valueListenable: LikesPlaylistHelper.likedSongIds,
          builder: (context, likedIds, _) {
            final isLiked = LikesPlaylistHelper.isSongLiked(
              trackId: trackId,
              title: title,
              artist: artist,
            );

            return IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? synapAccent : const Color(0xFFA0A0A0),
                size: 22,
              ),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
              tooltip: isLiked ? 'Eliminar de My likes' : 'Agregar a My likes',
              onPressed: () {
                LikesPlaylistHelper.toggleLike(
                  trackId: isAvailableInServer ? trackId : null,
                  title: title,
                  artist: artist,
                  queryString: queryString,
                  coverUrl: coverUrl,
                  context: context,
                );
              },
            );
          },
        );
      },
    );

    final Widget actionOrTrailing = trailingWidget ??
        IconButton(
          icon: const Icon(Icons.more_vert, color: Color(0xFFA0A0A0)),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
          onPressed: onMenuPressed,
        );

    Widget actualTrailingWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        heartButton,
        actionOrTrailing,
      ],
    );

    List<Widget> leadingChildren = [];

    if (trackNumber != null) {
      leadingChildren.add(
        SizedBox(
          width: 26,
          child: Center(
            child: Text(
              '$trackNumber',
              style: const TextStyle(
                color: Color(0xFFA0A0A0),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
      if ((coverFile != null) || (coverUrl != null && coverUrl!.isNotEmpty)) {
        leadingChildren.add(const SizedBox(width: 8));
      }
    }

    if (coverFile != null) {
      leadingChildren.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            coverFile!,
            width: 46,
            height: 46,
            cacheWidth: 120,
            cacheHeight: 120,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(),
          ),
        ),
      );
    } else if (coverUrl != null && coverUrl!.isNotEmpty) {
      leadingChildren.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            coverUrl!,
            width: 46,
            height: 46,
            cacheWidth: 120,
            cacheHeight: 120,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(),
          ),
        ),
      );
    } else if (trackNumber == null) {
      leadingChildren.add(_buildPlaceholder());
    }

    Widget leadingWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: leadingChildren,
    );

    final tile = ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      onTap: onPlayPressed,
      leading: leadingWidget,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        duration != null ? '$artist • $duration' : artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xFFA0A0A0),
          fontSize: 13,
        ),
      ),
      trailing: actualTrailingWidget,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: trackId == null
            ? tile
            : StreamBuilder<MediaItem?>(
                stream: GetIt.instance<MusicPlayerBackgroundTask>().mediaItem,
                builder: (context, snapshot) {
                  final playingId = snapshot.data?.extras?['itemJson']?['Id'];
                  final isPlaying = playingId != null && playingId == trackId;
                  return Container(
                    decoration: BoxDecoration(
                      color: isPlaying ? synapAccent.withOpacity(0.12) : Colors.transparent,
                      border: isPlaying ? Border.all(color: synapAccent.withOpacity(0.3), width: 1) : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: tile,
                  );
                },
              ),
      ),
    );
  }
}
