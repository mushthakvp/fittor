import 'package:flutter/foundation.dart';

import '../core/index.dart';
// Conditional import for web functionality
import 'web_url_utils_interface.dart'
    if (dart.library.js_interop) 'web_url_utils_web.dart'
    if (dart.library.io) 'web_url_utils_stub.dart';

/// Utilities for working with URLs on web platform
class WebUrlUtils {
  static final WebUrlUtilsInterface _implementation = createWebUrlUtils();

  /// Extract route information from current URL
  static ParsedRoute? parseCurrentUrl(Map<String, FitRoute> routes) {
    if (!kIsWeb) return null;
    return _implementation.parseCurrentUrl(routes);
  }

  /// Parse URL path to extract route and parameters
  static ParsedRoute? parseUrlPath(String path, Map<String, FitRoute> routes) {
    return _implementation.parseUrlPath(path, routes);
  }

  /// Generate URL from route name and parameters
  static String generateUrl(String routeName, FitRoute route,
      [Map<String, dynamic>? parameters]) {
    return _implementation.generateUrl(routeName, route, parameters);
  }

  /// Get base URL of the application
  static String getBaseUrl() {
    if (!kIsWeb) return '';
    return _implementation.getBaseUrl();
  }

  /// Build full URL with base URL
  static String buildFullUrl(String path) {
    return _implementation.buildFullUrl(path);
  }

  /// Check if current page was refreshed
  static bool isPageRefresh() {
    if (!kIsWeb) return false;
    return _implementation.isPageRefresh();
  }

  /// Get referrer URL
  static String getReferrer() {
    if (!kIsWeb) return '';
    return _implementation.getReferrer();
  }

  /// Check if URL is external
  static bool isExternalUrl(String url) {
    if (!kIsWeb) return false;
    return _implementation.isExternalUrl(url);
  }

  /// Extract query parameters from current URL
  static Map<String, String> getCurrentQueryParameters() {
    if (!kIsWeb) return {};
    return _implementation.getCurrentQueryParameters();
  }

  /// Parse query string into parameters map
  static Map<String, String> parseQueryString(String queryString) {
    return _implementation.parseQueryString(queryString);
  }

  /// Build query string from parameters
  static String buildQueryString(Map<String, String> params) {
    return _implementation.buildQueryString(params);
  }

  /// Check if browser supports History API
  static bool supportsHistoryApi() {
    if (!kIsWeb) return false;
    return _implementation.supportsHistoryApi();
  }

  /// Get current page title
  static String getPageTitle() {
    if (!kIsWeb) return '';
    return _implementation.getPageTitle();
  }

  /// Set page title
  static void setPageTitle(String title) {
    if (!kIsWeb) return;
    _implementation.setPageTitle(title);
  }

  /// Update meta description
  static void updateMetaDescription(String description) {
    if (!kIsWeb) return;
    _implementation.updateMetaDescription(description);
  }

  /// Add or update meta tag
  static void updateMetaTag(String name, String content) {
    if (!kIsWeb) return;
    _implementation.updateMetaTag(name, content);
  }
}
