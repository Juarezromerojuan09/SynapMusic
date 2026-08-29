import 'dart:async';

class SynapEvents {
  static final StreamController<void> libraryRefreshStream = StreamController<void>.broadcast();
  
  static void fireLibraryRefresh() {
    libraryRefreshStream.add(null);
  }
}
