// lib/fitroute/storage/state_persistence_web.dart

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import 'storage_interface.dart';

/// Web-based storage using browser's localStorage/sessionStorage
class WebStorage implements IStorage {
  static const String _storagePrefix = 'fitrouter_';

  /// Use localStorage for persistent storage
  bool get _isLocalStorageAvailable {
    try {
      if (!kIsWeb) return false;
      final localStorage = web.window.localStorage;
      localStorage.setItem('test', 'test');
      localStorage.removeItem('test');
      return true;
    } catch (e) {
      debugPrint('localStorage not available: $e');
      return false;
    }
  }

  /// Use sessionStorage as fallback
  bool get _isSessionStorageAvailable {
    try {
      if (!kIsWeb) return false;
      final sessionStorage = web.window.sessionStorage;
      sessionStorage.setItem('test', 'test');
      sessionStorage.removeItem('test');
      return true;
    } catch (e) {
      debugPrint('sessionStorage not available: $e');
      return false;
    }
  }

  /// Get the appropriate storage mechanism
  web.Storage? get _storage {
    if (_isLocalStorageAvailable) {
      return web.window.localStorage;
    } else if (_isSessionStorageAvailable) {
      return web.window.sessionStorage;
    }
    return null;
  }

  String _prefixKey(String key) => _storagePrefix + key;

  @override
  Future<String?> get(String key) async {
    if (!kIsWeb) return null;

    try {
      final storage = _storage;
      if (storage != null) {
        return storage.getItem(_prefixKey(key));
      }
    } catch (e) {
      debugPrint('Error getting value from web storage: $e');
    }

    return null;
  }

  @override
  Future<void> set(String key, String value) async {
    if (!kIsWeb) return;

    try {
      final storage = _storage;
      if (storage != null) {
        storage.setItem(_prefixKey(key), value);
      }
    } catch (e) {
      debugPrint('Error setting value in web storage: $e');
    }
  }

  @override
  Future<void> remove(String key) async {
    if (!kIsWeb) return;

    try {
      final storage = _storage;
      if (storage != null) {
        storage.removeItem(_prefixKey(key));
      }
    } catch (e) {
      debugPrint('Error removing value from web storage: $e');
    }
  }

  @override
  Future<void> clear() async {
    if (!kIsWeb) return;

    try {
      final keys = await getAllKeys();
      for (final key in keys) {
        await remove(key.substring(_storagePrefix.length));
      }
    } catch (e) {
      debugPrint('Error clearing web storage: $e');
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    if (!kIsWeb) return false;

    try {
      final storage = _storage;
      if (storage != null) {
        return storage.getItem(_prefixKey(key)) != null;
      }
    } catch (e) {
      debugPrint('Error checking key in web storage: $e');
    }

    return false;
  }

  @override
  Future<List<String>> getAllKeys() async {
    if (!kIsWeb) return [];

    try {
      final storage = _storage;
      if (storage != null) {
        final keys = <String>[];
        for (int i = 0; i < storage.length; i++) {
          final key = storage.key(i);
          if (key != null && key.startsWith(_storagePrefix)) {
            keys.add(key);
          }
        }
        return keys;
      }
    } catch (e) {
      debugPrint('Error getting all keys from web storage: $e');
    }

    return [];
  }

  @override
  void dispose() {
    // Web storage doesn't need explicit disposal
  }

  /// Clear all web storage (including non-FitRouter data)
  Future<void> clearAllWebStorage() async {
    if (!kIsWeb) return;

    try {
      final storage = _storage;
      if (storage != null) {
        storage.clear();
      }
    } catch (e) {
      debugPrint('Error clearing all web storage: $e');
    }
  }

  /// Get storage size in bytes (approximate)
  Future<int> getStorageSize() async {
    if (!kIsWeb) return 0;

    try {
      final storage = _storage;
      if (storage != null) {
        int totalSize = 0;
        for (int i = 0; i < storage.length; i++) {
          final key = storage.key(i);
          if (key != null && key.startsWith(_storagePrefix)) {
            final value = storage.getItem(key);
            if (value != null) {
              totalSize += key.length + value.length;
            }
          }
        }
        return totalSize;
      }
    } catch (e) {
      debugPrint('Error calculating storage size: $e');
    }

    return 0;
  }

  /// Check storage quota (if available)
  Future<Map<String, dynamic>?> getStorageQuota() async {
    if (!kIsWeb) return null;

    try {
      // This would require additional web API access
      // For now, return basic info
      return {
        'used': await getStorageSize(),
        'available': true,
        'type': _isLocalStorageAvailable ? 'localStorage' : 'sessionStorage',
      };
    } catch (e) {
      debugPrint('Error getting storage quota: $e');
      return null;
    }
  }
}

/// Factory function for web platform
IStorage createStorageImplementation() {
  if (kIsWeb) {
    return WebStorage();
  } else {
    // For mobile platforms, we would typically use SharedPreferences
    // but for this example, we'll use memory storage as fallback
    return MemoryStorage();
  }
}
