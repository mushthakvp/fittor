import 'dart:async';
import 'dart:io';

class MobileConnectivityChecker {
  // URLs to ping for connectivity check
  static final List<String> _lookupAddresses = [
    'google.com',
    'apple.com',
    'cloudflare.com',
  ];

  static Future<bool> checkConnectivity() async {
    try {
      // Try to lookup multiple hosts to ensure reliable connectivity check
      for (final address in _lookupAddresses) {
        try {
          final result = await InternetAddress.lookup(
            address,
          ).timeout(const Duration(seconds: 3));

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (_) {
          // Continue trying with other addresses
          continue;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
