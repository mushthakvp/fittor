import 'dart:async';

import 'package:flutter/material.dart';

import 'connectivity_manager.dart';

mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  late ConnectivityManager _connectivityManager;
  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;
  ConnectivityStatus _connectivityStatus = ConnectivityStatus.online;

  ConnectivityStatus get connectivityStatus => _connectivityStatus;
  bool get isOnline => _connectivityStatus == ConnectivityStatus.online;
  bool get isOffline => _connectivityStatus == ConnectivityStatus.offline;

  @override
  void initState() {
    super.initState();
    _connectivityManager = ConnectivityManager();
    _connectivityManager.initialize();
    _connectivityStatus = _connectivityManager.currentStatus;

    _connectivitySubscription = _connectivityManager.statusStream.listen(
      _onConnectivityChanged,
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

  void onConnectivityChanged(ConnectivityStatus status) {
    // Override this method to handle connectivity changes
  }

  Future<ConnectivityStatus> checkConnectivity() async {
    return await _connectivityManager.checkNow();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
