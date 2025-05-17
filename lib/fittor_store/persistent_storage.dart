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
      // Get the application storage directory without using path_provider
      final directory = await _getStorageDirectory();

      // Create the directory if it doesn't exist
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

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
      rethrow;
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
      // For iOS and macOS: use NSDocumentDirectory which apps have access to
      if (Platform.isIOS || Platform.isMacOS) {
        final home = _getHomeDirectory();
        final appName = 'fittor_app';

        // iOS app sandbox: create in Documents directory
        if (Platform.isIOS) {
          return Directory('$home/Documents/$appName');
        }

        // macOS: try Documents directory first
        return Directory('$home/Documents/$appName');
      }
      // For Android: use the app's data directory
      else if (Platform.isAndroid) {
        // On Android, we can often write to the app's files directory
        final appDir = Directory(
          '/data/data/${_getPackageName()}/files/fittor',
        );
        // If we can't create this directory, we'll fall back to a temporary directory
        try {
          if (!await appDir.exists()) {
            await appDir.create(recursive: true);
          }
          return appDir;
        } catch (_) {
          // Fall back to temp directory which should always be writable
          return Directory.systemTemp.createTempSync('fittor_store');
        }
      }
      // For Windows: use a folder in the user's Documents directory
      else if (Platform.isWindows) {
        final documents = '${_getHomeDirectory()}\\Documents\\Fittor';
        return Directory(documents);
      }
      // For Linux: use ~/.local/share/fittor
      else if (Platform.isLinux) {
        final home = _getHomeDirectory();
        return Directory('$home/.local/share/fittor');
      }
      // Fallback for other platforms
      else {
        return _getTemporaryDirectory();
      }
    } catch (e) {
      // Create a temporary directory as fallback
      debugPrint('Error getting storage directory: $e');
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
    // This is a simplified approach - in a real app with a real package name
    return 'com.example.fittor';
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
      final directory = Directory.systemTemp;
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
