// Conditional import for web functionality
import 'state_persistence_interface.dart'
    if (dart.library.js_interop) 'state_persistence_web.dart'
    if (dart.library.io) 'state_persistence_stub.dart';
import 'storage_interface.dart';

/// Handles state persistence across different platforms
class StatePersistence {
  /// Create appropriate storage implementation based on platform
  static IStorage createStorage() {
    return createStorageImplementation();
  }
}
