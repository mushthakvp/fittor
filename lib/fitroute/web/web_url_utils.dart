import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import '../core/index.dart';

/// Utilities for working with URLs on web platform
class WebUrlUtils {
  /// Extract route information from current URL
  static ParsedRoute? parseCurrentUrl(Map<String, FitRoute> routes) {
    if (!kIsWeb) return null;

    try {
      final path = web.window.location.pathname;
      return parseUrlPath(path, routes);
    } catch (e) {
      debugPrint('Error parsing current URL: $e');
      return null;
    }
  }

  /// Parse URL path to extract route and parameters
  static ParsedRoute? parseUrlPath(String path, Map<String, FitRoute> routes) {
    // Try to match against each route
    for (final entry in routes.entries) {
      final routeName = entry.key;
      final route = entry.value;

      final parameters = route.extractParameters(path);
      if (parameters != null) {
        return ParsedRoute(
          routeName: routeName,
          arguments: parameters,
          originalPath: path,
        );
      }
    }

    return null;
  }

  /// Generate URL from route name and parameters
  static String generateUrl(String routeName, FitRoute route,
      [Map<String, dynamic>? parameters]) {
    try {
      final path = route.generatePath(parameters);
      return path.startsWith('/') ? path : '/$path';
    } catch (e) {
      debugPrint('Error generating URL for route $routeName: $e');
      return '/';
    }
  }

  /// Get base URL of the application
  static String getBaseUrl() {
    if (!kIsWeb) return '';

    try {
      final location = web.window.location;
      return '${location.protocol}//${location.host}';
    } catch (e) {
      debugPrint('Error getting base URL: $e');
      return '';
    }
  }

  /// Build full URL with base URL
  static String buildFullUrl(String path) {
    final baseUrl = getBaseUrl();
    if (baseUrl.isEmpty) return path;

    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$cleanPath';
  }

  /// Check if current page was refreshed
  static bool isPageRefresh() {
    if (!kIsWeb) return false;

    try {
      // Check if navigation type indicates a reload
      final performance = web.window.performance;
      return performance.navigation.type == 1;
    } catch (e) {
      debugPrint('Error checking page refresh status: $e');
      return false;
    }
  }

  /// Get referrer URL
  static String getReferrer() {
    if (!kIsWeb) return '';

    try {
      return web.document.referrer;
    } catch (e) {
      debugPrint('Error getting referrer: $e');
      return '';
    }
  }

  /// Check if URL is external
  static bool isExternalUrl(String url) {
    if (!kIsWeb) return false;

    try {
      final uri = Uri.parse(url);
      final currentHost = web.window.location.hostname;

      return uri.hasScheme && uri.host != currentHost;
    } catch (e) {
      debugPrint('Error checking if URL is external: $e');
      return false;
    }
  }

  /// Extract query parameters from current URL
  static Map<String, String> getCurrentQueryParameters() {
    if (!kIsWeb) return {};

    try {
      final search = web.window.location.search;
      return parseQueryString(search);
    } catch (e) {
      debugPrint('Error getting query parameters: $e');
      return {};
    }
  }

  /// Parse query string into parameters map
  static Map<String, String> parseQueryString(String queryString) {
    if (queryString.isEmpty || !queryString.startsWith('?')) {
      return {};
    }

    final params = <String, String>{};
    final pairs = queryString.substring(1).split('&');

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
  static String buildQueryString(Map<String, String> params) {
    if (params.isEmpty) return '';

    final pairs = params.entries.map((entry) {
      final key = Uri.encodeComponent(entry.key);
      final value = Uri.encodeComponent(entry.value);
      return '$key=$value';
    });

    return '?${pairs.join('&')}';
  }

  /// Check if browser supports History API
  static bool supportsHistoryApi() {
    if (!kIsWeb) return false;

    try {
      // Fixed: Removed unnecessary null comparison
      return true; // History API is supported in all modern browsers
    } catch (e) {
      debugPrint('History API not supported: $e');
      return false;
    }
  }

  /// Get current page title
  static String getPageTitle() {
    if (!kIsWeb) return '';

    try {
      return web.document.title;
    } catch (e) {
      debugPrint('Error getting page title: $e');
      return '';
    }
  }

  /// Set page title
  static void setPageTitle(String title) {
    if (!kIsWeb) return;

    try {
      web.document.title = title;
    } catch (e) {
      debugPrint('Error setting page title: $e');
    }
  }

  /// Update meta description
  static void updateMetaDescription(String description) {
    if (!kIsWeb) return;

    try {
      final metaDesc = web.document.querySelector('meta[name="description"]')
          as web.HTMLMetaElement?;
      if (metaDesc != null) {
        metaDesc.content = description;
      }
    } catch (e) {
      debugPrint('Error updating meta description: $e');
    }
  }

  /// Add or update meta tag
  static void updateMetaTag(String name, String content) {
    if (!kIsWeb) return;

    try {
      var meta = web.document.querySelector('meta[name="$name"]')
          as web.HTMLMetaElement?;

      if (meta == null) {
        meta = web.document.createElement('meta') as web.HTMLMetaElement;
        meta.name = name;
        web.document.head?.appendChild(meta);
      }

      meta.content = content;
    } catch (e) {
      debugPrint('Error updating meta tag: $e');
    }
  }
}
