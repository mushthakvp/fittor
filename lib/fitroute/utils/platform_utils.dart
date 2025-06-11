// lib/fitroute/utils/platform_utils.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/index.dart';
import '../mobile/index.dart';
import '../web/index.dart';

/// Platform-specific utilities with improved browser integration
class PlatformUtils {
  /// Update URL with proper browser history management
  static void updateUrl(String path, {bool replace = true}) {
    if (kIsWeb) {
      if (replace) {
        WebHistoryManager.instance.replaceState(path);
      } else {
        WebHistoryManager.instance.pushState(path);
      }
    }
  }

  /// Push new URL to browser history
  static void pushUrl(String path) {
    if (kIsWeb) {
      WebHistoryManager.instance.pushState(path);
    }
  }

  /// Replace current URL in browser history
  static void replaceUrl(String path) {
    if (kIsWeb) {
      WebHistoryManager.instance.replaceState(path);
    }
  }

  /// Get current path (web only)
  static String? getCurrentPath() {
    if (kIsWeb) {
      return WebHistoryManager.instance.currentPath;
    }
    return null;
  }

  /// Check if browser can go back
  static bool canGoBack() {
    if (kIsWeb) {
      return WebHistoryManager.instance.canGoBack();
    }
    return false;
  }

  /// Go back in browser history
  static void goBack() {
    if (kIsWeb) {
      WebHistoryManager.instance.back();
    }
  }

  /// Go forward in browser history
  static void goForward() {
    if (kIsWeb) {
      WebHistoryManager.instance.forward();
    }
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
    if (kIsWeb) {
      debugPrint('Initializing FitRouter for web platform');
      WebHistoryManager.instance.cleanupHashUrl();
    } else {
      debugPrint('Initializing FitRouter for ${getPlatformName()} platform');
    }
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
    if (kIsWeb) {
      WebHistoryManager.instance.setupPopstateListener((path) {
        debugPrint('URL changed to: $path');
        callback(path);
      });
    } else {
      MobileDeepLinkHandler.instance.initialize(
        onDeepLink: (link) {
          callback(link);
        },
      );
    }
  }

  /// Get current URL or route state
  static String getCurrentUrlOrState() {
    if (kIsWeb) {
      return WebHistoryManager.instance.currentUrl;
    } else {
      return 'mobile://current';
    }
  }

  /// Share content based on platform
  static Future<bool> shareContent(String content, {String? subject}) async {
    if (kIsWeb) {
      try {
        return true;
      } catch (e) {
        debugPrint('Error sharing on web: $e');
        return false;
      }
    } else {
      return await MobileDeepLinkHandler.instance
          .shareDeepLink(content, subject: subject);
    }
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
      'historyLength': kIsWeb ? WebHistoryManager.instance.historyLength : 0,
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
