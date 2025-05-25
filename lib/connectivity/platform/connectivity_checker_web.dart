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
}
