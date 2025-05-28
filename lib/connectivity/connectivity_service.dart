// lib/connectivity/connectivity_service.dart - Advanced service for complex use cases
import 'dart:async';

import '../api/index.dart';
import 'connectivity_manager.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final ConnectivityManager _manager = ConnectivityManager();
  final FittorClient _client = FittorClient(
    defaultTimeout: const Duration(seconds: 5),
    enableLogging: false,
  );

  bool _isInitialized = false;

  void initialize({
    Duration checkInterval = const Duration(seconds: 10),
    Duration quickCheckTimeout = const Duration(seconds: 5),
    List<String>? customTestUrls,
  }) {
    if (_isInitialized) return;
    _isInitialized = true;

    _manager.initialize(
      checkInterval: checkInterval,
      quickCheckTimeout: quickCheckTimeout,
      customTestUrls: customTestUrls,
    );
  }

  Stream<ConnectivityStatus> get statusStream => _manager.statusStream;
  ConnectivityStatus get currentStatus => _manager.currentStatus;

  Future<bool> isHostReachable(String host, {Duration? timeout}) async {
    try {
      final response = await _client.get(
        host,
        headers: {'Cache-Control': 'no-cache'},
      );
      return response.isSuccessful;
    } catch (e) {
      return false;
    }
  }

  Future<bool> canReachApi(String apiEndpoint, {Duration? timeout}) async {
    try {
      final response = await _client.get(
        apiEndpoint,
        headers: {'Cache-Control': 'no-cache'},
      );
      return response.isSuccessful;
    } catch (e) {
      return false;
    }
  }

  Future<Duration?> measureLatency(String url) async {
    try {
      final stopwatch = Stopwatch()..start();
      await _client.get(url, headers: {'Cache-Control': 'no-cache'});
      stopwatch.stop();
      return stopwatch.elapsed;
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _manager.dispose();
    _client.close();
    _isInitialized = false;
  }
}
