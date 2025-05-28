import 'dart:async';

import 'package:flutter/foundation.dart';

import '../api/client/universal_client.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityManager {
  // Singleton instance
  static final ConnectivityManager _instance = ConnectivityManager._internal();
  factory ConnectivityManager() => _instance;
  ConnectivityManager._internal();

  final client = FittorClient(
    defaultTimeout:
        const Duration(seconds: 10), // Reduced timeout for connectivity checks
    enableLogging: kDebugMode, // Enable logging only in debug mode
    useWasm: false, // Disable WASM for better compatibility
  );

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

  // URLs to ping for connectivity check (using different approaches)
  final List<String> _lookupAddresses = [
    'https://cloudflare.com/cdn-cgi/trace', // Cloudflare's trace endpoint
    'https://httpbin.org/status/200', // Simple status endpoint
  ];

  // Web-specific endpoints (CORS-friendly)
  final List<String> _webLookupAddresses = [
    'https://httpbin.org/get', // Httpbin allows CORS
    'https://jsonplaceholder.typicode.com/posts/1', // Public API that allows CORS
  ];

  // Initialize connectivity monitoring
  void initialize({Duration checkInterval = const Duration(seconds: 5)}) {
    // Initial connectivity check
    _checkConnectivity();

    // Set up periodic connectivity checks
    _periodicCheckTimer = Timer.periodic(checkInterval, (_) {
      _checkConnectivity();
    });
  }

  // Check current connectivity status
  Future<void> _checkConnectivity() async {
    if (kIsWeb) {
      // For web platform, use web-specific connectivity check
      await _checkWebConnectivity();
    } else {
      // For mobile/desktop platforms, use mobile connectivity check
      await _checkMobileConnectivity();
    }
  }

  // Web-specific connectivity check
  Future<void> _checkWebConnectivity() async {
    bool isConnected = false;

    // Use web-friendly endpoints that allow CORS
    for (final address in _webLookupAddresses) {
      try {
        final result = await client.get(
          address,
          headers: {
            'Cache-Control': 'no-cache',
            'Accept': '*/*',
          },
        );

        // For web, consider any successful HTTP response as connected
        // Even 404 or other errors mean we have connectivity
        if (result.statusCode > 0 && result.statusCode < 600) {
          isConnected = true;
          break;
        }
      } catch (e) {
        continue;
      }
    }

    // Fallback: try a simple fetch to a reliable endpoint
    if (!isConnected) {
      try {
        final result = await client.get(
          'https://www.google.com/favicon.ico',
          headers: {'Cache-Control': 'no-cache'},
        );

        if (result.statusCode > 0) {
          isConnected = true;
        }
      } catch (e) {
        debugPrint('Fallback connectivity check failed: $e');
      }
    }

    _updateConnectionStatus(
      isConnected ? ConnectivityStatus.online : ConnectivityStatus.offline,
    );
  }

  // Mobile-specific connectivity check
  Future<void> _checkMobileConnectivity() async {
    bool isConnected = false;

    for (final address in _lookupAddresses) {
      try {
        final result = await client.get(
          address,
          headers: {
            'User-Agent': 'Fittor-Connectivity-Check/1.0',
            'Cache-Control': 'no-cache',
          },
        );
        if (result.statusCode > 0 && result.statusCode < 600) {
          isConnected = true;
          break;
        }
      } catch (e) {
        debugPrint('HTTP connectivity check failed for $address: $e');
        continue;
      }
    }

    _updateConnectionStatus(
      isConnected ? ConnectivityStatus.online : ConnectivityStatus.offline,
    );
  }

  Future<ConnectivityStatus> checkNow() async {
    await _checkConnectivity();
    return _currentStatus;
  }

  // Update and broadcast connectivity status
  void _updateConnectionStatus(ConnectivityStatus status) {
    // Only broadcast if status actually changed
    if (_currentStatus != status) {
      final oldStatus = _currentStatus;
      _currentStatus = status;
      debugPrint('Connectivity status changed: $oldStatus -> $status');
      _connectivityController.add(status);
    }
  }

  // Dispose resources when no longer needed
  void dispose() {
    _periodicCheckTimer?.cancel();
    _connectivityController.close();
    client.close();
  }
}
