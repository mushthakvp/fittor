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
  StreamSubscription? _webConnectivitySubscription;
  bool _isInitialized = false;

  void initialize({Duration checkInterval = const Duration(seconds: 5)}) {
    if (_isInitialized) return;
    _isInitialized = true;

    // _checkConnectivity();

    if (kIsWeb) {
      _initializeWebConnectivity(checkInterval);
    } else {
      _periodicCheckTimer = Timer.periodic(checkInterval, (_) {
        _checkConnectivity();
      });
    }
  }

  void _initializeWebConnectivity(Duration checkInterval) {
    try {
      _updateConnectionStatus(ConnectivityCheckerImpl.isOnline
          ? ConnectivityStatus.online
          : ConnectivityStatus.offline);

      _webConnectivitySubscription =
          ConnectivityCheckerImpl.onConnectivityChanged.listen(
        (isOnline) {
          _updateConnectionStatus(isOnline
              ? ConnectivityStatus.online
              : ConnectivityStatus.offline);
        },
      );

      _periodicCheckTimer = Timer.periodic(
        const Duration(seconds: 30),
        (_) => _checkConnectivity(),
      );
    } catch (e) {
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
    _webConnectivitySubscription?.cancel();
    if (!_connectivityController.isClosed) {
      _connectivityController.close();
    }
    _isInitialized = false;
  }
}
