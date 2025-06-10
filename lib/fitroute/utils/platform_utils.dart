import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/index.dart';
import '../web/index.dart';
import '../mobile/index.dart';

/// Platform-specific utilities
class PlatformUtils {
  /// Update URL (web only)
  static void updateUrl(String path) {
    if (kIsWeb) {
      WebHistoryManager.instance.updateUrl(path);
    }
  }

  /// Get current path (web only)
  static String? getCurrentPath() {
    if (kIsWeb) {
      return WebHistoryManager.instance.currentPath;
    }
    return null;
  }

  /// Generate deep link based on platform
  static String generateDeepLink(String routeName,
      {Map<String, dynamic>? arguments}) {
    if (kIsWeb) {
      // For web, return the URL path
      return '/$routeName';
    } else {
      // For mobile, return deep link URL
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
      // For web, parse as URL path
      return null; // Would be handled by web router
    } else {
      // For mobile, parse as deep link
      return MobileDeepLinkHandler.parseDeepLink(url, {});
    }
  }

  /// Check if platform supports browser history
  static bool supportsBrowserHistory() {
    return kIsWeb;
  }

  /// Check if platform supports deep linking
  static bool supportsDeepLinking() {
    return !kIsWeb; // Mobile platforms support deep linking
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
      // Web-specific initialization
      debugPrint('Initializing FitRouter for web platform');
    } else {
      // Mobile-specific initialization
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

  /// Handle platform-specific URL changes
  static void handleUrlChange(String url, Function(String) callback) {
    if (kIsWeb) {
      WebHistoryManager.instance.setupPopstateListener((path) {
        callback(path);
      });
    } else {
      // For mobile, handle through deep link mechanism
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
      // Web sharing implementation
      try {
        // This would use Web Share API or fallback to clipboard
        return true;
      } catch (e) {
        debugPrint('Error sharing on web: $e');
        return false;
      }
    } else {
      // Mobile sharing implementation
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
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
