import 'package:flutter/material.dart';
import '../services/media_state_stream.dart';

class TrackListItem extends StatelessWidget {
  final String title;
  final String artist;
  final bool isAvailableInServer;
  final VoidCallback? onDownloadPressed;
  final VoidCallback? onPlayPressed;
  final VoidCallback? onMenuPressed;
  final String? duration;
  final String? coverUrl;
  final int? trackNumber;
  final String? trackId;
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
    this.trackNumber,
    this.trackId,
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

    Widget actualTrailingWidget = trailingWidget ?? (isAvailableInServer 
      ? IconButton(
          icon: const Icon(Icons.more_vert, color: Color(0xFFA0A0A0)),
          onPressed: onMenuPressed,
        ) 
      : IconButton(
          icon: const Icon(Icons.download, color: synapAccent),
          onPressed: onDownloadPressed,
        ));

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
      if (coverUrl != null && coverUrl!.isNotEmpty) {
        leadingChildren.add(const SizedBox(width: 8));
      }
    }

    if (coverUrl != null && coverUrl!.isNotEmpty) {
      leadingChildren.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            coverUrl!,
            width: 46,
            height: 46,
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
      onTap: isAvailableInServer ? onPlayPressed : null,
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
            : StreamBuilder<MediaState>(
                stream: mediaStateStream,
                builder: (context, snapshot) {
                  final mediaItem = snapshot.data?.mediaItem;
                  final playingId = mediaItem?.extras?['itemJson']?['Id'];
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
