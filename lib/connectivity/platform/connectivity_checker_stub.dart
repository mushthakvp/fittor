import 'dart:async';

// Stub implementation - should not be used
class ConnectivityCheckerImpl {
  static bool get isOnline => true;

  static Stream<bool> get onConnectivityChanged =>
      const Stream<bool>.empty().asBroadcastStream();

  static Future<bool> checkConnectivity() async => true;
}
