// lib/fitroute/web/web_history_manager_web.dart
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import 'web_history_manager_interface.dart';

/// Web-specific implementation of WebHistoryManagerInterface
class WebHistoryManagerWeb implements WebHistoryManagerInterface {
  web.EventListener? _popstateListener;
  bool _isNavigating = false;

  @override
  void pushState(String path, {Map<String, dynamic>? state}) {
    if (_isNavigating) return;

    try {
      _isNavigating = true;
      final cleanPath = _normalizePath(path);
      final stateData = state != null ? jsonEncode(state).toJS : null;

      web.window.history.pushState(stateData, '', cleanPath);

      // Small delay to prevent rapid successive calls
      Future.delayed(const Duration(milliseconds: 10), () {
        _isNavigating = false;
      });
    } catch (e) {
      _isNavigating = false;
      debugPrint('Error pushing state to history: $e');
    }
  }

  @override
  void replaceState(String path, {Map<String, dynamic>? state}) {
    if (_isNavigating) return;

    try {
      _isNavigating = true;
      final cleanPath = _normalizePath(path);
      final stateData = state != null ? jsonEncode(state).toJS : null;

      web.window.history.replaceState(stateData, '', cleanPath);

      // Small delay to prevent rapid successive calls
      Future.delayed(const Duration(milliseconds: 10), () {
        _isNavigating = false;
      });
    } catch (e) {
      _isNavigating = false;
      debugPrint('Error replacing state in history: $e');
    }
  }

  @override
  void back() {
    try {
      web.window.history.back();
    } catch (e) {
      debugPrint('Error going back in history: $e');
    }
  }

  @override
  void forward() {
    try {
      web.window.history.forward();
    } catch (e) {
      debugPrint('Error going forward in history: $e');
    }
  }

  @override
  void go(int delta) {
    try {
      web.window.history.go(delta);
    } catch (e) {
      debugPrint('Error navigating in history: $e');
    }
  }

  @override
  String get currentPath {
    try {
      return web.window.location.pathname;
    } catch (e) {
      debugPrint('Error getting current path: $e');
      return '/';
    }
  }

  @override
  String get currentSearch {
    try {
      return web.window.location.search;
    } catch (e) {
      debugPrint('Error getting current search: $e');
      return '';
    }
  }

  @override
  String get currentHash {
    try {
      return web.window.location.hash;
    } catch (e) {
      debugPrint('Error getting current hash: $e');
      return '';
    }
  }

  @override
  String get currentUrl {
    try {
      return web.window.location.href;
    } catch (e) {
      debugPrint('Error getting current URL: $e');
      return '';
    }
  }

  @override
  void setupPopstateListener(void Function(String path) onPopstate) {
    try {
      // Remove existing listener if any
      if (_popstateListener != null) {
        web.window.removeEventListener('popstate', _popstateListener!);
      }

      // Create new listener
      _popstateListener = (web.Event event) {
        // Prevent handling if we're currently navigating
        if (_isNavigating) return;

        final path = currentPath;
        debugPrint('Browser popstate event: $path');

        // Use a small delay to ensure the URL has updated
        Future.delayed(const Duration(milliseconds: 50), () {
          onPopstate(path);
        });
      }.toJS;

      web.window.addEventListener('popstate', _popstateListener!);
      debugPrint('Popstate listener setup complete');
    } catch (e) {
      debugPrint('Error setting up popstate listener: $e');
    }
  }

  @override
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

  @override
  String buildQueryString(Map<String, String> params) {
    if (params.isEmpty) return '';

    final pairs = params.entries.map((entry) {
      final key = Uri.encodeComponent(entry.key);
      final value = Uri.encodeComponent(entry.value);
      return '$key=$value';
    });

    return '?${pairs.join('&')}';
  }

  @override
  void updateUrl(String path,
      {Map<String, String>? queryParams, bool replace = true}) {
    String fullPath = _normalizePath(path);
    if (queryParams != null && queryParams.isNotEmpty) {
      fullPath += buildQueryString(queryParams);
    }

    if (replace) {
      replaceState(fullPath);
    } else {
      pushState(fullPath);
    }
  }

  @override
  void navigateToUrl(String url) {
    try {
      web.window.location.href = url;
    } catch (e) {
      debugPrint('Error navigating to URL: $e');
    }
  }

  @override
  void reload() {
    try {
      web.window.location.reload();
    } catch (e) {
      debugPrint('Error reloading page: $e');
    }
  }

  @override
  void cleanupHashUrl() {
    try {
      final currentUrl = web.window.location.href;
      if (currentUrl.contains('#/')) {
        final hashPath = currentUrl.split('#/')[1];
        final cleanPath = '/$hashPath';
        replaceState(cleanPath);
      }
    } catch (e) {
      debugPrint('Error cleaning up hash URL: $e');
    }
  }

  @override
  bool canGoBack() {
    try {
      // This is a simple check - in a real app you might want to track this
      return web.window.history.length > 1;
    } catch (e) {
      debugPrint('Error checking if can go back: $e');
      return false;
    }
  }

  @override
  int get historyLength {
    try {
      return web.window.history.length;
    } catch (e) {
      debugPrint('Error getting history length: $e');
      return 0;
    }
  }

  @override
  void dispose() {
    if (_popstateListener != null) {
      web.window.removeEventListener('popstate', _popstateListener!);
      _popstateListener = null;
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

/// Factory function for web platform
WebHistoryManagerInterface createWebHistoryManager() {
  return WebHistoryManagerWeb();
}
