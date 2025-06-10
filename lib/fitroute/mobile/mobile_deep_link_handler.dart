import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../core/index.dart';

/// Handles deep linking for mobile platforms
class MobileDeepLinkHandler {
  static MobileDeepLinkHandler? _instance;
  static MobileDeepLinkHandler get instance =>
      _instance ??= MobileDeepLinkHandler._internal();

  MobileDeepLinkHandler._internal();

  static const String _methodChannelName = 'fitrouter/deep_link';
  static const MethodChannel _channel = MethodChannel(_methodChannelName);

  /// Callback for when a deep link is received
  void Function(String link)? _onDeepLink;

  /// Initialize deep link handling
  void initialize({
    void Function(String link)? onDeepLink,
  }) {
    _onDeepLink = onDeepLink;

    if (!kIsWeb) {
      _setupMethodChannelListener();
    }
  }

  /// Set up method channel listener for deep links
  void _setupMethodChannelListener() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  /// Handle method calls from native platforms
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onDeepLink':
        final String? link = call.arguments;
        if (link != null && _onDeepLink != null) {
          _onDeepLink!(link);
        }
        break;
      default:
        debugPrint('Unknown method: ${call.method}');
    }
  }

  /// Parse deep link URL to extract route information
  static ParsedRoute? parseDeepLink(String url, Map<String, FitRoute> routes) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;

      // Extract route from path
      for (final entry in routes.entries) {
        final routeName = entry.key;
        final route = entry.value;

        final parameters = route.extractParameters(path);
        if (parameters != null) {
          // Add query parameters to arguments
          final arguments = Map<String, dynamic>.from(parameters);
          uri.queryParameters.forEach((key, value) {
            arguments[key] = value;
          });

          return ParsedRoute(
            routeName: routeName,
            arguments: arguments,
            originalPath: path,
          );
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error parsing deep link: $e');
      return null;
    }
  }

  /// Generate deep link URL for a route
  static String generateDeepLink(
    String routeName,
    FitRoute route, {
    Map<String, dynamic>? arguments,
    String scheme = 'fitrouter',
    String host = 'app',
  }) {
    try {
      final path = route.generatePath(arguments);
      final uri = Uri(
        scheme: scheme,
        host: host,
        path: path,
      );

      return uri.toString();
    } catch (e) {
      debugPrint('Error generating deep link: $e');
      return '$scheme://$host/';
    }
  }

  /// Check if a URL is a valid deep link for the app
  static bool isValidDeepLink(String url, {String scheme = 'fitrouter'}) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == scheme;
    } catch (e) {
      debugPrint('Error validating deep link: $e');
      return false;
    }
  }

  /// Handle incoming deep link
  void handleDeepLink(String url, Map<String, FitRoute> routes,
      Function(String, Map<String, dynamic>) onNavigate) {
    final parsed = parseDeepLink(url, routes);
    if (parsed != null) {
      onNavigate(parsed.routeName, parsed.arguments);
    } else {
      debugPrint('Could not parse deep link: $url');
    }
  }

  /// Request initial deep link (for app launch)
  Future<String?> getInitialLink() async {
    if (kIsWeb) return null;

    try {
      final String? link = await _channel.invokeMethod('getInitialLink');
      return link;
    } catch (e) {
      debugPrint('Error getting initial link: $e');
      return null;
    }
  }

  /// Share a deep link
  Future<bool> shareDeepLink(String url, {String? subject}) async {
    if (kIsWeb) {
      // For web, try to copy to clipboard or use Web Share API
      return _shareOnWeb(url, subject);
    }

    try {
      await _channel.invokeMethod('shareLink', {
        'url': url,
        'subject': subject,
      });
      return true;
    } catch (e) {
      debugPrint('Error sharing deep link: $e');
      return false;
    }
  }

  /// Share deep link on web platform
  Future<bool> _shareOnWeb(String url, String? subject) async {
    // This would require additional web-specific implementation
    // For now, just copy to clipboard
    try {
      await Clipboard.setData(ClipboardData(text: url));
      return true;
    } catch (e) {
      debugPrint('Error copying link to clipboard: $e');
      return false;
    }
  }

  /// Register URL scheme (for iOS/Android configuration)
  static Map<String, dynamic> getConfigurationGuide({
    String scheme = 'fitrouter',
    String host = 'app',
  }) {
    return {
      'scheme': scheme,
      'host': host,
      'android': {
        'intent_filter': '''
        <intent-filter android:autoVerify="true">
          <action android:name="android.intent.action.VIEW" />
          <category android:name="android.intent.category.DEFAULT" />
          <category android:name="android.intent.category.BROWSABLE" />
          <data android:scheme="$scheme" android:host="$host" />
        </intent-filter>
      ''',
      },
      'ios': {
        'url_scheme': '''
        <key>CFBundleURLTypes</key>
        <array>
          <dict>
            <key>CFBundleURLName</key>
            <string>$scheme</string>
            <key>CFBundleURLSchemes</key>
            <array>
            <string>$scheme</string>
            </array>
          </dict>
        </array>
      ''',
      },
    };
  }

  /// Dispose resources
  void dispose() {
    _onDeepLink = null;
  }
}
