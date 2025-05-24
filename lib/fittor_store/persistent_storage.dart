import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// A class that handles persistent storage for FittorStore
/// This allows data to be saved to the device's file system
class PersistentStorage {
  // Singleton instance
  static final PersistentStorage _instance = PersistentStorage._internal();
  factory PersistentStorage() => _instance;
  PersistentStorage._internal();

  // File where data will be stored
  late File _storageFile;
  bool _initialized = false;

  /// Initialize the persistent storage
  Future<void> init() async {
    if (_initialized) return;

    try {
      // Get the application storage directory using path_provider
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
      debugPrint('Storage Activated Successfully');
    } catch (e) {
      debugPrint('PersistentStorage init error: $e');
      _initialized = false;
      rethrow; // Rethrow to allow FittorStore to handle the error
    }
  }

  /// Ensures the persistent storage is initialized
  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'PersistentStorage not initialized. Call PersistentStorage.init() first.',
      );
    }
  }

  /// Load all data from persistent storage
  Future<Map<String, dynamic>> loadData() async {
    _ensureInitialized();

    try {
      final jsonString = await _storageFile.readAsString();
      if (jsonString.isEmpty) return {};

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error loading persistent data: $e');
      return {};
    }
  }

  /// Save all data to persistent storage
  Future<void> saveData(Map<String, dynamic> data) async {
    _ensureInitialized();

    try {
      final jsonString = jsonEncode(data);
      await _storageFile.writeAsString(jsonString, flush: true);
    } catch (e) {
      debugPrint('Error saving persistent data: $e');
    }
  }

  /// Clear all data from persistent storage
  Future<void> clearData() async {
    _ensureInitialized();

    try {
      await _storageFile.writeAsString('{}', flush: true);
    } catch (e) {
      debugPrint('Error clearing persistent data: $e');
    }
  }

  /// Check if the storage file exists
  Future<bool> exists() async {
    _ensureInitialized();
    return await _storageFile.exists();
  }

  /// Get the size of the storage file in bytes
  Future<int> getSize() async {
    _ensureInitialized();
    return await _storageFile.length();
  }

  /// Backup the storage file to a separate location
  Future<File?> backup() async {
    _ensureInitialized();

    try {
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupFile = File(
        '${directory.path}/fittor_store_backup_$timestamp.json',
      );

      // Copy the current file to the backup location
      return await _storageFile.copy(backupFile.path);
    } catch (e) {
      debugPrint('Error creating backup: $e');
      return null;
    }
  }

  /// Restore from a backup file
  Future<bool> restore(File backupFile) async {
    _ensureInitialized();

    try {
      if (await backupFile.exists()) {
        // Copy the backup file to the main storage file
        await backupFile.copy(_storageFile.path);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error restoring from backup: $e');
      return false;
    }
  }
}
