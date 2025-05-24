import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../storage_interface.dart';

/// In-memory storage implementation (fallback for unsupported platforms)
class MemoryStorage implements StorageInterface {
  Map<String, dynamic> _data = {};
  bool _initialized = false;

  @override
  Future<void> init() async {
    _initialized = true;
    debugPrint('MemoryStorage initialized (data will not persist)');
  }

  @override
  bool get isInitialized => _initialized;

  @override
  String get storageType => 'Memory';

  @override
  Future<Map<String, dynamic>> loadData() async {
    return Map<String, dynamic>.from(_data);
  }

  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    _data = Map<String, dynamic>.from(data);
  }

  @override
  Future<void> clearData() async {
    _data.clear();
  }

  @override
  Future<bool> exists() async {
    return _data.isNotEmpty;
  }

  @override
  Future<int> getSize() async {
    try {
      final jsonString = jsonEncode(_data);
      return jsonString.length;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<String?> backup() async {
    try {
      return jsonEncode(_data);
    } catch (e) {
      debugPrint('Error creating memory storage backup: $e');
      return null;
    }
  }

  @override
  Future<bool> restore(String backupData) async {
    try {
      final data = jsonDecode(backupData) as Map<String, dynamic>;
      await saveData(data);
      return true;
    } catch (e) {
      debugPrint('Error restoring memory storage backup: $e');
      return false;
    }
  }
}
