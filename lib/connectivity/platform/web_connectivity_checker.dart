import 'dart:async';
import 'dart:html' as html;

class ConnectivityCheckerImpl {
  static bool get isOnline {
    try {
      return html.window.navigator.onLine ?? true;
    } catch (e) {
      return true;
    }
  }

  static Stream<bool> get onConnectivityChanged {
    late StreamController<bool> controller;

    controller = StreamController<bool>.broadcast(
      onListen: () {
        // Listen to browser online/offline events
        html.window.addEventListener('online', (event) {
          if (!controller.isClosed) {
            controller.add(true);
          }
        });

        html.window.addEventListener('offline', (event) {
          if (!controller.isClosed) {
            controller.add(false);
          }
        });
      },
    );

    return controller.stream;
  }

  static Future<bool> checkConnectivity() async {
    // For web, we can use multiple approaches
    try {
      // First check navigator.onLine
      if (!html.window.navigator.onLine!) {
        return false;
      }

      // Try to fetch a small resource to verify actual connectivity
      final completer = Completer<bool>();

      // Create a small image request to test connectivity
      final img = html.ImageElement();

      img.onLoad.listen((_) {
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      });

      img.onError.listen((_) {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });

      // Use a reliable CDN endpoint with cache busting
      img.src =
          'https://www.google.com/favicon.ico?t=${DateTime.now().millisecondsSinceEpoch}';

      // Timeout after 5 seconds
      Timer(const Duration(seconds: 5), () {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });

      return await completer.future;
    } catch (e) {
      return false;
    }
  }
}
