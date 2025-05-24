import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../storage_interface.dart';

/// Mobile/Desktop storage implementation using file system
/// Only available on platforms with file system access
class MobileStorage implements StorageInterface {
  File? _storageFile;
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;

    try {
      // Try to import path_provider dynamically
      final directory = await _getStorageDirectory();
      if (directory == null) {
        throw Exception('Could not access storage directory');
      }

      // Create our storage file in a subdirectory
      final storageDir = Directory('${directory.path}/fittor_store');
      if (!await storageDir.exists()) {
        await storageDir.create(recursive: true);
      }

      _storageFile = File('${storageDir.path}/fittor_store.json');

      // Create the file if it doesn't exist
      if (!await _storageFile!.exists()) {
        await _storageFile!.create(recursive: true);
        await _storageFile!.writeAsString('{}');
      }

      _initialized = true;
      debugPrint('MobileStorage initialized successfully');
    } catch (e) {
      debugPrint('MobileStorage init error: $e');
      _initialized = false;
      rethrow;
    }
  }

  Future<Directory?> _getStorageDirectory() async {
    try {
      // Try to dynamically import path_provider
      // This will only work if path_provider is available
      final dynamic pathProvider = await _tryImportPathProvider();
      if (pathProvider != null) {
        return await pathProvider.getApplicationDocumentsDirectory();
      }
    } catch (e) {
      debugPrint('Path provider not available: $e');
    }

    // Fallback: try to create a directory in current working directory
    try {
      final currentDir = Directory.current;
      final storageDir = Directory('${currentDir.path}/.fittor_store');
      if (!await storageDir.exists()) {
        await storageDir.create(recursive: true);
      }
      return storageDir;
    } catch (e) {
      debugPrint('Fallback directory creation failed: $e');
      return null;
    }
  }

  Future<dynamic> _tryImportPathProvider() async {
    try {
      // This is a placeholder - in a real implementation,
      // you would use conditional imports or platform channels
      // For now, we'll use a simple fallback approach
      throw Exception('Path provider not available in this context');
    } catch (e) {
      return null;
    }
  }

  @override
  bool get isInitialized => _initialized;

  @override
  String get storageType => 'File System';

  void _ensureInitialized() {
    if (!_initialized || _storageFile == null) {
      throw StateError('MobileStorage not initialized. Call init() first.');
    }
  }

  @override
  Future<Map<String, dynamic>> loadData() async {
    _ensureInitialized();

    try {
      final jsonString = await _storageFile!.readAsString();
      if (jsonString.isEmpty) return {};

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error loading mobile storage data: $e');
      return {};
    }
  }

  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    _ensureInitialized();

    try {
      final jsonString = jsonEncode(data);
      await _storageFile!.writeAsString(jsonString, flush: true);
    } catch (e) {
      debugPrint('Error saving mobile storage data: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearData() async {
    _ensureInitialized();

    try {
      await _storageFile!.writeAsString('{}', flush: true);
    } catch (e) {
      debugPrint('Error clearing mobile storage data: $e');
    }
  }

  @override
  Future<bool> exists() async {
    _ensureInitialized();
    return await _storageFile!.exists();
  }

  @override
  Future<int> getSize() async {
    _ensureInitialized();
    try {
      return await _storageFile!.length();
    } catch (e) {
      debugPrint('Error getting mobile storage size: $e');
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
      debugPrint('Error creating mobile storage backup: $e');
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
      debugPrint('Error restoring mobile storage backup: $e');
      return false;
    }
  }
}
