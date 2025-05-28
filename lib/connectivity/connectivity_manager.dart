import 'dart:async';

import 'connectivity_checker.dart';

enum ConnectivityStatus { online, offline, unknown }

class ConnectivityManager {
  static final ConnectivityManager _instance = ConnectivityManager._internal();
  factory ConnectivityManager() => _instance;
  ConnectivityManager._internal();

  final _connectivityController =
      StreamController<ConnectivityStatus>.broadcast();
  Stream<ConnectivityStatus> get statusStream => _connectivityController.stream;

  ConnectivityStatus _currentStatus = ConnectivityStatus.unknown;
  ConnectivityStatus get currentStatus => _currentStatus;

  Timer? _periodicCheckTimer;
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isInitialized = false;
  late final ConnectivityChecker _checker;

  void initialize({
    Duration checkInterval = const Duration(seconds: 10),
    Duration quickCheckTimeout = const Duration(seconds: 5),
    List<String>? customTestUrls,
  }) {
    if (_isInitialized) return;
    _isInitialized = true;

    _checker = ConnectivityChecker(
      checkInterval: checkInterval,
      quickCheckTimeout: quickCheckTimeout,
      testUrls: customTestUrls,
    );

    // Check initial connectivity
    _checkConnectivity();

    // Subscribe to connectivity changes
    _connectivitySubscription = _checker.onConnectivityChanged.listen(
      (isOnline) {
        _updateConnectionStatus(
          isOnline ? ConnectivityStatus.online : ConnectivityStatus.offline,
        );
      },
      onError: (error) {
        _updateConnectionStatus(ConnectivityStatus.offline);
      },
    );

    // Periodic checks as backup
    _periodicCheckTimer = Timer.periodic(
      checkInterval,
      (_) => _checkConnectivity(),
    );
  }

  Future<void> _checkConnectivity() async {
    try {
      final isConnected = await _checker.checkConnectivity();
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
      final isConnected = await _checker.quickConnectivityTest();
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

    _checker.dispose();
    _isInitialized = false;
  }
}
