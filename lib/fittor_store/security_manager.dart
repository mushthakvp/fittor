import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'fittor_store.dart';

/// A class that manages security aspects of the FittorStore
class SecurityManager {
  // Singleton instance
  static final SecurityManager _instance = SecurityManager._internal();
  factory SecurityManager() => _instance;
  SecurityManager._internal();

  // Authentication state
  bool _authenticated = false;

  // PIN/password attempts tracking
  int _failedAttempts = 0;
  DateTime? _lockoutUntil;
  static const int _maxFailedAttempts = 5;
  static const Duration _lockoutDuration = Duration(minutes: 5);

  // Session timeout configuration
  Timer? _sessionTimer;
  static const Duration _sessionTimeout = Duration(minutes: 15);

  /// Initialize the security manager
  Future<void> init() async {
    // Reset authentication state
    _authenticated = false;
    _failedAttempts = 0;
    _lockoutUntil = null;

    // Check if PIN is set
    final hasPin = await isPinSet();
    if (!hasPin) {
      // If no PIN is set, we're authenticated by default
      _authenticated = true;
    }
  }

  /// Check if a PIN/password is set
  Future<bool> isPinSet() async {
    return FittorStore.getString('security.pin') != null;
  }

  /// Set a PIN/password for secure access
  Future<bool> setPin(String pin) async {
    if (pin.isEmpty) return false;

    // Hash the PIN before storing it
    final hashedPin = _hashPin(pin);
    await FittorStore.setString('security.pin', hashedPin);

    // Store the salt used for hashing
    final salt = _generateSalt();
    await FittorStore.setString('security.salt', base64.encode(salt));

    // Set PIN creation timestamp
    await FittorStore.setDateTime('security.pinCreatedAt', DateTime.now());

    return true;
  }

  /// Verify the PIN/password
  Future<bool> verifyPin(String pin) async {
    // Check for lockout
    if (_isLockedOut()) {
      debugPrint('Account is locked out until: $_lockoutUntil');
      return false;
    }

    final storedPin = FittorStore.getString('security.pin');
    if (storedPin == null) return false;

    // Hash the provided PIN and compare
    final hashedPin = _hashPin(pin);
    final isCorrect = storedPin == hashedPin;

    if (isCorrect) {
      // Reset failed attempts on success
      _failedAttempts = 0;
      _authenticated = true;

      // Start session timeout
      _startSessionTimeout();

      // Record last successful login
      await FittorStore.setDateTime('security.lastLogin', DateTime.now());

      return true;
    } else {
      // Increment failed attempts
      _failedAttempts++;

      // Store failed attempt
      await FittorStore.setInt('security.failedAttempts', _failedAttempts);
      await FittorStore.setDateTime(
        'security.lastFailedAttempt',
        DateTime.now(),
      );

      // Check if we should lock out
      if (_failedAttempts >= _maxFailedAttempts) {
        _lockoutUntil = DateTime.now().add(_lockoutDuration);
        await FittorStore.setDateTime('security.lockoutUntil', _lockoutUntil!);
      }

      return false;
    }
  }

  /// Change the PIN/password (requires current PIN verification)
  Future<bool> changePin(String currentPin, String newPin) async {
    // Verify current PIN first
    final isVerified = await verifyPin(currentPin);
    if (!isVerified) return false;

    // Set new PIN
    return setPin(newPin);
  }

  /// Remove the PIN/password protection
  Future<bool> removePin(String currentPin) async {
    // Verify current PIN first
    final isVerified = await verifyPin(currentPin);
    if (!isVerified) return false;

    // Remove PIN-related data
    await FittorStore.remove('security.pin');
    await FittorStore.remove('security.salt');
    await FittorStore.remove('security.pinCreatedAt');
    await FittorStore.remove('security.failedAttempts');
    await FittorStore.remove('security.lastFailedAttempt');
    await FittorStore.remove('security.lockoutUntil');

    // Set authenticated state
    _authenticated = true;

    return true;
  }

  /// Check if the user is currently authenticated
  bool isAuthenticated() {
    return _authenticated;
  }

  /// Log out the user
  void logout() {
    _authenticated = false;
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  /// Start session timeout timer
  void _startSessionTimeout() {
    // Cancel existing timer if any
    _sessionTimer?.cancel();

    // Start new timer
    _sessionTimer = Timer(_sessionTimeout, () {
      logout();
      debugPrint('Session timed out due to inactivity');
    });
  }

  /// Reset session timeout (call this when user interacts with the app)
  void resetSessionTimeout() {
    if (_authenticated) {
      _startSessionTimeout();
    }
  }

  /// Check if the account is currently locked out
  bool _isLockedOut() {
    if (_lockoutUntil == null) return false;

    if (DateTime.now().isAfter(_lockoutUntil!)) {
      // Lockout period has passed
      _lockoutUntil = null;
      _failedAttempts = 0;
      return false;
    }

    return true;
  }

  /// Hash a PIN/password (simple implementation)
  /// In production, use a more secure hashing algorithm
  String _hashPin(String pin) {
    // Get or generate salt
    List<int> salt;
    final storedSalt = FittorStore.getString('security.salt');

    if (storedSalt != null) {
      salt = base64.decode(storedSalt);
    } else {
      salt = _generateSalt();
    }

    // Combine pin with salt
    final saltedPin = pin + String.fromCharCodes(salt);

    // Simple hash for demonstration purposes
    // In production, use a proper password hashing algorithm like bcrypt, PBKDF2, etc.
    return base64.encode(
      Uint8List.fromList(
        List.generate(
          32,
          (i) => saltedPin.codeUnitAt(i % saltedPin.length) ^ i * 13,
        ),
      ),
    );
  }

  /// Generate a random salt for PIN hashing
  List<int> _generateSalt() {
    final random = Random.secure();
    return List.generate(16, (_) => random.nextInt(256));
  }

  /// Force account lockout (for security reasons)
  Future<void> lockAccount() async {
    _lockoutUntil = DateTime.now().add(_lockoutDuration);
    _authenticated = false;

    await FittorStore.setDateTime('security.lockoutUntil', _lockoutUntil!);
    await FittorStore.setInt('security.failedAttempts', _maxFailedAttempts);
  }

  /// Suggest PIN change if it's too old
  bool shouldChangePinDueToAge() {
    final pinCreatedAt = FittorStore.getDateTime('security.pinCreatedAt');
    if (pinCreatedAt == null) return false;

    // Suggest changing PIN after 90 days
    final pinAge = DateTime.now().difference(pinCreatedAt);
    return pinAge.inDays > 90;
  }

  /// Dispose security manager resources
  void dispose() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }
}
