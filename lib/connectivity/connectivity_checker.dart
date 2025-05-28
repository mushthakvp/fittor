// lib/connectivity/connectivity_checker.dart
import 'dart:async';

import '../api/index.dart'; // Import your FittorClient

class ConnectivityChecker {
  static const List<String> _defaultTestUrls = [
    'https://www.google.com/generate_204',
    'https://connectivitycheck.gstatic.com/generate_204',
    'https://clients3.google.com/generate_204',
    'https://www.cloudflare.com/cdn-cgi/trace',
  ];

  final Duration _checkInterval;
  final Duration _quickCheckTimeout;
  final List<String> _testUrls;
  final FittorClient _client;

  bool _lastKnownStatus = true;
  Timer? _periodicTimer;
  StreamController<bool>? _controller;

  ConnectivityChecker({
    Duration checkInterval = const Duration(seconds: 10),
    Duration quickCheckTimeout = const Duration(seconds: 5),
    List<String>? testUrls,
  })  : _checkInterval = checkInterval,
        _quickCheckTimeout = quickCheckTimeout,
        _testUrls = testUrls ?? _defaultTestUrls,
        _client = FittorClient(
          defaultTimeout: quickCheckTimeout,
          enableLogging: false, // Disable logging for connectivity checks
        );

  bool get isOnline => _lastKnownStatus;

  Stream<bool> get onConnectivityChanged {
    _controller ??= StreamController<bool>.broadcast(
      onListen: _startPeriodicChecks,
      onCancel: _stopPeriodicChecks,
    );
    return _controller!.stream;
  }

  void _startPeriodicChecks() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(_checkInterval, (timer) async {
      try {
        final currentStatus = await checkConnectivity();
        if (currentStatus != _lastKnownStatus) {
          _lastKnownStatus = currentStatus;
          if (_controller != null && !_controller!.isClosed) {
            _controller!.add(currentStatus);
          }
        }
      } catch (e) {
        // Handle error silently and assume offline
        if (_lastKnownStatus != false) {
          _lastKnownStatus = false;
          if (_controller != null && !_controller!.isClosed) {
            _controller!.add(false);
          }
        }
      }
    });
  }

  void _stopPeriodicChecks() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  Future<bool> checkConnectivity() async {
    try {
      // Test multiple URLs in parallel for faster and more reliable results
      final futures = _testUrls.map((url) => _testSingleUrl(url));

      // Use Future.wait with eagerError: false to try all URLs
      final results = await Future.wait(
        futures,
        eagerError: false, // Don't fail fast, try all URLs
      ).timeout(
        Duration(seconds: _quickCheckTimeout.inSeconds + 3), // Overall timeout
        onTimeout: () => List.filled(_testUrls.length, false),
      );

      // Return true if ANY URL works
      final isConnected = results.any((result) => result == true);
      _lastKnownStatus = isConnected;
      return isConnected;
    } catch (e) {
      _lastKnownStatus = false;
      return false;
    }
  }

  Future<bool> _testSingleUrl(String url) async {
    try {
      final response = await _client.get(
        url,
        headers: {
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0',
          'User-Agent': 'FittorConnectivityChecker/1.0',
        },
      );

      // Handle different types of connectivity check endpoints
      if (url.contains('generate_204')) {
        return response.statusCode == 204;
      } else if (url.contains('cloudflare.com/cdn-cgi/trace')) {
        return response.isSuccessful && response.body.isNotEmpty;
      } else {
        return response.isSuccessful;
      }
    } catch (e) {
      return false;
    }
  }

  // Quick connectivity test for immediate checks
  Future<bool> quickConnectivityTest() async {
    try {
      // Use the fastest/most reliable endpoint for quick checks
      final response = await _client.get(
        'https://www.google.com/generate_204',
        headers: {
          'Cache-Control': 'no-cache',
          'User-Agent': 'FittorConnectivityChecker/1.0',
        },
      );

      final isConnected = response.statusCode == 204;
      _lastKnownStatus = isConnected;
      return isConnected;
    } catch (e) {
      _lastKnownStatus = false;
      return false;
    }
  }

  // Test with custom URL
  Future<bool> testCustomUrl(String url, {Duration? timeout}) async {
    try {
      final response = await _client.get(
        url,
        headers: {
          'Cache-Control': 'no-cache',
          'User-Agent': 'FittorConnectivityChecker/1.0',
        },
      );
      return response.isSuccessful;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _stopPeriodicChecks();
    _controller?.close();
    _controller = null;
    _client.close();
  }
}
