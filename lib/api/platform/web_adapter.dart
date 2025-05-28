// lib/api/platform/web_adapter.dart
import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

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

    final xhr = web.XMLHttpRequest();

    // Set timeout
    final timeout = request.timeout ?? const Duration(seconds: 30);
    xhr.timeout = timeout.inMilliseconds;

    // Use text response type for simplicity and compatibility
    xhr.responseType = 'text';

    // Handle load event
    xhr.onload = (web.Event event) {
      stopwatch.stop();

      try {
        final responseHeaders = FittorHeaders();
        final allHeaders = xhr.getAllResponseHeaders();
        if (allHeaders.isNotEmpty) {
          final headerLines = allHeaders.split('\r\n');
          for (final line in headerLines) {
            if (line.trim().isNotEmpty && line.contains(':')) {
              final colonIndex = line.indexOf(':');
              final key = line.substring(0, colonIndex).trim();
              final value = line.substring(colonIndex + 1).trim();
              if (key.isNotEmpty) {
                responseHeaders.set(key, value);
              }
            }
          }
        }

        // Get response body as text and convert to bytes
        final responseText = xhr.responseText;
        final bodyBytes = Uint8List.fromList(utf8.encode(responseText));

        final fittorResponse = FittorResponse(
          statusCode: xhr.status,
          statusMessage: xhr.statusText,
          headers: responseHeaders,
          bodyBytes: bodyBytes,
          requestDuration: stopwatch.elapsed,
        );

        completer.complete(fittorResponse);
      } catch (e) {
        stopwatch.stop();
        completer.completeError(
          FittorNetworkException('Failed to process response: $e', e),
        );
      }
    }.toJS;

    // Handle error
    xhr.onerror = (web.Event event) {
      stopwatch.stop();
      final errorMessage =
          xhr.statusText.isNotEmpty ? xhr.statusText : 'Network error occurred';
      completer.completeError(
        FittorNetworkException('$errorMessage (${xhr.status})'),
      );
    }.toJS;

    // Handle timeout
    xhr.ontimeout = (web.Event event) {
      stopwatch.stop();
      completer.completeError(
        FittorTimeoutException('Request timeout', timeout),
      );
    }.toJS;

    // Handle abort
    xhr.onabort = (web.Event event) {
      stopwatch.stop();
      completer.completeError(
        const FittorNetworkException('Request was aborted'),
      );
    }.toJS;

    try {
      // Open the request
      xhr.open(request.methodName, request.uri.toString());

      // Set headers
      request.headers.toMap().forEach((key, value) {
        try {
          xhr.setRequestHeader(key, value);
        } catch (e) {
          // Some headers are restricted by browsers, silently ignore
        }
      });

      // Send the request
      if (request.body != null) {
        if (request.body is String) {
          xhr.send((request.body as String).toJS);
        } else {
          // Convert other body types to string for simplicity
          xhr.send(request.body.toString().toJS);
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
    // No cleanup needed for web platform
  }
}

PlatformAdapter createPlatformAdapter() => WebAdapter();
