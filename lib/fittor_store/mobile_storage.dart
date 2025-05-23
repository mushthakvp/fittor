import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'storage_interface.dart';

/// Mobile/Desktop storage implementation using file system
class MobileStorage implements StorageInterface {
  late File _storageFile;
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;

    try {
      // Get the application storage directory
      final directory = await getApplicationDocumentsDirectory();

      // Create our storage file in a subdirectory
      final storageDir = Directory('${directory.path}/fittor_store');
      if (!await storageDir.exists()) {
        await storageDir.create(recursive: true);
      }

      _storageFile = File('${storageDir.path}/fittor_store.json');

      // Create the file if it doesn't exist
      if (!await _storageFile.exists()) {
        await _storageFile.create(recursive: true);
        await _storageFile.writeAsString('{}');
      }

      _initialized = true;
      debugPrint('MobileStorage initialized successfully');
    } catch (e) {
      debugPrint('MobileStorage init error: $e');
      _initialized = false;
      rethrow;
    }
  }

  @override
  bool get isInitialized => _initialized;

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('MobileStorage not initialized. Call init() first.');
    }
  }

  @override
  Future<Map<String, dynamic>> loadData() async {
    _ensureInitialized();

    try {
      final jsonString = await _storageFile.readAsString();
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
      await _storageFile.writeAsString(jsonString, flush: true);
    } catch (e) {
      debugPrint('Error saving mobile storage data: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearData() async {
    _ensureInitialized();

    try {
      await _storageFile.writeAsString('{}', flush: true);
    } catch (e) {
      debugPrint('Error clearing mobile storage data: $e');
    }
  }

  @override
  Future<bool> exists() async {
    _ensureInitialized();
    return await _storageFile.exists();
  }

  @override
  Future<int> getSize() async {
    _ensureInitialized();
    try {
      return await _storageFile.length();
    } catch (e) {
      debugPrint('Error getting mobile storage size: $e');
      return 0;
    }
  }

  @override
  Future<String?> backup() async {
    _ensureInitialized();

    try {
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupFile =
          File('${directory.path}/fittor_store_backup_$timestamp.json');

      // Copy the current file to the backup location
      await _storageFile.copy(backupFile.path);
      return backupFile.path;
    } catch (e) {
      debugPrint('Error creating mobile storage backup: $e');
      return null;
    }
  }

  @override
  Future<bool> restore(String backupPath) async {
    _ensureInitialized();

    try {
      final backupFile = File(backupPath);
      if (await backupFile.exists()) {
        // Copy the backup file to the main storage file
        await backupFile.copy(_storageFile.path);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error restoring mobile storage backup: $e');
      return false;
    }
  }

  /// Get storage file path
  String get filePath => _storageFile.path;

  /// Get storage directory
  Future<String> get directoryPath async {
    _ensureInitialized();
    return _storageFile.parent.path;
  }
}
