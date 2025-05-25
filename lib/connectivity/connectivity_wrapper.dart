import 'package:flutter/material.dart';

import 'connectivity_manager.dart';
import 'no_internet_page.dart';

class ConnectivityWrapper extends StatefulWidget {
  /// The child widget to display when there is internet connectivity
  final Widget child;

  /// Optional custom widget to show when there is no internet connection
  /// If not provided, a default NoInternetPage will be shown
  final Widget? offlineWidget;

  /// If set to true, offline state will be ignored and the child will always be shown
  /// This allows users to handle connectivity themselves
  final bool ignoreOfflineState;

  /// Optional callback when connectivity status changes
  final Function(ConnectivityStatus)? onConnectivityChanged;

  /// Duration between connectivity checks
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

  @override
  void initState() {
    super.initState();
    _connectivityManager = ConnectivityManager();
    _connectivityStatus = _connectivityManager.currentStatus;

    // Initialize connectivity manager
    _connectivityManager.initialize(checkInterval: widget.checkInterval);

    // Listen for connectivity changes
    _connectivityManager.statusStream.listen(_updateConnectivityStatus);
  }

  void _updateConnectivityStatus(ConnectivityStatus status) {
    if (mounted) {
      setState(() {
        _connectivityStatus = status;
      });

      // Call the callback if provided
      widget.onConnectivityChanged?.call(status);
    }
  }

  @override
  void dispose() {
    _connectivityManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Always show child if ignoreOfflineState is true
    if (widget.ignoreOfflineState) {
      return widget.child;
    }

    // Show appropriate widget based on connectivity status
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
          // Manual connectivity check on tap
          _connectivityManager.checkNow();
        },
        child: NoInternetPage(
          onRetry: () {
            // Manual connectivity check on retry button press
            _connectivityManager.checkNow();
          },
        ),
      ),
    );
  }
}
