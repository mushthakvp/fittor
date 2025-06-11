// lib/fitroute/storage/state_persistence_interface.dart

import 'storage_interface.dart';

/// Factory function - will be implemented by platform-specific files
IStorage createStorageImplementation() {
  throw UnsupportedError('No implementation available for this platform');
}
