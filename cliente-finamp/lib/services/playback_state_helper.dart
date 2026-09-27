import 'package:audio_service/audio_service.dart';

extension DisplayToggleIntExt on int {
  int toggle(int max) => (this + 1) % max;
}

extension PlaybackStateHelper on PlaybackState {
  bool get isPlaying => playing;
  bool get isBuffering => processingState == AudioProcessingState.buffering;
  bool get isCompleted => processingState == AudioProcessingState.completed;
  bool get isShuffled => shuffleMode == AudioServiceShuffleMode.all;
}
