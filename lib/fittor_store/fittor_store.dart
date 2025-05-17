import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'persistent_storage.dart';
import 'secure_storage.dart';

class FittorStore {
  // In-memory storage map
  static Map<String, dynamic> _storage = {};
  static bool _initialized = false;

  // Persistent storage handler
  static final PersistentStorage _persistentStorage = PersistentStorage();

  // Secure storage handler
  static final SecureStorage _secureStorage = SecureStorage();

  // Auto-save configuration
  static bool _autoSave = true;
  static Timer? _autoSaveTimer;
  static const Duration _autoSaveDuration = Duration(seconds: 5);

  // Current timestamp for operations that need it
  static DateTime get now => DateTime.now();

  /// Initialize the FittorStore
  /// Must be called at app start (typically in main.dart)
  static Future<void> init({bool autoSave = true}) async {
    if (_initialized) return;

    try {
      _autoSave = autoSave;

      // Initialize secure storage first (which should always work)
      await _secureStorage.init();
      debugPrint('Secure storage initialized successfully');

      // Initialize persistent storage (which might fail if file access is restricted)
      try {
        await _persistentStorage.init();
        debugPrint('Persistent storage initialized successfully');

        // Load data from persistent storage
        _storage = await _persistentStorage.loadData();
      } catch (e) {
        debugPrint('Warning: Persistent storage initialization failed: $e');
        debugPrint(
          'Using in-memory storage only (data will not persist between app runs)',
        );
        _storage = {};
      }

      // Set up auto-save timer if enabled
      if (_autoSave) {
        _autoSaveTimer = Timer.periodic(_autoSaveDuration, (_) => save());
      }

      _initialized = true;
      debugPrint('FittorStore initialized successfully');
    } catch (e) {
      debugPrint('FittorStore initialization error: $e');
      _storage = {};
      _initialized = false;
      rethrow;
    }
  }

  /// Check if FittorStore is initialized
  static bool get isInitialized => _initialized;

