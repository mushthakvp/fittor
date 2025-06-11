import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// Manages browser history for web platform
class WebHistoryManager {
  static WebHistoryManager? _instance;
  static WebHistoryManager get instance =>
      _instance ??= WebHistoryManager._internal();

  WebHistoryManager._internal();

  /// Push a new state to browser history
  void pushState(String path, {Map<String, dynamic>? state}) {
    if (!kIsWeb) return;

    try {
      // Ensure path starts with /
      final cleanPath = _normalizePath(path);

      // Convert state to JSAny compatible format
      final stateData = state != null ? jsonEncode(state).toJS : null;
      web.window.history.pushState(
        stateData,
        '',
        cleanPath,
      );
    } catch (e) {
      debugPrint('Error pushing state to history: $e');
    }
  }

  /// Replace current state in browser history
  void replaceState(String path, {Map<String, dynamic>? state}) {
    if (!kIsWeb) return;

    try {
      // Ensure path starts with /
      final cleanPath = _normalizePath(path);

      // Convert state to JSAny compatible format
      final stateData = state != null ? jsonEncode(state).toJS : null;
      web.window.history.replaceState(
        stateData,
        '',
        cleanPath,
      );
    } catch (e) {
      debugPrint('Error replacing state in history: $e');
    }
  }

  /// Go back in browser history
  void back() {
    if (!kIsWeb) return;

    try {
      web.window.history.back();
    } catch (e) {
      debugPrint('Error going back in history: $e');
    }
  }

  /// Go forward in browser history
  void forward() {
    if (!kIsWeb) return;

    try {
      web.window.history.forward();
    } catch (e) {
      debugPrint('Error going forward in history: $e');
    }
  }

  /// Go to a specific position in history
  void go(int delta) {
    if (!kIsWeb) return;

    try {
      web.window.history.go(delta);
    } catch (e) {
      debugPrint('Error navigating in history: $e');
    }
  }

  /// Get current URL path
  String get currentPath {
    if (!kIsWeb) return '/';

    try {
      return web.window.location.pathname;
    } catch (e) {
      debugPrint('Error getting current path: $e');
      return '/';
    }
  }

  /// Get current URL search parameters
  String get currentSearch {
    if (!kIsWeb) return '';

    try {
      return web.window.location.search;
    } catch (e) {
      debugPrint('Error getting current search: $e');
      return '';
    }
  }

  /// Get current URL hash
  String get currentHash {
    if (!kIsWeb) return '';

    try {
      return web.window.location.hash;
    } catch (e) {
      debugPrint('Error getting current hash: $e');
      return '';
    }
  }

  /// Get full current URL
  String get currentUrl {
    if (!kIsWeb) return '';

    try {
      return web.window.location.href;
    } catch (e) {
      debugPrint('Error getting current URL: $e');
      return '';
    }
  }

  /// Set up popstate listener
  void setupPopstateListener(void Function(String path) onPopstate) {
    if (!kIsWeb) return;

    try {
      // Create a proper EventListener
      web.EventListener listener = (web.Event event) {
        final path = currentPath;
        onPopstate(path);
      }.toJS;

      web.window.addEventListener('popstate', listener);
    } catch (e) {
      debugPrint('Error setting up popstate listener: $e');
    }
  }

  /// Parse query parameters from URL
  Map<String, String> parseQueryParameters([String? search]) {
    search ??= currentSearch;
    if (search.isEmpty || !search.startsWith('?')) {
      return {};
    }

    final params = <String, String>{};
    final pairs = search.substring(1).split('&');

    for (final pair in pairs) {
      final parts = pair.split('=');
      if (parts.length == 2) {
        final key = Uri.decodeComponent(parts[0]);
        final value = Uri.decodeComponent(parts[1]);
        params[key] = value;
      }
    }

    return params;
  }

  /// Build query string from parameters
  String buildQueryString(Map<String, String> params) {
    if (params.isEmpty) return '';

    final pairs = params.entries.map((entry) {
      final key = Uri.encodeComponent(entry.key);
      final value = Uri.encodeComponent(entry.value);
      return '$key=$value';
    });

    return '?${pairs.join('&')}';
  }

  /// Update URL without triggering navigation
  void updateUrl(String path, {Map<String, String>? queryParams}) {
    if (!kIsWeb) return;

    String fullPath = _normalizePath(path);
    if (queryParams != null && queryParams.isNotEmpty) {
      fullPath += buildQueryString(queryParams);
    }

    replaceState(fullPath);
  }

  /// Navigate to URL (triggers page reload)
  void navigateToUrl(String url) {
    if (!kIsWeb) return;

    try {
      web.window.location.href = url;
    } catch (e) {
      debugPrint('Error navigating to URL: $e');
    }
  }

  /// Reload current page
  void reload() {
    if (!kIsWeb) return;

    try {
      web.window.location.reload();
    } catch (e) {
      debugPrint('Error reloading page: $e');
    }
  }

  /// Clean up hash-based URLs and convert to proper paths
  void cleanupHashUrl() {
    if (!kIsWeb) return;

    try {
      final currentUrl = web.window.location.href;
      if (currentUrl.contains('#/')) {
        final hashPath = currentUrl.split('#/')[1];
        final cleanPath = '/$hashPath';

        // Replace the URL without the hash
        replaceState(cleanPath);
      }
    } catch (e) {
      debugPrint('Error cleaning up hash URL: $e');
    }
  }

  /// Normalize path to ensure it starts with /
  String _normalizePath(String path) {
    if (path.isEmpty) return '/';

    // Remove hash fragments if present
    final hashIndex = path.indexOf('#');
    if (hashIndex != -1) {
      path = path.substring(0, hashIndex);
    }

    // Ensure starts with /
    if (!path.startsWith('/')) {
      path = '/$path';
    }

    // Remove trailing / except for root
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }

    return path;
  }
}
