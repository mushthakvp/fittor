import 'dart:async';
import 'dart:io';

class ConnectivityCheckerImpl {
  static final List<String> _testUrls = [
    'https://www.google.com/generate_204',
    'https://connectivitycheck.gstatic.com/generate_204',
    'https://clients3.google.com/generate_204',
    'https://www.cloudflare.com/cdn-cgi/trace',
  ];

  static bool _lastKnownStatus = true;
  static Timer? _periodicTimer;
  static StreamController<bool>? _controller;

  static bool get isOnline => _lastKnownStatus;

  static Stream<bool> get onConnectivityChanged {
    _controller ??= StreamController<bool>.broadcast(
      onListen: () {
        // Start periodic checks when someone listens
        _startPeriodicChecks();
      },
      onCancel: () {
        // Stop periodic checks when no one is listening
        _stopPeriodicChecks();
      },
    );
    return _controller!.stream;
  }

  static void _startPeriodicChecks() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      final currentStatus = await checkConnectivity();
      if (currentStatus != _lastKnownStatus) {
        _lastKnownStatus = currentStatus;
        if (_controller != null && !_controller!.isClosed) {
          _controller!.add(currentStatus);
        }
      }
    });
  }

  static void _stopPeriodicChecks() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  static Future<bool> checkConnectivity() async {
    try {
      // First, quick DNS check (faster but less reliable)
      bool dnsWorks = false;
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 2));
        dnsWorks = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (_) {
        dnsWorks = false;
      }

      // If DNS fails, we're definitely offline
      if (!dnsWorks) {
        _lastKnownStatus = false;
        return false;
      }

      // DNS works, now test actual HTTP connectivity
      return await _testHttpConnectivity();
    } catch (_) {
      _lastKnownStatus = false;
      return false;
    }
  }

  static Future<bool> _testHttpConnectivity() async {
    final client = HttpClient();

    try {
      // Configure client for connectivity testing
      client.connectionTimeout = const Duration(seconds: 5);
      client.idleTimeout = const Duration(seconds: 3);

      // Try multiple URLs in parallel for faster results
      final futures = _testUrls.map((url) => _testSingleUrl(client, url));

      // Return true if ANY URL works
      final results = await Future.wait(
        futures,
        eagerError: false, // Don't fail fast, try all URLs
      );

      final isConnected = results.any((result) => result == true);
      _lastKnownStatus = isConnected;
      return isConnected;
    } catch (_) {
      _lastKnownStatus = false;
      return false;
    } finally {
      client.close(force: true);
    }
  }

  static Future<bool> _testSingleUrl(HttpClient client, String url) async {
    try {
      final uri = Uri.parse(url);
      final request =
          await client.getUrl(uri).timeout(const Duration(seconds: 4));

      // Set headers to avoid caching
      request.headers
          .set('Cache-Control', 'no-cache, no-store, must-revalidate');
      request.headers.set('Pragma', 'no-cache');
      request.headers.set('Expires', '0');

      final response =
          await request.close().timeout(const Duration(seconds: 3));

      // Google's generate_204 returns 204, Cloudflare returns 200
      final isSuccess =
          response.statusCode == 204 || response.statusCode == 200;

      // Drain the response to avoid memory leaks
      await response.drain();

      return isSuccess;
    } catch (_) {
      return false;
    }
  }

  // Cleanup method
  static void dispose() {
    _stopPeriodicChecks();
    _controller?.close();
    _controller = null;
  }
}
