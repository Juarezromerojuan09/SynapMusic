import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:finamp/l10n/app_localizations.dart';

import '../../services/music_player_background_task.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<PlaybackState>(
      stream: audioHandler.playbackState.distinct((prev, curr) =>
          prev.playing == curr.playing &&
          prev.processingState == curr.processingState &&
          prev.shuffleMode == curr.shuffleMode &&
          prev.repeatMode == curr.repeatMode),
      builder: (context, snapshot) {
        final PlaybackState? playbackState = snapshot.data;
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.ltr,
          children: [
            IconButton(
              tooltip: playbackState?.shuffleMode == AudioServiceShuffleMode.all
                  ? AppLocalizations.of(context)!.playbackOrderShuffledTooltip
                  : AppLocalizations.of(context)!.playbackOrderLinearTooltip,
              icon: _getShufflingIcon(
                playbackState == null
                    ? AudioServiceShuffleMode.none
                    : playbackState.shuffleMode,
                const Color(0xFF8B93FF),
              ),
              onPressed: playbackState != null
                  ? () async {
                      if (playbackState.shuffleMode ==
                          AudioServiceShuffleMode.all) {
                        await audioHandler
                            .setShuffleMode(AudioServiceShuffleMode.none);
                      } else {
                        await audioHandler
                            .setShuffleMode(AudioServiceShuffleMode.all);
                      }
                    }
                  : null,
              iconSize: 22,
            ),
            IconButton(
              tooltip: AppLocalizations.of(context)!.skipToPrevious,
              icon: const Icon(Icons.skip_previous, color: Colors.white),
              onPressed: playbackState != null
                  ? () async => await audioHandler.skipToPrevious()
                  : null,
              iconSize: 36,
            ),
            GestureDetector(
              onTap: playbackState != null
                  ? () async {
                      if (playbackState.playing) {
                        await audioHandler.pause();
                      } else {
                        await audioHandler.play();
                      }
                    }
                  : null,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B93FF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B93FF).withOpacity(0.45),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    playbackState == null || playbackState.playing
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 38,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            IconButton(
                tooltip: AppLocalizations.of(context)!.skipToNext,
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: playbackState != null
                    ? () async => audioHandler.skipToNext()
                    : null,
                iconSize: 36),
            IconButton(
              tooltip: playbackState?.repeatMode == AudioServiceRepeatMode.all
                  ? AppLocalizations.of(context)!.loopModeAllTooltip
                  : playbackState?.repeatMode == AudioServiceRepeatMode.one
                      ? AppLocalizations.of(context)!.loopModeOneTooltip
                      : AppLocalizations.of(context)!.loopModeNoneTooltip,
              icon: _getRepeatingIcon(
                playbackState == null
                    ? AudioServiceRepeatMode.none
                    : playbackState.repeatMode,
                const Color(0xFF8B93FF),
              ),
              onPressed: playbackState != null
                  ? () async {
                      // Cyles from none -> all -> one
                      if (playbackState.repeatMode ==
                          AudioServiceRepeatMode.none) {
                        await audioHandler
                            .setRepeatMode(AudioServiceRepeatMode.all);
                      } else if (playbackState.repeatMode ==
                          AudioServiceRepeatMode.all) {
                        await audioHandler
                            .setRepeatMode(AudioServiceRepeatMode.one);
                      } else {
                        await audioHandler
                            .setRepeatMode(AudioServiceRepeatMode.none);
                      }
                    }
                  : null,
              iconSize: 22,
            ),
          ],
        );
      },
    );
  }

  Widget _getRepeatingIcon(
      AudioServiceRepeatMode repeatMode, Color activeColor) {
    if (repeatMode == AudioServiceRepeatMode.all) {
      return Icon(Icons.repeat, color: activeColor);
    } else if (repeatMode == AudioServiceRepeatMode.one) {
      return Icon(Icons.repeat_one, color: activeColor);
    } else {
      return const Icon(Icons.repeat, color: Color(0xFFA0A0A0));
    }
  }

  Icon _getShufflingIcon(
      AudioServiceShuffleMode shuffleMode, Color activeColor) {
    if (shuffleMode == AudioServiceShuffleMode.all) {
      return Icon(Icons.shuffle, color: activeColor);
    } else {
      return const Icon(Icons.shuffle, color: Color(0xFFA0A0A0));
    }
  }
}
