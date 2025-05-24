import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../storage_interface.dart';

/// Web storage implementation
/// This file should only be compiled for web platforms
class WebStorage implements StorageInterface {
  static const String storageKey = 'fittor_store_data';
  static const String backupPrefix = 'fittor_store_backup_';

  bool _initialized = false;
  Map<String, dynamic> _memoryFallback = {};

  @override
  Future<void> init() async {
    if (_initialized) return;

    try {
      // Test localStorage availability
      _testLocalStorage();
      _initialized = true;
      debugPrint('WebStorage initialized successfully');
    } catch (e) {
      debugPrint('WebStorage init error: $e');
      debugPrint('Using memory fallback for web storage');
      _initialized = true; // Still initialize, but with memory fallback
    }
  }

  void _testLocalStorage() {
    // This is a placeholder for web-specific localStorage access
    // In a real implementation, you would use dart:html conditionally
    throw Exception('localStorage not available in this context');
  }

  @override
  bool get isInitialized => _initialized;

  @override
  String get storageType => 'Web Storage';

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('WebStorage not initialized. Call init() first.');
    }
  }

  @override
  Future<Map<String, dynamic>> loadData() async {
    _ensureInitialized();

    try {
      // Try to load from localStorage
      return await _loadFromLocalStorage();
    } catch (e) {
      debugPrint('localStorage not available, using memory: $e');
      return Map<String, dynamic>.from(_memoryFallback);
    }
  }

  Future<Map<String, dynamic>> _loadFromLocalStorage() async {
    // This would contain actual localStorage implementation for web
    // For now, return memory fallback
    return Map<String, dynamic>.from(_memoryFallback);
  }

  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    _ensureInitialized();

    try {
      // Try to save to localStorage
      await _saveToLocalStorage(data);
    } catch (e) {
      debugPrint('localStorage not available, using memory: $e');
      _memoryFallback = Map<String, dynamic>.from(data);
    }
  }

  Future<void> _saveToLocalStorage(Map<String, dynamic> data) async {
    // This would contain actual localStorage implementation for web
    // For now, save to memory fallback
    _memoryFallback = Map<String, dynamic>.from(data);
  }

  @override
  Future<void> clearData() async {
    _ensureInitialized();

    try {
      // Try to clear localStorage
      await _clearLocalStorage();
    } catch (e) {
      debugPrint('localStorage not available, clearing memory: $e');
      _memoryFallback.clear();
    }
  }

  Future<void> _clearLocalStorage() async {
    // This would contain actual localStorage implementation for web
    _memoryFallback.clear();
  }

  @override
  Future<bool> exists() async {
    _ensureInitialized();
    return _memoryFallback.isNotEmpty;
  }

  @override
  Future<int> getSize() async {
    _ensureInitialized();

    try {
      final jsonString = jsonEncode(_memoryFallback);
      return jsonString.length;
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
      return jsonEncode(data);
    } catch (e) {
      debugPrint('Error creating web storage backup: $e');
      return null;
    }
  }

  @override
  Future<bool> restore(String backupData) async {
    _ensureInitialized();

    try {
      final data = jsonDecode(backupData) as Map<String, dynamic>;
      await saveData(data);
      return true;
    } catch (e) {
      debugPrint('Error restoring web storage backup: $e');
      return false;
    }
  }
}
