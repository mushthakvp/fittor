// lib/fitroute/web/web_history_manager.dart
// Conditional imports - only import web libraries on web platform
import 'web_history_manager_interface.dart'
    if (dart.library.js_interop) 'web_history_manager_web.dart'
    if (dart.library.io) 'web_history_manager_stub.dart';

/// Manages browser history for web platform with improved integration
class WebHistoryManager {
  static WebHistoryManager? _instance;
  static WebHistoryManager get instance =>
      _instance ??= WebHistoryManager._internal();

  WebHistoryManager._internal();

  final WebHistoryManagerInterface _implementation = createWebHistoryManager();

  /// Push a new state to browser history
  void pushState(String path, {Map<String, dynamic>? state}) {
    _implementation.pushState(path, state: state);
  }

  /// Replace current state in browser history
  void replaceState(String path, {Map<String, dynamic>? state}) {
    _implementation.replaceState(path, state: state);
  }

  /// Go back in browser history
  void back() {
    _implementation.back();
  }

  /// Go forward in browser history
  void forward() {
    _implementation.forward();
  }

  /// Go to a specific position in history
  void go(int delta) {
    _implementation.go(delta);
  }

  /// Get current URL path
  String get currentPath => _implementation.currentPath;

  /// Get current URL search parameters
  String get currentSearch => _implementation.currentSearch;

  /// Get current URL hash
  String get currentHash => _implementation.currentHash;

  /// Get full current URL
  String get currentUrl => _implementation.currentUrl;

  /// Set up popstate listener with improved handling
  void setupPopstateListener(void Function(String path) onPopstate) {
    _implementation.setupPopstateListener(onPopstate);
  }

  /// Parse query parameters from URL
  Map<String, String> parseQueryParameters([String? search]) {
    return _implementation.parseQueryParameters(search);
  }

  /// Build query string from parameters
  String buildQueryString(Map<String, String> params) {
    return _implementation.buildQueryString(params);
  }

  /// Update URL without triggering navigation
  void updateUrl(String path,
      {Map<String, String>? queryParams, bool replace = true}) {
    _implementation.updateUrl(path, queryParams: queryParams, replace: replace);
  }

  /// Navigate to URL (triggers page reload)
  void navigateToUrl(String url) {
    _implementation.navigateToUrl(url);
  }

  /// Reload current page
  void reload() {
    _implementation.reload();
  }

  /// Clean up hash-based URLs and convert to proper paths
  void cleanupHashUrl() {
    _implementation.cleanupHashUrl();
  }

  /// Check if we can go back in history
  bool canGoBack() {
    return _implementation.canGoBack();
  }

  /// Get browser history length
  int get historyLength => _implementation.historyLength;

  /// Dispose resources
  void dispose() {
    _implementation.dispose();
  }
}
