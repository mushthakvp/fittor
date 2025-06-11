// lib/fitroute/utils/platform_utils_web.dart

import 'package:flutter/foundation.dart';

import '../web/index.dart';
import 'platform_utils_interface.dart';

/// Web-specific implementation of PlatformUtilsInterface
class PlatformUtilsWeb implements PlatformUtilsInterface {
  @override
  void updateUrl(String path, {bool replace = true}) {
    if (replace) {
      WebHistoryManager.instance.replaceState(path);
    } else {
      WebHistoryManager.instance.pushState(path);
    }
  }

  @override
  void pushUrl(String path) {
    WebHistoryManager.instance.pushState(path);
  }

  @override
  void replaceUrl(String path) {
    WebHistoryManager.instance.replaceState(path);
  }

  @override
  String? getCurrentPath() {
    return WebHistoryManager.instance.currentPath;
  }

  @override
  bool canGoBack() {
    return WebHistoryManager.instance.canGoBack();
  }

  @override
  void goBack() {
    WebHistoryManager.instance.back();
  }

  @override
  void goForward() {
    WebHistoryManager.instance.forward();
  }

  @override
  void platformSpecificInit() {
    debugPrint('Initializing FitRouter for web platform');
    WebHistoryManager.instance.cleanupHashUrl();
  }

  @override
  void handleUrlChange(String initialUrl, Function(String) callback) {
    WebHistoryManager.instance.setupPopstateListener((path) {
      debugPrint('URL changed to: $path');
      callback(path);
    });
  }

  @override
  String getCurrentUrlOrState() {
    return WebHistoryManager.instance.currentUrl;
  }

  @override
  Future<bool> shareContent(String content, {String? subject}) async {
    try {
      // Web sharing logic could be implemented here
      // For now, just return true
      return true;
    } catch (e) {
      debugPrint('Error sharing on web: $e');
      return false;
    }
  }

  @override
  int getHistoryLength() {
    return WebHistoryManager.instance.historyLength;
  }
}

/// Factory function for web platform
PlatformUtilsInterface createPlatformUtils() {
  return PlatformUtilsWeb();
}
