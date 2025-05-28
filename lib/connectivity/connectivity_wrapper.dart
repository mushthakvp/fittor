// lib/connectivity/connectivity_wrapper.dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'connectivity_manager.dart';
import 'no_internet_page.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  final Widget? offlineWidget;
  final Widget? unknownWidget;
  final bool ignoreOfflineState;
  final Function(ConnectivityStatus)? onConnectivityChanged;
  final Duration checkInterval;
  final Duration quickCheckTimeout;
  final List<String>? customTestUrls;
  final bool showLoadingOnUnknown;

  const ConnectivityWrapper({
    super.key,
    required this.child,
    this.offlineWidget,
    this.unknownWidget,
    this.ignoreOfflineState = false,
    this.onConnectivityChanged,
    this.checkInterval = const Duration(seconds: 10),
    this.quickCheckTimeout = const Duration(seconds: 5),
    this.customTestUrls,
    this.showLoadingOnUnknown = true,
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

    _connectivityManager.initialize(
      checkInterval: widget.checkInterval,
      quickCheckTimeout: widget.quickCheckTimeout,
      customTestUrls: widget.customTestUrls,
    );

    _subscription = _connectivityManager.statusStream.listen(
      _updateConnectivityStatus,
      onError: (error) {
        _updateConnectivityStatus(ConnectivityStatus.offline);
      },
    );
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

    switch (_connectivityStatus) {
      case ConnectivityStatus.online:
        return widget.child;
      case ConnectivityStatus.offline:
        return widget.offlineWidget ?? _buildDefaultOfflineWidget();
      case ConnectivityStatus.unknown:
        if (widget.showLoadingOnUnknown) {
          return widget.unknownWidget ?? _buildDefaultUnknownWidget();
        }
        return widget.child;
    }
  }

  Widget _buildDefaultOfflineWidget() {
    return Material(
      child: NoInternetPage(
        onRetry: () async {
          await _connectivityManager.checkNow();
        },
      ),
    );
  }

  Widget _buildDefaultUnknownWidget() {
    return const Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
