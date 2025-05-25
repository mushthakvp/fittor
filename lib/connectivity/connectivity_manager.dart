import 'dart:async';

import 'package:flutter/foundation.dart';

// Conditional import using the proper pattern
import 'platform/connectivity_checker_io.dart'
    if (dart.library.html) 'platform/connectivity_checker_web.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityManager {
  // Singleton instance
  static final ConnectivityManager _instance = ConnectivityManager._internal();
  factory ConnectivityManager() => _instance;
  ConnectivityManager._internal();

  // Stream controller for broadcasting connectivity status
  final _connectivityController =
      StreamController<ConnectivityStatus>.broadcast();

  // Stream getter for consumers to listen to connectivity changes
  Stream<ConnectivityStatus> get statusStream => _connectivityController.stream;

  // Current connectivity status
  ConnectivityStatus _currentStatus = ConnectivityStatus.online;
  ConnectivityStatus get currentStatus => _currentStatus;

  // Timer for periodic checks
  Timer? _periodicCheckTimer;
  StreamSubscription? _webConnectivitySubscription;

  // Initialize connectivity monitoring
  void initialize({Duration checkInterval = const Duration(seconds: 5)}) {
    // Initial connectivity check
    _checkConnectivity();

    if (kIsWeb) {
      // For web, listen to browser events and do periodic checks
      _initializeWebConnectivity(checkInterval);
    } else {
      // For mobile/desktop, use periodic checks only
      _periodicCheckTimer = Timer.periodic(checkInterval, (_) {
        _checkConnectivity();
      });
    }
  }

  // Initialize web-specific connectivity monitoring
  void _initializeWebConnectivity(Duration checkInterval) {
    if (kIsWeb) {
      try {
        // Set initial status
        _updateConnectionStatus(ConnectivityCheckerImpl.isOnline
            ? ConnectivityStatus.online
            : ConnectivityStatus.offline);

        // Listen to connectivity changes (only available on web)
        _webConnectivitySubscription =
            ConnectivityCheckerImpl.onConnectivityChanged.listen(
          (isOnline) {
            _updateConnectionStatus(isOnline
                ? ConnectivityStatus.online
                : ConnectivityStatus.offline);
          },
        );

        // Also do periodic checks for web (less frequent)
        _periodicCheckTimer = Timer.periodic(
          const Duration(seconds: 30),
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
  }

  // Check current connectivity status
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

  // Force a connectivity check (can be called manually)
  Future<ConnectivityStatus> checkNow() async {
    await _checkConnectivity();
    return _currentStatus;
  }

  // Update and broadcast connectivity status
  void _updateConnectionStatus(ConnectivityStatus status) {
    // Only broadcast if status actually changed
    if (_currentStatus != status) {
      _currentStatus = status;
      _connectivityController.add(status);
    }
  }

  // Dispose resources when no longer needed
  void dispose() {
    _periodicCheckTimer?.cancel();
    _webConnectivitySubscription?.cancel();
    _connectivityController.close();
  }
}
