import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../services/finamp_settings_helper.dart';
import '../album_image.dart';
import '../../models/jellyfin_models.dart';
import '../../services/process_artist.dart';
import '../../services/media_state_stream.dart';
import '../../services/music_player_background_task.dart';
import '../strict_dismissible.dart';

class _QueueListStreamState {
  _QueueListStreamState(
    this.queue,
    this.mediaState,
  );

  final List<MediaItem>? queue;
  final MediaState mediaState;
}

class QueueList extends StatefulWidget {
  const QueueList({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<QueueList> createState() => _QueueListState();
}

class _QueueListState extends State<QueueList> {
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  bool _hasScrolledToCurrent = false;
  List<MediaItem> _queueItems = [];
  bool _isReordering = false;

  void _scrollToCurrentTrack(int visualIndex) {
    if (_hasScrolledToCurrent || visualIndex <= 0) return;
    _hasScrolledToCurrent = true;

    void attemptScroll() {
      if (!mounted || !widget.scrollController.hasClients) return;
      if (widget.scrollController.position.hasContentDimensions) {
        final maxScroll = widget.scrollController.position.maxScrollExtent;
        final targetOffset = (visualIndex * 72.0).clamp(0.0, maxScroll);
        if (targetOffset > 0) {
          widget.scrollController.jumpTo(targetOffset);
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) => attemptScroll());
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => attemptScroll());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_QueueListStreamState>(
      stream: Rx.combineLatest2<List<MediaItem>?, MediaState,
              _QueueListStreamState>(_audioHandler.queue, mediaStateStream,
          (a, b) => _QueueListStreamState(a, b)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final serverQueue = snapshot.data!.queue ?? [];
        if (!_isReordering) {
          _queueItems = List<MediaItem>.from(serverQueue);
        }
        final currentMediaItem = snapshot.data!.mediaState.mediaItem;

        if (_queueItems.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.queue_music, size: 64, color: Colors.white24),
                SizedBox(height: 16),
                Text(
                  'No hay canciones en la cola',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ],
            ),
          );
        }

        int playingIndex = -1;
        if (currentMediaItem != null) {
          playingIndex = _queueItems.indexWhere((item) => item.id == currentMediaItem.id);
        }

        if (!_hasScrolledToCurrent && playingIndex > 0) {
          _scrollToCurrentTrack(playingIndex);
        }

        return SafeArea(
          child: Column(
            children: [
              // Barra superior para arrastre / dismiss
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 40,
                height: 4.5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              // Encabezado de la cola
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.queue_music, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.queue,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${_queueItems.length})',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.white54,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, size: 28),
                      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Lista reordenable y desplazable
              Expanded(
                child: PrimaryScrollController(
                  controller: widget.scrollController,
                  child: ReorderableListView.builder(
                    scrollController: widget.scrollController,
                    buildDefaultDragHandles: false,
                    itemExtent: 72.0,
                    itemCount: _queueItems.length,
                    proxyDecorator: (Widget child, int index, Animation<double> animation) {
                      return Material(
                        elevation: 6,
                        color: Theme.of(context).cardColor,
                        shadowColor: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                        child: child,
                      );
                    },
                    onReorder: (oldIndex, newIndex) async {
                      if (oldIndex == newIndex ||
                          (oldIndex < newIndex && newIndex == oldIndex + 1)) {
                        return;
                      }

                      setState(() {
                        _isReordering = true;
                        int targetIndex = newIndex;
                        if (oldIndex < newIndex) {
                          targetIndex -= 1;
                        }
                        final item = _queueItems.removeAt(oldIndex);
                        _queueItems.insert(targetIndex, item);
                      });

                      try {
                        if (_audioHandler.playbackState.valueOrNull?.shuffleMode ==
                            AudioServiceShuffleMode.all) {
                          await _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
                        }
                        await _audioHandler.reorderQueue(oldIndex, newIndex);
                      } catch (_) {
                        // Error handling: next stream update will restore state
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isReordering = false;
                          });
                        }
                      }
                    },
                    itemBuilder: (context, index) {
                      final mediaItem = _queueItems[index];
                      final isPlaying = currentMediaItem?.id == mediaItem.id;

                      return StrictDismissible(
                        key: ValueKey(mediaItem.id),
                        direction: FinampSettingsHelper.finampSettings.disableGesture
                            ? DismissDirection.none
                            : DismissDirection.horizontal,
                        dismissThresholds: const {
                          DismissDirection.horizontal: 0.5,
                        },
                        background: Container(
                          color: Colors.red.shade900.withValues(alpha: 0.7),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red.shade900.withValues(alpha: 0.7),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
                        ),
                        onDismissed: (direction) async {
                          final itemId = mediaItem.id;
                          final actualIndex = _audioHandler.queue.valueOrNull
                                  ?.indexWhere((item) => item.id == itemId) ??
                              -1;
                          setState(() {
                            _queueItems.removeWhere((item) => item.id == itemId);
                          });
                          if (actualIndex != -1) {
                            await _audioHandler.removeQueueItemAt(actualIndex);
                          }
                        },
                        child: Container(
                          color: isPlaying
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
                              : null,
                          child: ListTile(
                            leading: SizedBox(
                              width: 48,
                              height: 48,
                              child: AlbumImage(
                                item: mediaItem.extras?["itemJson"] == null
                                    ? null
                                    : BaseItemDto.fromJson(
                                        mediaItem.extras!["itemJson"]),
                              ),
                            ),
                            title: Text(
                              mediaItem.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isPlaying
                                    ? Theme.of(context).colorScheme.secondary
                                    : null,
                                fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                              processArtist(mediaItem.artist, context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: ReorderableDragStartListener(
                              index: index,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 14.0),
                                color: Colors.transparent,
                                child: const Icon(
                                  Icons.drag_handle,
                                  color: Colors.white60,
                                  size: 24,
                                ),
                              ),
                            ),
                            onTap: () async {
                              final actualIndex = _audioHandler.queue.valueOrNull
                                      ?.indexWhere((item) => item.id == mediaItem.id) ??
                                  index;
                              await _audioHandler.skipToIndex(actualIndex);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
