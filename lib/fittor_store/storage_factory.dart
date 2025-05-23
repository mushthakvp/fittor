import 'package:flutter/foundation.dart';

import 'mobile_storage.dart';
import 'storage_interface.dart';
import 'web_storage.dart';

/// Factory class to create appropriate storage implementation based on platform
class StorageFactory {
  /// Create storage implementation based on current platform
  static StorageInterface createStorage() {
    if (kIsWeb) {
      return WebStorage();
    } else {
      return MobileStorage();
    }
  }

  /// Get platform name for debugging
  static String get platformName {
    if (kIsWeb) {
      return 'Web';
    } else {
      return 'Mobile/Desktop';
    }
  }
}
