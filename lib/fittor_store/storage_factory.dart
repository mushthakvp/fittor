import 'package:flutter/foundation.dart';

import 'implementations/memory_storage.dart';
// Conditional imports based on platform
import 'implementations/mobile_storage.dart'
    if (dart.library.html) 'implementations/web_storage.dart';
import 'platform/platform_info.dart';
import 'storage_interface.dart';

/// Factory class to create appropriate storage implementation
class StorageFactory {
  /// Create storage implementation based on current platform
  static StorageInterface createStorage() {
    try {
      if (PlatformInfo.isWeb) {
        // Use conditional import for web
        return _createWebStorage();
      } else {
        // Use conditional import for mobile/desktop
        return _createMobileStorage();
      }
    } catch (e) {
      debugPrint('Failed to create platform storage: $e');
      debugPrint('Falling back to memory storage');
      return MemoryStorage();
    }
  }

  static StorageInterface _createWebStorage() {
    // This will resolve to WebStorage on web platforms
    return MobileStorage(); // This gets replaced by WebStorage via conditional import
  }

  static StorageInterface _createMobileStorage() {
    // This will resolve to MobileStorage on mobile/desktop platforms
    return MobileStorage();
  }

  /// Get platform name for debugging
  static String get platformName => PlatformInfo.platformName;

  /// Check if persistent storage is supported
  static bool get isPersistentStorageSupported {
    return PlatformInfo.hasFileSystemAccess || PlatformInfo.hasLocalStorage;
  }
}
