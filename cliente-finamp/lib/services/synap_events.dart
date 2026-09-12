import 'dart:async';

class SynapEvents {
  static final StreamController<void> libraryRefreshStream = StreamController<void>.broadcast();
  
  static Stream<void> get onLibraryRefresh => libraryRefreshStream.stream;

  static void fireLibraryRefresh() {
    libraryRefreshStream.add(null);
  }
}
