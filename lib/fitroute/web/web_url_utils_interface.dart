// lib/fitroute/web/web_url_utils_interface.dart

import '../core/index.dart';

/// Abstract interface for web URL utilities
abstract class WebUrlUtilsInterface {
  ParsedRoute? parseCurrentUrl(Map<String, FitRoute> routes);
  ParsedRoute? parseUrlPath(String path, Map<String, FitRoute> routes);
  String generateUrl(String routeName, FitRoute route,
      [Map<String, dynamic>? parameters]);
  String getBaseUrl();
  String buildFullUrl(String path);
  bool isPageRefresh();
  String getReferrer();
  bool isExternalUrl(String url);
  Map<String, String> getCurrentQueryParameters();
  Map<String, String> parseQueryString(String queryString);
  String buildQueryString(Map<String, String> params);
  bool supportsHistoryApi();
  String getPageTitle();
  void setPageTitle(String title);
  void updateMetaDescription(String description);
  void updateMetaTag(String name, String content);
}

/// Factory function - will be implemented by platform-specific files
WebUrlUtilsInterface createWebUrlUtils() {
  throw UnsupportedError('No implementation available for this platform');
}
