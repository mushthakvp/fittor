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

    // Set response type to handle binary data properly
    xhr.responseType = 'arraybuffer';

    // Handle completion
    xhr.onLoad.listen((_) {
      stopwatch.stop();

      try {
        final responseHeaders = FittorHeaders();
        xhr.responseHeaders.forEach((key, value) {
          responseHeaders.set(key, value);
        });

        // Handle response body properly based on response type
        Uint8List bodyBytes;
        if (xhr.response != null) {
          if (xhr.response is ByteBuffer) {
            // For arraybuffer response type
            bodyBytes = Uint8List.view(xhr.response as ByteBuffer);
          } else if (xhr.response is String) {
            // Fallback for text responses
            final responseText = xhr.response as String;
            bodyBytes = Uint8List.fromList(responseText.codeUnits);
          } else if (xhr.response is List<int>) {
            bodyBytes = Uint8List.fromList(xhr.response as List<int>);
          } else {
            // Last resort - convert to string then to bytes
            final responseText = xhr.response.toString();
            bodyBytes = Uint8List.fromList(responseText.codeUnits);
          }
        } else {
          bodyBytes = Uint8List(0);
        }

        final response = FittorResponse(
          statusCode: xhr.status ?? 0,
          statusMessage: xhr.statusText ?? '',
          headers: responseHeaders,
          bodyBytes: bodyBytes,
          requestDuration: stopwatch.elapsed,
        );

        completer.complete(response);
      } catch (e) {
        stopwatch.stop();
        completer.completeError(
          FittorNetworkException('Failed to process response: $e', e),
        );
      }
    });

    // Handle errors
    xhr.onError.listen((_) {
      stopwatch.stop();
      completer.completeError(
        FittorNetworkException(
          'Network error occurred: ${xhr.statusText ?? "Unknown error"} (${xhr.status ?? 0})',
        ),
      );
    });

    xhr.onTimeout.listen((_) {
      stopwatch.stop();
      completer.completeError(
        FittorTimeoutException('Request timeout', timeout),
      );
    });

    // Handle abort
    xhr.onAbort.listen((_) {
      stopwatch.stop();
      completer.completeError(
        const FittorNetworkException('Request was aborted'),
      );
    });

    try {
      // Open request with proper URL
      xhr.open(request.methodName, request.uri.toString());

      // Set headers after opening the request
      request.headers.toMap().forEach((key, value) {
        try {
          xhr.setRequestHeader(key, value);
        } catch (e) {
          // Some headers might be restricted by the browser, ignore them
          // e.g., User-Agent, Host, etc.
        }
      });

      // Send request with proper body handling
      if (request.body != null) {
        if (request.body is String) {
          xhr.send(request.body);
        } else if (request.body is List<int>) {
          xhr.send(Uint8List.fromList(request.body));
        } else if (request.body is Uint8List) {
          xhr.send(request.body);
        } else {
          // Convert other types to string
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
