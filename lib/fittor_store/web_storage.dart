import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

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
      final jsonString = web.window.localStorage.getItem(_storageKey);
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
      web.window.localStorage.setItem(_storageKey, jsonString);
    } catch (e) {
      debugPrint('Error saving web storage data: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearData() async {
    _ensureInitialized();

    try {
      web.window.localStorage.removeItem(_storageKey);
    } catch (e) {
      debugPrint('Error clearing web storage data: $e');
    }
  }

  @override
  Future<bool> exists() async {
    _ensureInitialized();
    return web.window.localStorage.getItem(_storageKey) != null;
  }

  @override
  Future<int> getSize() async {
    _ensureInitialized();

    try {
      final jsonString = web.window.localStorage.getItem(_storageKey);
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

      web.window.localStorage.setItem(backupKey, backupData);
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

      final isKey = web.window.localStorage.getItem(backupData) != null;

      if (isKey) {
        final storedData = web.window.localStorage.getItem(backupData);
        if (storedData == null) return false;
        data = jsonDecode(storedData) as Map<String, dynamic>;
      } else {
        data = jsonDecode(backupData) as Map<String, dynamic>;
      }

      await saveData(data);
      return true;
    } catch (e) {
      debugPrint('Error restoring web storage backup: $e');
      return false;
    }
  }

  List<String> getBackupKeys() {
    _ensureInitialized();

    final storage = web.window.localStorage;
    final keys = <String>[];
    for (var i = 0; i < storage.length; i++) {
      final key = storage.key(i);
      if (key != null && key.startsWith(_backupPrefix)) {
        keys.add(key);
      }
    }
    return keys;
  }

  Future<void> cleanupBackups() async {
    _ensureInitialized();

    try {
      final backupKeys = getBackupKeys();
      backupKeys.sort(); // Sort by timestamp in key

      if (backupKeys.length > 5) {
        final keysToDelete = backupKeys.take(backupKeys.length - 5);
        for (final key in keysToDelete) {
          web.window.localStorage.removeItem(key);
        }
      }
    } catch (e) {
      debugPrint('Error cleaning up web storage backups: $e');
    }
  }
}
