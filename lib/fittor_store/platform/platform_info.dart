import 'package:flutter/foundation.dart';

/// Platform information utility
class PlatformInfo {
  /// Check if running on web
  static bool get isWeb => kIsWeb;

  /// Check if running on mobile (iOS/Android)
  static bool get isMobile => !kIsWeb && (isAndroid || isIOS);

  /// Check if running on desktop (Windows/macOS/Linux)
  static bool get isDesktop => !kIsWeb && (isWindows || isMacOS || isLinux);

  /// Platform-specific checks (these will be true/false based on compilation target)
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isWindows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
  static bool get isMacOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isLinux =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

  /// Get platform name
  static String get platformName {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isWindows) return 'Windows';
    if (isMacOS) return 'macOS';
    if (isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Check if file system access is likely available
  static bool get hasFileSystemAccess => !isWeb;

  /// Check if localStorage is likely available
  static bool get hasLocalStorage => isWeb;
}
