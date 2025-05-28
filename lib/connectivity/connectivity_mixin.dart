// lib/connectivity/connectivity_mixin.dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'connectivity_manager.dart';

mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  late ConnectivityManager _connectivityManager;
  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;
  ConnectivityStatus _connectivityStatus = ConnectivityStatus.unknown;

  ConnectivityStatus get connectivityStatus => _connectivityStatus;
  bool get isOnline => _connectivityStatus == ConnectivityStatus.online;
  bool get isOffline => _connectivityStatus == ConnectivityStatus.offline;
  bool get isConnectivityUnknown =>
      _connectivityStatus == ConnectivityStatus.unknown;

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  void _initializeConnectivity() {
    _connectivityManager = ConnectivityManager();
    _connectivityManager.initialize();
    _connectivityStatus = _connectivityManager.currentStatus;

    _connectivitySubscription = _connectivityManager.statusStream.listen(
      _onConnectivityChanged,
      onError: (error) {
        if (mounted) {
          setState(() {
            _connectivityStatus = ConnectivityStatus.offline;
          });
          onConnectivityError(error);
        }
      },
    );
  }

  void _onConnectivityChanged(ConnectivityStatus status) {
    if (mounted) {
      setState(() {
        _connectivityStatus = status;
      });
      onConnectivityChanged(status);
    }
  }

  /// Override this method to handle connectivity changes
  void onConnectivityChanged(ConnectivityStatus status) {
    // Default implementation - override in your widget
  }

  /// Override this method to handle connectivity errors
  void onConnectivityError(dynamic error) {
    // Default implementation - override in your widget
    debugPrint('Connectivity error: $error');
  }

  Future<ConnectivityStatus> checkConnectivity() async {
    final status = await _connectivityManager.checkNow();
    if (mounted) {
      setState(() {
        _connectivityStatus = status;
      });
    }
    return status;
  }

  Future<ConnectivityStatus> quickConnectivityCheck() async {
    final status = await _connectivityManager.quickCheck();
    if (mounted) {
      setState(() {
        _connectivityStatus = status;
      });
    }
    return status;
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
