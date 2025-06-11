// lib/fitroute/web/web_history_manager_interface.dart

/// Abstract interface for web history management
abstract class WebHistoryManagerInterface {
  void pushState(String path, {Map<String, dynamic>? state});
  void replaceState(String path, {Map<String, dynamic>? state});
  void back();
  void forward();
  void go(int delta);
  String get currentPath;
  String get currentSearch;
  String get currentHash;
  String get currentUrl;
  void setupPopstateListener(void Function(String path) onPopstate);
  Map<String, String> parseQueryParameters([String? search]);
  String buildQueryString(Map<String, String> params);
  void updateUrl(String path,
      {Map<String, String>? queryParams, bool replace = true});
  void navigateToUrl(String url);
  void reload();
  void cleanupHashUrl();
  bool canGoBack();
  int get historyLength;
  void dispose();
}

/// Factory function - will be implemented by platform-specific files
WebHistoryManagerInterface createWebHistoryManager() {
  throw UnsupportedError('No implementation available for this platform');
}
