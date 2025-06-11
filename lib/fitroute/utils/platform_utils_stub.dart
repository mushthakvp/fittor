// lib/fitroute/utils/platform_utils_stub.dart

import 'package:flutter/foundation.dart';

import '../mobile/index.dart';
import 'platform_utils_interface.dart';

/// Stub implementation for mobile platforms
class PlatformUtilsStub implements PlatformUtilsInterface {
  @override
  void updateUrl(String path, {bool replace = true}) {
    // No-op for mobile platforms
  }

  @override
  void pushUrl(String path) {
    // No-op for mobile platforms
  }

  @override
  void replaceUrl(String path) {
    // No-op for mobile platforms
  }

  @override
  String? getCurrentPath() {
    return null;
  }

  @override
  bool canGoBack() {
    return false;
  }

  @override
  void goBack() {
    // No-op for mobile platforms
  }

  @override
  void goForward() {
    // No-op for mobile platforms
  }

  @override
  void platformSpecificInit() {
    debugPrint('Initializing FitRouter for ${_getPlatformName()} platform');
  }

  @override
  void handleUrlChange(String initialUrl, Function(String) callback) {
    MobileDeepLinkHandler.instance.initialize(
      onDeepLink: (link) {
        callback(link);
      },
    );
  }

  @override
  String getCurrentUrlOrState() {
    return 'mobile://current';
  }

  @override
  Future<bool> shareContent(String content, {String? subject}) async {
    return await MobileDeepLinkHandler.instance
        .shareDeepLink(content, subject: subject);
  }

  @override
  int getHistoryLength() {
    return 0;
  }

  /// Get platform name for mobile platforms
  String _getPlatformName() {
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

/// Factory function for mobile platforms
PlatformUtilsInterface createPlatformUtils() {
  return PlatformUtilsStub();
}
