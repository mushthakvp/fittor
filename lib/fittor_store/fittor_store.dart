import 'dart:convert';

import 'package:flutter/widgets.dart';

class FittorStore {
  // In-memory storage map that simulates SharedPreferences
  static Map<String, dynamic> _storage = {};
  static bool _initialized = false;

  // Current timestamp for operations that need it
  static DateTime get now => DateTime.now();

  /// Initialize the FittorStore
  /// Must be called at app start (typically in main.dart)
  static Future<void> init() async {
    try {
      // Load any persistent data here if implementing persistence
      _initialized = true;

      // For now, we're just initializing with an empty map
      _storage = {};
    } catch (e) {
      debugPrint('FittorStore initialization error: $e');
      _storage = {};
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

  /// Reload stored preferences
  static Future<void> reload() async {
    _ensureInitialized();
    // In a real implementation, this would reload from disk
    // For now, this is a no-op
  }

  /// Clear all stored preferences
  static Future<void> clear() async {
    _ensureInitialized();
    _storage.clear();
    return Future.value();
  }

  /// Remove a specific key
  static Future<bool> remove(String key) async {
    _ensureInitialized();
    _storage.remove(key);
    return Future.value(true);
  }

  /// Get all keys
  static Set<String> getKeys() {
    _ensureInitialized();
    return _storage.keys.toSet();
  }

  // String operations
  static String? getString(String key) {
    _ensureInitialized();
    final value = _storage[key];
    return value is String ? value : null;
  }

  static Future<bool> setString(String key, String value) async {
    _ensureInitialized();
    _storage[key] = value;
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
      return value;
    }
    return defaultValue;
  }

  static Future<bool> setValue<T>(String key, T value) async {
    _ensureInitialized();
    _storage[key] = value;
    return Future.value(true);
  }
}
