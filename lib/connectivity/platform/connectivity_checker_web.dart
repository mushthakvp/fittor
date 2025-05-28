import 'dart:async';
import 'dart:html' as html;

class ConnectivityCheckerImpl {
  static StreamController<bool>? _controller;

  static bool get isOnline {
    try {
      return html.window.navigator.onLine ?? true;
    } catch (e) {
      return true;
    }
  }

  static Stream<bool> get onConnectivityChanged {
    _controller ??= StreamController<bool>.broadcast(
      onListen: () {
        html.window.addEventListener('online', (event) {
          if (_controller != null && !_controller!.isClosed) {
            _controller!.add(true);
          }
        });

        html.window.addEventListener('offline', (event) {
          if (_controller != null && !_controller!.isClosed) {
            _controller!.add(false);
          }
        });
      },
    );

    return _controller!.stream;
  }

  static Future<bool> checkConnectivity() async {
    try {
      if (!html.window.navigator.onLine!) {
        return false;
      }

      final completer = Completer<bool>();
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

      img.src =
          'https://www.google.com/favicon.ico?t=${DateTime.now().millisecondsSinceEpoch}';

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

  // Cleanup method
  static void dispose() {
    _controller?.close();
    _controller = null;
  }
}
