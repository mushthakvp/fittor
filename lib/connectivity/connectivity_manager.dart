import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../api/client/universal_client.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityManager {
  // Singleton instance
  static final ConnectivityManager _instance = ConnectivityManager._internal();
  factory ConnectivityManager() => _instance;
  ConnectivityManager._internal();

  final client = FittorClient(
    defaultTimeout: const Duration(seconds: 45),
    enableLogging: true,
    useWasm: true, // Enable WASM support for web
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

  // URLs to ping for connectivity check
  final List<String> _lookupAddresses = [
    'google.com',
    'apple.com',
    'cloudflare.com',
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
      // For web platform, we can't easily check connectivity
      // So we'll assume it's online
      _updateConnectionStatus(ConnectivityStatus.online);
      return;
    }

    try {
      // Try to lookup multiple hosts to ensure reliable connectivity check
      bool isConnected = false;

      for (final address in _lookupAddresses) {
        try {
          // final result = await InternetAddress.lookup(
          //   address,
          // ).timeout(const Duration(seconds: 3));

          // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          //   isConnected = true;
          //   break;
          // }
          final result = await client.get(
            'https://$address',
            headers: {'User-Agent': 'Fittor Connectivity Check'},
          );
          log('Connectivity check result: ${result.statusCode} for $address (${result.body})');
          if (result.isServerError) {
            isConnected = true;
            break;
          }
          throw Exception('Failed to connect to $address');
        } catch (_) {
          // Continue trying with other addresses
          continue;
        }
      }

      _updateConnectionStatus(
        isConnected ? ConnectivityStatus.online : ConnectivityStatus.offline,
      );
    } catch (_) {
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
    _connectivityController.close();
  }
}