  /// Ensures FittorStore is initialized before any operation
  static void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'FittorStore not initialized. Call FittorStore.init() first.',
      );
    }
  }

  /// Save the current state to persistent storage
  static Future<void> save() async {
    if (!_initialized) {
      debugPrint(
        'Warning: Attempted to save when FittorStore is not initialized',
      );
      return;
    }

    try {
      await _persistentStorage.saveData(_storage);
    } catch (e) {
      debugPrint('Error saving data: $e');
      // Continue execution - we don't want to crash the app for storage errors
    }
  }

  /// Reload stored preferences from persistent storage
  static Future<void> reload() async {
    _ensureInitialized();
    try {
      _storage = await _persistentStorage.loadData();
    } catch (e) {
      debugPrint('Error reloading data: $e');
    }
  }

  /// Clear all stored preferences
  static Future<void> clear() async {
    _ensureInitialized();
    _storage.clear();
    try {
      await _persistentStorage.clearData();
    } catch (e) {
      debugPrint('Error clearing persistent storage: $e');
    }
  }

  /// Remove a specific key
  static Future<bool> remove(String key) async {
    _ensureInitialized();
    _storage.remove(key);

    if (_autoSave) {
      await save();
    }

    return Future.value(true);
  }

  /// Get all keys
  static Set<String> getKeys() {
    _ensureInitialized();
    return _storage.keys.toSet();
  }

  /// Process the value before storing
  /// Encrypts sensitive data automatically
  static dynamic _processValueForStorage(String key, dynamic value) {
    if (value == null) return null;

    if (value is String && _secureStorage.shouldEncrypt(key)) {
      try {
        return _secureStorage.encrypt(value);
      } catch (e) {
        debugPrint('Error encrypting value for key $key: $e');
        return value; // Store unencrypted as fallback
      }
    }

    return value;
  }

  /// Process the value after retrieving
  /// Decrypts sensitive data automatically
  static dynamic _processValueFromStorage(String key, dynamic value) {
    if (value == null) return null;

    if (value is String && _secureStorage.shouldEncrypt(key)) {
      try {
        return _secureStorage.decrypt(value);
      } catch (e) {
        debugPrint('Error decrypting value for key $key: $e');
        return value; // Return encrypted value as fallback
      }
    }

    return value;
  }

  // String operations
  static String? getString(String key) {
    _ensureInitialized();
    final value = _storage[key];
    if (value is String) {
      return _processValueFromStorage(key, value) as String?;
    }
    return null;
  }

  static Future<bool> setString(String key, String value) async {
    _ensureInitialized();
    _storage[key] = _processValueForStorage(key, value);

    if (_autoSave) {
      await save();
    }

    return Future.value(true);
  }

  // Integer operations
  static int? getInt(String key) {
    _ensureInitialized();
    final value = _storage[key];
    return value is int ? value : null;
  }

  static Future<bool> setInt(String key, int value) async {
    _ensureInitialized();
    _storage[key] = value;

    if (_autoSave) {
      await save();
    }

    return Future.value(true);
  }

  // Double operations
  static double? getDouble(String key) {
    _ensureInitialized();
    final value = _storage[key];
    return value is double ? value : null;
  }

  static Future<bool> setDouble(String key, double value) async {
    _ensureInitialized();
    _storage[key] = value;

    if (_autoSave) {
      await save();
    }

    return Future.value(true);
  }

  // Boolean operations
  static bool? getBool(String key) {
    _ensureInitialized();
    final value = _storage[key];
    return value is bool ? value : null;
  }

  static Future<bool> setBool(String key, bool value) async {
    _ensureInitialized();
    _storage[key] = value;

    if (_autoSave) {
      await save();
    }

    return Future.value(true);
  }

  // List<String> operations
  static List<String>? getStringList(String key) {
    _ensureInitialized();
    final value = _storage[key];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return null;
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    _ensureInitialized();
    _storage[key] = value;

    if (_autoSave) {
      await save();
    }

    return Future.value(true);
  }

  // DateTime operations
  static DateTime? getDateTime(String key) {
    _ensureInitialized();
    final value = _storage[key];
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Future<bool> setDateTime(String key, DateTime value) async {
    _ensureInitialized();
    _storage[key] = value.toIso8601String();

    if (_autoSave) {
      await save();
    }

    return Future.value(true);
  }

  // JSON operations
  static Map<String, dynamic>? getJson(String key) {
    _ensureInitialized();
    final value = getString(key);
    if (value != null) {
      try {
        return jsonDecode(value) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    _ensureInitialized();
    try {
      final jsonString = jsonEncode(value);
      return setString(key, jsonString);
    } catch (_) {
      return Future.value(false);
    }
  }

  // Dynamic access
  static T? getValue<T>(String key, {T? defaultValue}) {
    _ensureInitialized();
    final value = _storage[key];
    if (value is T) {
      if (value is String && _secureStorage.shouldEncrypt(key)) {
        return _processValueFromStorage(key, value) as T?;
      }
      return value;
    }
    return defaultValue;
  }

  static Future<bool> setValue<T>(String key, T value) async {
    _ensureInitialized();

    if (value is String && _secureStorage.shouldEncrypt(key)) {
      _storage[key] = _processValueForStorage(key, value);
    } else {
      _storage[key] = value;
    }

    if (_autoSave) {
      await save();
    }

    return Future.value(true);
  }

  /// Create a backup of the store
  static Future<String?> createBackup() async {
    _ensureInitialized();
    try {
      final backupFile = await _persistentStorage.backup();
      return backupFile?.path;
    } catch (e) {
      debugPrint('Error creating backup: $e');
      return null;
    }
  }

  /// Get the size of the stored data in bytes
  static Future<int> getSize() async {
    _ensureInitialized();
    try {
      return _persistentStorage.getSize();
    } catch (e) {
      debugPrint('Error getting store size: $e');
      return 0;
    }
  }

  /// Rotate the encryption key for added security
  /// This will re-encrypt all sensitive data with a new key
  static Future<void> rotateEncryptionKey() async {
    _ensureInitialized();

    // Store keys that need re-encryption
    final keysToReencrypt = <String, String>{};

    // Find all sensitive keys
    for (final key in _storage.keys) {
      if (_storage[key] is String && _secureStorage.shouldEncrypt(key)) {
        final decryptedValue = getString(key);
        if (decryptedValue != null) {
          keysToReencrypt[key] = decryptedValue;
        }
      }
    }

    // Rotate the key
    await _secureStorage.rotateKey();

    // Re-encrypt all sensitive values with the new key
    for (final entry in keysToReencrypt.entries) {
      await setString(entry.key, entry.value);
    }

    // Save changes
    await save();
  }

  /// Dispose resources used by FittorStore
  static void dispose() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
    _initialized = false;
  }
}
