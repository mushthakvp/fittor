// lib/fitroute/web/web_history_manager_stub.dart

import 'web_history_manager_interface.dart';

/// Stub implementation for mobile platforms
class WebHistoryManagerStub implements WebHistoryManagerInterface {
  @override
  void pushState(String path, {Map<String, dynamic>? state}) {
    // No-op for mobile platforms
  }

  @override
  void replaceState(String path, {Map<String, dynamic>? state}) {
    // No-op for mobile platforms
  }

  @override
  void back() {
    // No-op for mobile platforms
  }

  @override
  void forward() {
    // No-op for mobile platforms
  }

  @override
  void go(int delta) {
    // No-op for mobile platforms
  }

  @override
  String get currentPath => '/';

  @override
  String get currentSearch => '';

  @override
  String get currentHash => '';

  @override
  String get currentUrl => '';

  @override
  void setupPopstateListener(void Function(String path) onPopstate) {
    // No-op for mobile platforms
  }

  @override
  Map<String, String> parseQueryParameters([String? search]) {
    return {};
  }

  @override
  String buildQueryString(Map<String, String> params) {
    return '';
  }

  @override
  void updateUrl(String path,
      {Map<String, String>? queryParams, bool replace = true}) {
    // No-op for mobile platforms
  }

  @override
  void navigateToUrl(String url) {
    // No-op for mobile platforms
  }

  @override
  void reload() {
    // No-op for mobile platforms
  }

  @override
  void cleanupHashUrl() {
    // No-op for mobile platforms
  }

  @override
  bool canGoBack() {
    return false;
  }

  @override
  int get historyLength => 0;

  @override
  void dispose() {
    // No-op for mobile platforms
  }
}

/// Factory function for mobile platforms
WebHistoryManagerInterface createWebHistoryManager() {
  return WebHistoryManagerStub();
}
