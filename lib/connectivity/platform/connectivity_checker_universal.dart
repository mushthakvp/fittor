// lib/connectivity/platform/connectivity_checker_universal.dart
import 'dart:async';

import 'package:fittor/fittor.dart';

class ConnectivityCheckerImpl {
  static final List<String> _testUrls = [
    'https://www.google.com/generate_204',
    'https://connectivitycheck.gstatic.com/generate_204',
    'https://clients3.google.com/generate_204',
    'https://www.cloudflare.com/cdn-cgi/trace',
  ];

  static bool _lastKnownStatus = true;
  static Timer? _periodicTimer;
  static StreamController<bool>? _controller;
  static final FittorClient _client = FittorClient(
    defaultTimeout: const Duration(seconds: 5),
    enableLogging: true,
  );

  static FittorClient get client => _client;

  static bool get isOnline => _lastKnownStatus;

  static Stream<bool> get onConnectivityChanged {
    _controller ??= StreamController<bool>.broadcast(
      onListen: () {
        // Start periodic checks when someone listens
        _startPeriodicChecks();
      },
      onCancel: () {
        // Stop periodic checks when no one is listening
        _stopPeriodicChecks();
      },
    );
    return _controller!.stream;
  }

  static void _startPeriodicChecks() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      final currentStatus = await checkConnectivity();
      if (currentStatus != _lastKnownStatus) {
        _lastKnownStatus = currentStatus;
        if (_controller != null && !_controller!.isClosed) {
          _controller!.add(currentStatus);
        }
      }
    });
  }

  static void _stopPeriodicChecks() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  static Future<bool> checkConnectivity() async {
    try {
      // Test multiple URLs in parallel for faster results
      final futures = _testUrls.map((url) => _testSingleUrl(url));

      // Use Future.wait with eagerError: false to try all URLs
      final results = await Future.wait(
        futures,
        eagerError: false, // Don't fail fast, try all URLs
      ).timeout(
        const Duration(seconds: 8), // Overall timeout
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

  static Future<bool> _testSingleUrl(String url) async {
    try {
      final response = await client.get(
        url,
        headers: {
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
      );
      return response.isSuccessful &&
          (response.statusCode == 204 || response.statusCode == 200);
    } catch (e) {
      return false;
    }
  }

  // Quick connectivity test for immediate checks
  static Future<bool> quickConnectivityTest() async {
    try {
      // Use the fastest/most reliable endpoint for quick checks
      final response = await client.get(
        'https://www.google.com/generate_204',
        headers: {
          'Cache-Control': 'no-cache',
        },
      );

      final isConnected = response.isSuccessful && response.statusCode == 204;
      _lastKnownStatus = isConnected;
      return isConnected;
    } catch (e) {
      _lastKnownStatus = false;
      return false;
    }
  }

  // Cleanup method
  static void dispose() {
    _stopPeriodicChecks();
    _controller?.close();
    _controller = null;
  }
}
