// lib/fitroute/web/web_url_utils_stub.dart

import '../core/index.dart';
import 'web_url_utils_interface.dart';

/// Stub implementation for mobile platforms
class WebUrlUtilsStub implements WebUrlUtilsInterface {
  @override
  ParsedRoute? parseCurrentUrl(Map<String, FitRoute> routes) {
    return null;
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
      return '/';
    }
  }

  @override
  String getBaseUrl() {
    return '';
  }

  @override
  String buildFullUrl(String path) {
    return path;
  }

  @override
  bool isPageRefresh() {
    return false;
  }

  @override
  String getReferrer() {
    return '';
  }

  @override
  bool isExternalUrl(String url) {
    return false;
  }

  @override
  Map<String, String> getCurrentQueryParameters() {
    return {};
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
    return false;
  }

  @override
  String getPageTitle() {
    return '';
  }

  @override
  void setPageTitle(String title) {
    // No-op for mobile platforms
  }

  @override
  void updateMetaDescription(String description) {
    // No-op for mobile platforms
  }

  @override
  void updateMetaTag(String name, String content) {
    // No-op for mobile platforms
  }
}

/// Factory function for mobile platforms
WebUrlUtilsInterface createWebUrlUtils() {
  return WebUrlUtilsStub();
}
