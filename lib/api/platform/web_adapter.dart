// lib/api/platform/web_adapter.dart
import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import '../models/exceptions.dart';
import '../models/headers.dart';
import '../models/request.dart';
import '../models/response.dart';
import 'platform_adapter.dart';

class WebAdapter implements PlatformAdapter {
  @override
  bool get supportsWasm => true;

  @override
  Future<FittorResponse> performRequest(
      FittorRequest request, Stopwatch stopwatch) async {
    final completer = Completer<FittorResponse>();

    final xhr = html.HttpRequest();

    // Set timeout
    final timeout = request.timeout ?? const Duration(seconds: 30);
    xhr.timeout = timeout.inMilliseconds;

    // Handle completion
    xhr.onLoad.listen((_) {
      stopwatch.stop();

      final responseHeaders = FittorHeaders();
      xhr.responseHeaders.forEach((key, value) {
        responseHeaders.set(key, value);
      });

      final bodyBytes = xhr.response is String
          ? Uint8List.fromList((xhr.response as String).codeUnits)
          : Uint8List.fromList((xhr.response as List<int>));

      final response = FittorResponse(
        statusCode: xhr.status ?? 0,
        statusMessage: xhr.statusText ?? '',
        headers: responseHeaders,
        bodyBytes: bodyBytes,
        requestDuration: stopwatch.elapsed,
      );

      completer.complete(response);
    });

    // Handle errors
    xhr.onError.listen((_) {
      stopwatch.stop();
      completer.completeError(
        const FittorNetworkException('Network error occurred'),
      );
    });

    xhr.onTimeout.listen((_) {
      stopwatch.stop();
      completer.completeError(
        FittorTimeoutException('Request timeout', timeout),
      );
    });

    try {
      // Open request
      xhr.open(request.methodName, request.uri.toString());

      // Set headers
      request.headers.toMap().forEach((key, value) {
        xhr.setRequestHeader(key, value);
      });

      // Send request
      if (request.body != null) {
        if (request.body is String) {
          xhr.send(request.body);
        } else if (request.body is List<int>) {
          xhr.send(Uint8List.fromList(request.body));
        } else {
          xhr.send(request.body.toString());
        }
      } else {
        xhr.send();
      }
    } catch (e) {
      stopwatch.stop();
      completer.completeError(
        FittorNetworkException('Failed to send request: $e', e),
      );
    }

    return completer.future;
  }

  @override
  void close() {
    // No cleanup needed for web
  }
}

PlatformAdapter createPlatformAdapter() => WebAdapter();
