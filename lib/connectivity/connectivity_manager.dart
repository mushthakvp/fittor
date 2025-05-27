// lib/connectivity/connectivity_manager.dart (Updated)
import 'dart:async';

import 'platform/connectivity_checker_universal.dart';

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

  void initialize({Duration checkInterval = const Duration(seconds: 5)}) {
    if (_isInitialized) return;
    _isInitialized = true;

    // Check initial connectivity
    _checkConnectivity();

    try {
      // Subscribe to connectivity changes
      _connectivitySubscription =
          ConnectivityCheckerImpl.onConnectivityChanged.listen(
        (isOnline) {
          _updateConnectionStatus(isOnline
              ? ConnectivityStatus.online
              : ConnectivityStatus.offline);
        },
      );

      // Periodic checks as backup
      _periodicCheckTimer = Timer.periodic(
        checkInterval,
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

  Future<ConnectivityStatus> quickCheck() async {
    try {
      final isConnected = await ConnectivityCheckerImpl.quickConnectivityTest();
      _updateConnectionStatus(
        isConnected ? ConnectivityStatus.online : ConnectivityStatus.offline,
      );
      return _currentStatus;
    } catch (e) {
      _updateConnectionStatus(ConnectivityStatus.offline);
      return ConnectivityStatus.offline;
    }
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
    try {
      ConnectivityCheckerImpl.dispose();
    } catch (_) {}

    _isInitialized = false;
  }
}
