// lib/fitroute/utils/platform_utils.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/index.dart';
import '../mobile/index.dart';
// Conditional imports for platform-specific utilities
import 'platform_utils_interface.dart'
    if (dart.library.js_interop) 'platform_utils_web.dart'
    if (dart.library.io) 'platform_utils_stub.dart';

/// Platform-specific utilities with improved browser integration
class PlatformUtils {
  static final PlatformUtilsInterface _implementation = createPlatformUtils();

  /// Update URL with proper browser history management
  static void updateUrl(String path, {bool replace = true}) {
    _implementation.updateUrl(path, replace: replace);
  }

  /// Push new URL to browser history
  static void pushUrl(String path) {
    _implementation.pushUrl(path);
  }

  /// Replace current URL in browser history
  static void replaceUrl(String path) {
    _implementation.replaceUrl(path);
  }

  /// Get current path (web only)
  static String? getCurrentPath() {
    return _implementation.getCurrentPath();
  }

  /// Check if browser can go back
  static bool canGoBack() {
    return _implementation.canGoBack();
  }

  /// Go back in browser history
  static void goBack() {
    _implementation.goBack();
  }

  /// Go forward in browser history
  static void goForward() {
    _implementation.goForward();
  }

  /// Generate deep link based on platform
  static String generateDeepLink(String routeName,
      {Map<String, dynamic>? arguments}) {
    if (kIsWeb) {
      final path = _routeNameToPath(routeName);
      return path;
    } else {
      return MobileDeepLinkHandler.generateDeepLink(
        routeName,
        FitRoute(path: '/$routeName', builder: (_, __) => const SizedBox()),
        arguments: arguments,
      );
    }
  }

  /// Parse deep link based on platform
  static ParsedRoute? parseDeepLink(String url) {
    if (kIsWeb) {
      return null; // Would be handled by web router
    } else {
      return MobileDeepLinkHandler.parseDeepLink(url, {});
    }
  }

  /// Check if platform supports browser history
  static bool supportsBrowserHistory() {
    return kIsWeb;
  }

  /// Check if platform supports deep linking
  static bool supportsDeepLinking() {
    return !kIsWeb;
  }

  /// Get platform name
  static String getPlatformName() {
    if (kIsWeb) {
      return 'web';
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return 'android';
        case TargetPlatform.iOS:
          return 'ios';
        case TargetPlatform.macOS:
          return 'macos';
        case TargetPlatform.windows:
          return 'windows';
        case TargetPlatform.linux:
          return 'linux';
        case TargetPlatform.fuchsia:
          return 'fuchsia';
      }
    }
  }

  /// Check if platform is mobile
  static bool isMobile() {
    return !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
  }

  /// Check if platform is desktop
  static bool isDesktop() {
    return !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux);
  }

  /// Check if platform is web
  static bool isWeb() {
    return kIsWeb;
  }

  /// Get platform-specific storage key prefix
  static String getStorageKeyPrefix() {
    return 'fitrouter_${getPlatformName()}_';
  }

  /// Handle platform-specific initialization
  static void platformSpecificInit() {
    _implementation.platformSpecificInit();
  }

  /// Get platform capabilities
  static Map<String, bool> getPlatformCapabilities() {
    return {
      'browserHistory': supportsBrowserHistory(),
      'deepLinking': supportsDeepLinking(),
      'localStorage': kIsWeb,
      'sessionStorage': kIsWeb,
      'pushNotifications': isMobile(),
      'fileSystem': !kIsWeb,
      'clipboard': true,
      'systemBack': defaultTargetPlatform == TargetPlatform.android,
    };
  }

  /// Get platform-specific route configuration
  static Map<String, dynamic> getPlatformRouteConfig() {
    return {
      'platform': getPlatformName(),
      'supportsHistory': supportsBrowserHistory(),
      'supportsDeepLink': supportsDeepLinking(),
      'persistenceType': kIsWeb ? 'localStorage' : 'memory',
      'transitionType': isMobile() ? 'platform' : 'fade',
    };
  }

  /// Handle platform-specific URL changes with improved browser integration
  static void handleUrlChange(String initialUrl, Function(String) callback) {
    _implementation.handleUrlChange(initialUrl, callback);
  }

  /// Get current URL or route state
  static String getCurrentUrlOrState() {
    return _implementation.getCurrentUrlOrState();
  }

  /// Share content based on platform
  static Future<bool> shareContent(String content, {String? subject}) async {
    return _implementation.shareContent(content, subject: subject);
  }

  /// Get platform-specific error message
  static String getPlatformErrorMessage(String baseMessage) {
    final platform = getPlatformName();
    return '$baseMessage (Platform: $platform)';
  }

  /// Check if feature is supported on current platform
  static bool isFeatureSupported(String feature) {
    final capabilities = getPlatformCapabilities();
    return capabilities[feature] ?? false;
  }

  /// Get platform-specific debug info
  static Map<String, dynamic> getDebugInfo() {
    return {
      'platform': getPlatformName(),
      'isWeb': kIsWeb,
      'isMobile': isMobile(),
      'isDesktop': isDesktop(),
      'capabilities': getPlatformCapabilities(),
      'currentUrl': getCurrentUrlOrState(),
      'canGoBack': canGoBack(),
      'historyLength': _implementation.getHistoryLength(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Convert route name to URL path
  static String _routeNameToPath(String routeName) {
    final kebabCase = routeName
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'),
            (match) => '${match.group(1)}-${match.group(2)?.toLowerCase()}')
        .toLowerCase();

    return '/$kebabCase';
  }

  /// Convert URL path to route name
  static String pathToRouteName(String path) {
    final cleanPath = path.replaceFirst(RegExp(r'^/+'), '');
    if (cleanPath.isEmpty) return 'home';

    final camelCase = cleanPath
        .split('-')
        .asMap()
        .entries
        .map((entry) => entry.key == 0
            ? entry.value
            : entry.value[0].toUpperCase() + entry.value.substring(1))
        .join('');

    return camelCase;
  }
}
