import 'dart:async';

import 'package:flutter/foundation.dart';

// Conditional import - this is the correct way
import 'platform/connectivity_checker_stub.dart'
    if (dart.library.io) 'platform/connectivity_checker_io.dart'
    if (dart.library.html) 'platform/connectivity_checker_web.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityManager {
  static final ConnectivityManager _instance = ConnectivityManager._internal();
  factory ConnectivityManager() => _instance;
  ConnectivityManager._internal();

  final _connectivityController =
      StreamController<ConnectivityStatus>.broadcast();
  Stream<ConnectivityStatus> get statusStream => _connectivityController.stream;

  ConnectivityStatus _currentStatus = ConnectivityStatus.online;
  ConnectivityStatus get currentStatus => _currentStatus;

  Timer? _periodicCheckTimer;
  StreamSubscription? _connectivitySubscription;
  bool _isInitialized = false;

  void initialize({Duration checkInterval = const Duration(seconds: 3)}) {
    if (_isInitialized) return;
    _isInitialized = true;

    // Check initial connectivity
    _checkConnectivity();

    if (kIsWeb) {
      _initializeWebConnectivity(checkInterval);
    } else {
      _initializeMobileConnectivity(checkInterval);
    }
  }

  void _initializeWebConnectivity(Duration checkInterval) {
    try {
      _updateConnectionStatus(ConnectivityCheckerImpl.isOnline
          ? ConnectivityStatus.online
          : ConnectivityStatus.offline);

      _connectivitySubscription =
          ConnectivityCheckerImpl.onConnectivityChanged.listen(
        (isOnline) {
          _updateConnectionStatus(isOnline
              ? ConnectivityStatus.online
              : ConnectivityStatus.offline);
        },
      );

      // Less frequent checks for web since we have event listeners
      _periodicCheckTimer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => _checkConnectivity(),
      );
    } catch (e) {
      _periodicCheckTimer = Timer.periodic(
        checkInterval,
        (_) => _checkConnectivity(),
      );
    }
  }

  void _initializeMobileConnectivity(Duration checkInterval) {
    try {
      // Subscribe to connectivity changes from the platform implementation
      _connectivitySubscription =
          ConnectivityCheckerImpl.onConnectivityChanged.listen(
        (isOnline) {
          _updateConnectionStatus(isOnline
              ? ConnectivityStatus.online
              : ConnectivityStatus.offline);
        },
      );

      // Additional periodic checks for mobile (less frequent since platform handles most detection)
      _periodicCheckTimer = Timer.periodic(
        const Duration(seconds: 3), // Less frequent
        (_) => _checkConnectivity(),
      );
    } catch (e) {
      // Fallback to periodic checks only
      _periodicCheckTimer = Timer.periodic(
        checkInterval,
        (_) => _checkConnectivity(),
      );
    }
  }

  Future<void> _checkConnectivity() async {
    try {
      final isConnected = await ConnectivityCheckerImpl.checkConnectivity();
      _updateConnectionStatus(
        isConnected ? ConnectivityStatus.online : ConnectivityStatus.offline,
      );
    } catch (e) {
      _updateConnectionStatus(ConnectivityStatus.offline);
    }
  }

  Future<ConnectivityStatus> checkNow() async {
    await _checkConnectivity();
    return _currentStatus;
  }

  void _updateConnectionStatus(ConnectivityStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      if (!_connectivityController.isClosed) {
        _connectivityController.add(status);
      }
    }
  }

  void dispose() {
    _periodicCheckTimer?.cancel();
    _connectivitySubscription?.cancel();
    if (!_connectivityController.isClosed) {
      _connectivityController.close();
    }

    // Cleanup platform-specific resources
    if (!kIsWeb) {
      try {
        ConnectivityCheckerImpl.dispose();
      } catch (_) {}
    }

    _isInitialized = false;
  }
}
