import 'dart:async';
import 'dart:io';

class ConnectivityCheckerImpl {
  // URLs to ping for connectivity check
  static final List<String> _lookupAddresses = [
    'google.com',
    'apple.com',
    'cloudflare.com',
  ];

  // For mobile/desktop, we don't have real-time connectivity events
  // So we'll return the current status based on the last check
  static bool _lastKnownStatus = true;

  static bool get isOnline => _lastKnownStatus;

  // For mobile/desktop platforms, we don't have native connectivity change events
  // This stream will be empty but needs to exist for the interface
  static Stream<bool> get onConnectivityChanged {
    // Return an empty broadcast stream since mobile doesn't have native connectivity events
    return const Stream<bool>.empty().asBroadcastStream();
  }

  static Future<bool> checkConnectivity() async {
    try {
      // Try to lookup multiple hosts to ensure reliable connectivity check
      for (final address in _lookupAddresses) {
        try {
          final result = await InternetAddress.lookup(
            address,
          ).timeout(const Duration(seconds: 3));

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            _lastKnownStatus = true;
            return true;
          }
        } catch (_) {
          // Continue trying with other addresses
          continue;
        }
      }

      _lastKnownStatus = false;
      return false;
    } catch (_) {
      _lastKnownStatus = false;
      return false;
    }
  }
}
