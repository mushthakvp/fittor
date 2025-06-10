/// Abstract interface for storage implementations
abstract class IStorage {
  /// Get a value by key
  Future<String?> get(String key);

  /// Set a value by key
  Future<void> set(String key, String value);

  /// Remove a value by key
  Future<void> remove(String key);

  /// Clear all values
  Future<void> clear();

  /// Check if a key exists
  Future<bool> containsKey(String key);

  /// Get all keys
  Future<List<String>> getAllKeys();

  /// Dispose resources
  void dispose();
}

/// Memory-based storage implementation (fallback)
class MemoryStorage implements IStorage {
  final Map<String, String> _storage = {};

  @override
  Future<String?> get(String key) async {
    return _storage[key];
  }

  @override
  Future<void> set(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _storage.remove(key);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _storage.containsKey(key);
  }

  @override
  Future<List<String>> getAllKeys() async {
    return _storage.keys.toList();
  }

  @override
  void dispose() {
    _storage.clear();
  }
}
