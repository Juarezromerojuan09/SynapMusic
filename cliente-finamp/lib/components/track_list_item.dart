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
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.music_note, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color synapColor = Color(0xFF144477);

    Widget actualTrailingWidget = trailingWidget ?? (isAvailableInServer 
      ? IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: onMenuPressed,
        ) 
      : IconButton(
          icon: const Icon(Icons.download, color: synapColor),
          onPressed: onDownloadPressed,
        ));

    List<Widget> leadingChildren = [];

    if (trackNumber != null) {
      leadingChildren.add(
        SizedBox(
          width: 24,
          child: Center(
            child: Text(
              '$trackNumber',
              style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    if (coverUrl != null) {
      if (coverUrl!.isNotEmpty) {
        leadingChildren.add(
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              coverUrl!,
              width: 45,
              height: 45,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(),
            ),
          ),
        );
      } else {
        leadingChildren.add(_buildPlaceholder());
      }
    }

    Widget leadingWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: leadingChildren,
    );

    final tile = InkWell(
      onTap: isAvailableInServer ? onPlayPressed : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            leadingWidget,
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(
                    duration != null ? '$artist • $duration' : artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            actualTrailingWidget,
          ],
        ),
      ),
    );

    if (trackId == null) return tile;

    return StreamBuilder<MediaState>(
      stream: mediaStateStream,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data?.mediaItem;
        final playingId = mediaItem?.extras?['itemJson']?['Id'];
        final isPlaying = playingId != null && playingId == trackId;
        final color = isPlaying ? synapColor.withOpacity(0.2) : Colors.transparent;
        return Container(
          color: color,
          child: Row(
            children: [
              if (isPlaying)
                Container(width: 4, height: 40, color: synapColor, margin: const EdgeInsets.only(left: 4)),
              Expanded(child: tile),
            ],
          ),
        );
      },
    );
  }
}
