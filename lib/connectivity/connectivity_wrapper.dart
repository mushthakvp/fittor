import 'dart:async';

import 'package:flutter/material.dart';

import 'connectivity_manager.dart';
import 'no_internet_page.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  final Widget? offlineWidget;
  final bool ignoreOfflineState;
  final Function(ConnectivityStatus)? onConnectivityChanged;
  final Duration checkInterval;

  const ConnectivityWrapper({
    super.key,
    required this.child,
    this.offlineWidget,
    this.ignoreOfflineState = false,
    this.onConnectivityChanged,
    this.checkInterval = const Duration(seconds: 5),
  });

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late ConnectivityManager _connectivityManager;
  late ConnectivityStatus _connectivityStatus;
  StreamSubscription<ConnectivityStatus>? _subscription;

  @override
  void initState() {
    super.initState();
    _connectivityManager = ConnectivityManager();
    _connectivityStatus = _connectivityManager.currentStatus;

    _connectivityManager.initialize(checkInterval: widget.checkInterval);
    _subscription =
        _connectivityManager.statusStream.listen(_updateConnectivityStatus);
  }

  void _updateConnectivityStatus(ConnectivityStatus status) {
    if (mounted) {
      setState(() {
        _connectivityStatus = status;
      });
      widget.onConnectivityChanged?.call(status);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ignoreOfflineState) {
      return widget.child;
    }

    if (_connectivityStatus == ConnectivityStatus.online) {
      return widget.child;
    } else {
      return widget.offlineWidget ?? _buildDefaultOfflineWidget();
    }
  }

  Widget _buildDefaultOfflineWidget() {
    return Material(
      child: GestureDetector(
        onTap: () {
          _connectivityManager.checkNow();
        },
        child: NoInternetPage(
          onRetry: () {
            _connectivityManager.checkNow();
          },
        ),
      ),
    );
  }
}
