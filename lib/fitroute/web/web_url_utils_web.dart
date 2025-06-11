// lib/fitroute/web/web_url_utils_web.dart
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import '../core/index.dart';
import 'web_url_utils_interface.dart';

/// Web-specific implementation of WebUrlUtilsInterface
class WebUrlUtilsWeb implements WebUrlUtilsInterface {
  @override
  ParsedRoute? parseCurrentUrl(Map<String, FitRoute> routes) {
    try {
      final path = web.window.location.pathname;
      return parseUrlPath(path, routes);
    } catch (e) {
      debugPrint('Error parsing current URL: $e');
      return null;
    }
  }

  @override
  ParsedRoute? parseUrlPath(String path, Map<String, FitRoute> routes) {
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

  @override
  String generateUrl(String routeName, FitRoute route,
      [Map<String, dynamic>? parameters]) {
    try {
      final path = route.generatePath(parameters);
      return path.startsWith('/') ? path : '/$path';
    } catch (e) {
      debugPrint('Error generating URL for route $routeName: $e');
      return '/';
    }
  }

  @override
  String getBaseUrl() {
    try {
      final location = web.window.location;
      return '${location.protocol}//${location.host}';
    } catch (e) {
      debugPrint('Error getting base URL: $e');
      return '';
    }
  }

  @override
  String buildFullUrl(String path) {
    final baseUrl = getBaseUrl();
    if (baseUrl.isEmpty) return path;

    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$cleanPath';
  }

  @override
  bool isPageRefresh() {
    try {
      // Check if navigation type indicates a reload
      final performance = web.window.performance;
      return performance.navigation.type == 1;
    } catch (e) {
      debugPrint('Error checking page refresh status: $e');
      return false;
    }
  }

  @override
  String getReferrer() {
    try {
      return web.document.referrer;
    } catch (e) {
      debugPrint('Error getting referrer: $e');
      return '';
    }
  }

  @override
  bool isExternalUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final currentHost = web.window.location.hostname;

      return uri.hasScheme && uri.host != currentHost;
    } catch (e) {
      debugPrint('Error checking if URL is external: $e');
      return false;
    }
  }

  @override
  Map<String, String> getCurrentQueryParameters() {
    try {
      final search = web.window.location.search;
      return parseQueryString(search);
    } catch (e) {
      debugPrint('Error getting query parameters: $e');
      return {};
    }
  }

  @override
  Map<String, String> parseQueryString(String queryString) {
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
  bool supportsHistoryApi() {
    try {
      // History API is supported in all modern browsers
      return true;
    } catch (e) {
      debugPrint('History API not supported: $e');
      return false;
    }
  }

  @override
  String getPageTitle() {
    try {
      return web.document.title;
    } catch (e) {
      debugPrint('Error getting page title: $e');
      return '';
    }
  }

  @override
  void setPageTitle(String title) {
    try {
      web.document.title = title;
    } catch (e) {
      debugPrint('Error setting page title: $e');
    }
  }

  @override
  void updateMetaDescription(String description) {
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

  @override
  void updateMetaTag(String name, String content) {
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

/// Factory function for web platform
WebUrlUtilsInterface createWebUrlUtils() {
  return WebUrlUtilsWeb();
}
