// lib/fitroute/utils/platform_utils_interface.dart

/// Abstract interface for platform-specific utilities
abstract class PlatformUtilsInterface {
  void updateUrl(String path, {bool replace = true});
  void pushUrl(String path);
  void replaceUrl(String path);
  String? getCurrentPath();
  bool canGoBack();
  void goBack();
  void goForward();
  void platformSpecificInit();
  void handleUrlChange(String initialUrl, Function(String) callback);
  String getCurrentUrlOrState();
  Future<bool> shareContent(String content, {String? subject});
  int getHistoryLength();
}

/// Factory function - will be implemented by platform-specific files
PlatformUtilsInterface createPlatformUtils() {
  throw UnsupportedError('No implementation available for this platform');
}
