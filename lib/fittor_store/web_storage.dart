import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';

import 'storage_interface.dart';

/// Web-specific storage implementation using localStorage
class WebStorage implements StorageInterface {
  static const String _storageKey = 'fittor_store_data';
  static const String _backupPrefix = 'fittor_store_backup_';

  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;

    try {
      // Check if localStorage is available
      _initialized = true;
      debugPrint('WebStorage initialized successfully');
    } catch (e) {
      debugPrint('WebStorage init error: $e');
      _initialized = false;
      rethrow;
    }
  }

  @override
  bool get isInitialized => _initialized;

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('WebStorage not initialized. Call init() first.');
    }
  }

  @override
  Future<Map<String, dynamic>> loadData() async {
    _ensureInitialized();

    try {
      final jsonString = html.window.localStorage[_storageKey];
      if (jsonString == null || jsonString.isEmpty) {
        return {};
      }

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error loading web storage data: $e');
      return {};
    }
  }

  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    _ensureInitialized();

    try {
      final jsonString = jsonEncode(data);
      html.window.localStorage[_storageKey] = jsonString;
    } catch (e) {
      debugPrint('Error saving web storage data: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearData() async {
    _ensureInitialized();

    try {
      html.window.localStorage.remove(_storageKey);
    } catch (e) {
      debugPrint('Error clearing web storage data: $e');
    }
  }

  @override
  Future<bool> exists() async {
    _ensureInitialized();
    return html.window.localStorage.containsKey(_storageKey);
  }

  @override
  Future<int> getSize() async {
    _ensureInitialized();

    try {
      final jsonString = html.window.localStorage[_storageKey];
      return jsonString?.length ?? 0;
    } catch (e) {
      debugPrint('Error getting web storage size: $e');
      return 0;
    }
  }

  @override
  Future<String?> backup() async {
    _ensureInitialized();

    try {
      final data = await loadData();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupKey = '$_backupPrefix$timestamp';
      final backupData = jsonEncode(data);

      html.window.localStorage[backupKey] = backupData;
      return backupKey;
    } catch (e) {
      debugPrint('Error creating web storage backup: $e');
      return null;
    }
  }

  @override
  Future<bool> restore(String backupData) async {
    _ensureInitialized();

    try {
      Map<String, dynamic> data;

      // Check if backupData is a key or actual data
      if (html.window.localStorage.containsKey(backupData)) {
        // It's a backup key
        final storedData = html.window.localStorage[backupData];
        if (storedData == null) return false;
        data = jsonDecode(storedData) as Map<String, dynamic>;
      } else {
        // It's actual backup data
        data = jsonDecode(backupData) as Map<String, dynamic>;
      }

      await saveData(data);
      return true;
    } catch (e) {
      debugPrint('Error restoring web storage backup: $e');
      return false;
    }
  }

  /// Get all backup keys
  List<String> getBackupKeys() {
    _ensureInitialized();

    return html.window.localStorage.keys
        .where((key) => key.startsWith(_backupPrefix))
        .toList();
  }

  /// Delete old backups (keep only last 5)
  Future<void> cleanupBackups() async {
    _ensureInitialized();

    try {
      final backupKeys = getBackupKeys();
      backupKeys.sort(); // Sort by timestamp

      // Keep only the last 5 backups
      if (backupKeys.length > 5) {
        final keysToDelete = backupKeys.take(backupKeys.length - 5);
        for (final key in keysToDelete) {
          html.window.localStorage.remove(key);
        }
      }
    } catch (e) {
      debugPrint('Error cleaning up web storage backups: $e');
    }
  }
}
