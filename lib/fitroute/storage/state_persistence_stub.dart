// lib/fitroute/storage/state_persistence_stub.dart

import 'storage_interface.dart';

/// Persistent storage for mobile platforms
/// This would typically use SharedPreferences in a real implementation
class MobileStorage implements IStorage {
  final Map<String, String> _memoryStorage = {};

  @override
  Future<String?> get(String key) async {
    // In a real implementation, this would use SharedPreferences
    // await SharedPreferences.getInstance().then((prefs) => prefs.getString(key));
    return _memoryStorage[key];
  }

  @override
  Future<void> set(String key, String value) async {
    // In a real implementation, this would use SharedPreferences
    // await SharedPreferences.getInstance().then((prefs) => prefs.setString(key, value));
    _memoryStorage[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    // In a real implementation, this would use SharedPreferences
    // await SharedPreferences.getInstance().then((prefs) => prefs.remove(key));
    _memoryStorage.remove(key);
  }

  @override
  Future<void> clear() async {
    // In a real implementation, this would clear SharedPreferences
    _memoryStorage.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    // In a real implementation, this would check SharedPreferences
    return _memoryStorage.containsKey(key);
  }

  @override
  Future<List<String>> getAllKeys() async {
    // In a real implementation, this would get keys from SharedPreferences
    return _memoryStorage.keys.toList();
  }

  @override
  void dispose() {
    _memoryStorage.clear();
  }
}

/// Factory function for mobile platforms
IStorage createStorageImplementation() {
  return MobileStorage();
}
