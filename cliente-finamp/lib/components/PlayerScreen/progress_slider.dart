import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/music_player_background_task.dart';
import '../../services/progress_state_stream.dart';
import '../print_duration.dart';

class ProgressSlider extends StatefulWidget {
  const ProgressSlider({
    Key? key,
    this.allowSeeking = true,
    this.showBuffer = true,
    this.showDuration = true,
    this.showPlaceholder = true,
  }) : super(key: key);

  final bool allowSeeking;
  final bool showBuffer;
  final bool showDuration;
  final bool showPlaceholder;

  @override
  State<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  /// Value used to hold the slider's value when dragging.
  double? _dragValue;

  late SliderThemeData _sliderThemeData;

  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 4.5,
      activeTrackColor: const Color(0xFF8B93FF),
      inactiveTrackColor: const Color(0xFF2A2A2A),
      secondaryActiveTrackColor: const Color(0xFF3E3E3E),
      thumbColor: Colors.white,
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 6.0,
        elevation: 2.0,
        pressedElevation: 4.0,
      ),
      overlayColor: const Color(0xFF8B93FF).withOpacity(0.18),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 18.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The slider always needs to be LTR, so we use Directionality to save
    // putting TextDirection.ltr all over the place
    return Directionality(
      textDirection: TextDirection.ltr,
      // The slider can refresh up to 60 times per second, so we wrap it in a
      // RepaintBoundary to avoid more areas being repainted than necessary
      child: RepaintBoundary(
        child: StreamBuilder<ProgressState>(
          stream: progressStateStream,
          builder: (context, snapshot) {
            if (snapshot.data?.mediaItem == null) {
              // If nothing is playing or the AudioService isn't connected, return a
              // greyed out slider with some fake numbers. We also do this if
              // currentPosition is null, which sometimes happens when the app is
              // closed and reopened.
              return widget.showPlaceholder
                  ? Column(
                      children: [
                        SliderTheme(
                          data: _sliderThemeData.copyWith(
                            trackShape: CustomTrackShape(),
                          ),
                          child: const Slider(
                            value: 0,
                            max: 1,
                            onChanged: null,
                          ),
                        ),
                        if (widget.showDuration)
                          const Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "00:00",
                                style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                              ),
                              Text(
                                "00:00",
                                style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                              ),
                            ],
                          ),
                      ],
                    )
                  : const SizedBox.shrink();
            } else if (snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Slider displaying playback and buffering progress.
                  SliderTheme(
                    data: _sliderThemeData.copyWith(
                      trackShape: CustomTrackShape(),
                    ),
                    child: Slider(
                      min: 0.0,
                      max: snapshot.data!.mediaItem?.duration == null
                          ? snapshot.data!.playbackState.bufferedPosition
                              .inMicroseconds
                              .toDouble()
                          : snapshot.data!.mediaItem!.duration!.inMicroseconds
                              .toDouble(),
                      value: (_dragValue ??
                              snapshot.data!.position.inMicroseconds)
                          .clamp(
                              0,
                              snapshot.data!.mediaItem!.duration!.inMicroseconds
                                  .toDouble())
                          .toDouble(),
                      secondaryTrackValue: widget.showBuffer &&
                              snapshot.data!.mediaItem
                                      ?.extras?["downloadedSongJson"] ==
                                  null
                          ? snapshot.data!.playbackState.bufferedPosition
                              .inMicroseconds
                              .clamp(
                                0.0,
                                snapshot.data!.mediaItem!.duration == null
                                    ? snapshot.data!.playbackState
                                        .bufferedPosition.inMicroseconds
                                    : snapshot.data!.mediaItem!.duration!
                                        .inMicroseconds,
                              )
                              .toDouble()
                          : 0,
                      onChanged: widget.allowSeeking
                          ? (newValue) async {
                              setState(() {
                                _dragValue = newValue;
                              });
                            }
                          : (_) {},
                      onChangeStart: widget.allowSeeking
                          ? (value) {
                              setState(() {
                                _dragValue = value;
                              });
                            }
                          : (_) {},
                      onChangeEnd: widget.allowSeeking
                          ? (newValue) async {
                              final seekPos =
                                  Duration(microseconds: newValue.toInt());
                              setState(() {
                                _dragValue = newValue;
                              });
                              await _audioHandler.seek(seekPos);
                              await Future.delayed(
                                  const Duration(milliseconds: 250));
                              if (mounted && _dragValue == newValue) {
                                setState(() {
                                  _dragValue = null;
                                });
                              }
                            }
                          : (_) {},
                    ),
                  ),
                  if (widget.showDuration)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          printDuration(
                            Duration(
                                microseconds: _dragValue?.toInt() ??
                                    snapshot.data!.position.inMicroseconds),
                          ),
                          style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                        ),
                        Text(
                          printDuration(snapshot.data!.mediaItem?.duration),
                          style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                        ),
                      ],
                    ),
                ],
              );
            } else {
              return const Text(
                  "Snapshot doesn't have data and MediaItem isn't null and AudioService is connected?");
            }
          },
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}

/// Track shape used to remove horizontal padding.
/// https://github.com/flutter/flutter/issues/37057
class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    const double thumbRadius = 6.0;
    final double trackLeft = offset.dx + thumbRadius;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - (thumbRadius * 2);
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  /// Disable additionalActiveTrackHeight
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      secondaryOffset: secondaryOffset,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
    );
  }
}