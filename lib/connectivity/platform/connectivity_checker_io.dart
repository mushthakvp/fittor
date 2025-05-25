import 'dart:async';
import 'dart:io';

class ConnectivityCheckerImpl {
  static final List<String> _lookupAddresses = [
    'google.com',
    'cloudflare.com',
    '8.8.8.8',
  ];

  static bool _lastKnownStatus = true;
  static bool get isOnline => _lastKnownStatus;

  static Stream<bool> get onConnectivityChanged {
    return const Stream<bool>.empty().asBroadcastStream();
  }

  static Future<bool> checkConnectivity() async {
    try {
      for (final address in _lookupAddresses) {
        try {
          final result = await InternetAddress.lookup(address)
              .timeout(const Duration(seconds: 5));

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            _lastKnownStatus = true;
            return true;
          }
        } catch (_) {
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
