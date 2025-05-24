/// Abstract interface for storage implementations
abstract class StorageInterface {
  /// Initialize the storage
  Future<void> init();

  /// Load data from storage
  Future<Map<String, dynamic>> loadData();

  /// Save data to storage
  Future<void> saveData(Map<String, dynamic> data);

  /// Clear all data from storage
  Future<void> clearData();

  /// Check if storage exists
  Future<bool> exists();

  /// Get the size of the storage
  Future<int> getSize();

  /// Backup the storage
  Future<String?> backup();

  /// Restore from backup
  Future<bool> restore(String backupData);

  /// Check if storage is initialized
  bool get isInitialized;

  /// Get storage type name
  String get storageType;
}
