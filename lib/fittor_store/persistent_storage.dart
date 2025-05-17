import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

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
      // Get the application storage directory
      final directory = await _getStorageDirectory();

      // Create our storage file
      _storageFile = File('${directory.path}/fittor_store.json');

      // Create the file if it doesn't exist
      if (!await _storageFile.exists()) {
        await _storageFile.create(recursive: true);
        await _storageFile.writeAsString('{}');
      }

      _initialized = true;
      debugPrint('PersistentStorage initialized at: ${_storageFile.path}');
    } catch (e) {
      debugPrint('PersistentStorage init error: $e');
      _initialized = false;
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

  /// Get the storage directory based on platform without using path_provider
  Future<Directory> _getStorageDirectory() async {
    try {
      // Get application directory based on platform
      if (Platform.isIOS || Platform.isMacOS) {
        // iOS/macOS: Use NSLibraryDirectory
        return Directory(
          '${_getHomeDirectory()}/Library/Application Support/com.fittor.app',
        );
      } else if (Platform.isAndroid) {
        // Android: Use app's data directory
        return Directory('/data/data/${_getPackageName()}/app_data');
      } else if (Platform.isWindows) {
        // Windows: Use AppData directory
        final appData = Platform.environment['APPDATA'] ?? '';
        return Directory('$appData\\Fittor');
      } else if (Platform.isLinux) {
        // Linux: Use ~/.config directory
        final home = _getHomeDirectory();
        return Directory('$home/.config/fittor');
      } else {
        // Fallback for other platforms
        return _getTemporaryDirectory();
      }
    } catch (e) {
      // Create a temporary directory as fallback
      return _getTemporaryDirectory();
    }
  }

  /// Get the home directory
  String _getHomeDirectory() {
    if (Platform.isWindows) {
      return Platform.environment['USERPROFILE'] ?? '';
    } else {
      return Platform.environment['HOME'] ?? '';
    }
  }

  /// Get package name (simplified implementation)
  String _getPackageName() {
    // In a real app, this would come from your app's build configuration
    return 'com.fittor.app';
  }

  /// Get temporary directory without path_provider
  Directory _getTemporaryDirectory() {
    return Directory.systemTemp.createTempSync('fittor_store');
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
      final directory = await _getStorageDirectory();
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
