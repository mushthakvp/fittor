import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

/// A class that provides encryption and decryption capabilities
/// for sensitive data stored in FittorStore
class SecureStorage {
  // Singleton instance
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;
  SecureStorage._internal();

  // Encryption key
  late Uint8List _key;
  bool _initialized = false;

  /// Initialize the secure storage with a random key
  /// or a derived key from device-specific information
  Future<void> init() async {
    if (_initialized) return;

    try {
      // For production: Generate a device-specific key using platform channels
      // to access secure hardware features where available

      // For this demo: Generate a random key
      final random = Random.secure();
      _key = Uint8List.fromList(List.generate(32, (_) => random.nextInt(256)));

      _initialized = true;
      debugPrint('SecureStorage initialized successfully');
    } catch (e) {
      debugPrint('SecureStorage init error: $e');
      rethrow;
    }
  }

  /// Ensures the secure storage is initialized
  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'SecureStorage not initialized. Call SecureStorage.init() first.',
      );
    }
  }

  /// Encrypt a string using XOR (for demonstration)
  /// In production, use a stronger encryption algorithm like AES
  String encrypt(String plainText) {
    _ensureInitialized();

    // Convert string to bytes
    final bytes = utf8.encode(plainText);

    // Apply simple XOR encryption (for demonstration)
    // In production, replace with a proper encryption library
    final encrypted = _xorEncrypt(bytes, _key);

    // Return base64 encoded string
    return base64.encode(encrypted);
  }

  /// Decrypt a string using XOR (for demonstration)
  /// In production, use a stronger encryption algorithm like AES
  String decrypt(String encryptedText) {
    _ensureInitialized();

    try {
      // Decode base64
      final bytes = base64.decode(encryptedText);

      // Apply simple XOR decryption (for demonstration)
      final decrypted = _xorEncrypt(bytes, _key);

      // Return decoded string
      return utf8.decode(decrypted);
    } catch (e) {
      debugPrint('Decryption error: $e');
      return ''; // Return empty string on error
    }
  }

  /// Rotate the encryption key and re-encrypt all data
  /// This should be called periodically for security
  Future<void> rotateKey() async {
    _ensureInitialized();

    // Generate a new key
    final random = Random.secure();
    final newKey = Uint8List.fromList(
      List.generate(32, (_) => random.nextInt(256)),
    );

    // In a real implementation, you would:
    // 1. Get all encrypted data
    // 2. Decrypt with old key
    // 3. Encrypt with new key
    // 4. Store the new encrypted data

    // Update the key
    _key = newKey;

    debugPrint('Encryption key rotated successfully');
  }

  /// Simple XOR encryption/decryption for demonstration
  /// Not suitable for production use!
  Uint8List _xorEncrypt(List<int> data, List<int> key) {
    final result = Uint8List(data.length);

    for (var i = 0; i < data.length; i++) {
      result[i] = data[i] ^ key[i % key.length];
    }

    return result;
  }

  /// Check if a string should be encrypted based on its key
  bool shouldEncrypt(String key) {
    // Encrypt keys that might contain sensitive information
    final sensitiveKeys = [
      'token',
      'password',
      'credit',
      'card',
      'ssn',
      'secret',
      'auth',
      'key',
      'private',
    ];

    return sensitiveKeys.any(
      (sensitive) => key.toLowerCase().contains(sensitive.toLowerCase()),
    );
  }

  /// Generate a unique device identifier (for key derivation)
  /// This is a placeholder - in production, use platform-specific methods
  Future<String> _getDeviceIdentifier() async {
    try {
      // This is a simplified example
      // In production, use a combination of device-specific identifiers
      // through platform channels

      // Simulate getting a device ID
      await Future.delayed(Duration(milliseconds: 100));
      return 'device-${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      debugPrint('Error getting device identifier: $e');
      return 'fallback-identifier';
    }
  }
}
