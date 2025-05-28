import 'dart:async';

import 'package:flutter/material.dart';

import '../connectivity/connectivity_manager.dart';

/// A mixin that provides connectivity status to StatefulWidget classes
mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  late ConnectivityManager _connectivityManager;
  late StreamSubscription<ConnectivityStatus> _connectivitySubscription;
  ConnectivityStatus _connectivityStatus = ConnectivityStatus.online;

  /// The current connectivity status
  ConnectivityStatus get connectivityStatus => _connectivityStatus;

  /// Whether the device is currently online
  bool get isOnline => _connectivityStatus == ConnectivityStatus.online;

  /// Whether the device is currently offline
  bool get isOffline => _connectivityStatus == ConnectivityStatus.offline;

  @override
  void initState() {
    super.initState();
    _connectivityManager = ConnectivityManager();
    _connectivityManager.initialize();
    _connectivityStatus = _connectivityManager.currentStatus;

    // Subscribe to connectivity changes
    _connectivitySubscription = _connectivityManager.statusStream.listen(
      _onConnectivityChanged,
    );
  }

  /// Handle connectivity status changes
  void _onConnectivityChanged(ConnectivityStatus status) {
    if (mounted) {
      setState(() {
        _connectivityStatus = status;
      });

      // Call the user-defined callback
      onConnectivityChanged(status);
    }
  }

  /// Override this method to handle connectivity status changes
  void onConnectivityChanged(ConnectivityStatus status) {
    // Default implementation does nothing
    // Override this method to handle connectivity changes
  }

  /// Force a connectivity check and return the result
  Future<ConnectivityStatus> checkConnectivity() async {
    return await _connectivityManager.checkNow();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
