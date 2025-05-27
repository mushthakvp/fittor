import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import '../models/exceptions.dart';
import '../models/headers.dart';
import '../models/request.dart';
import '../models/response.dart';
import 'platform_adapter.dart';

class MobileAdapter implements PlatformAdapter {
  final HttpClient _httpClient;

  MobileAdapter() : _httpClient = HttpClient();

  @override
  bool get supportsWasm =>
      false; // Mobile doesn't support WASM in this implementation

  @override
  Future<FittorResponse> performRequest(
      FittorRequest request, Stopwatch stopwatch) async {
    try {
      // Create HTTP request
      final httpRequest = await _httpClient.openUrl(
        request.methodName,
        request.uri,
      );

      // Set timeout

      // Set headers
      request.headers.toMultiMap().forEach((key, values) {
        for (final value in values) {
          httpRequest.headers.add(key, value);
        }
      });

      // Set follow redirects
      httpRequest.followRedirects = request.followRedirects;
      httpRequest.maxRedirects = request.maxRedirects;

      // Write body if present
      if (request.body != null) {
        if (request.body is String) {
          httpRequest.write(request.body);
        } else if (request.body is List<int>) {
          httpRequest.add(request.body);
        } else {
          httpRequest.write(request.body.toString());
        }
      }

      // Send request and get response
      final httpResponse = await httpRequest.close();

      // Read response body
      final bodyBytes = await httpResponse.fold<List<int>>(
        <int>[],
        (previous, element) => previous..addAll(element),
      );

      stopwatch.stop();

      // Build response headers
      final responseHeaders = FittorHeaders();
      httpResponse.headers.forEach((key, values) {
        for (final value in values) {
          responseHeaders.add(key, value);
        }
      });

      return FittorResponse(
        statusCode: httpResponse.statusCode,
        statusMessage: httpResponse.reasonPhrase,
        headers: responseHeaders,
        bodyBytes: Uint8List.fromList(bodyBytes),
        requestDuration: stopwatch.elapsed,
      );
    } on SocketException catch (e) {
      stopwatch.stop();
      throw FittorNetworkException('Socket error: ${e.message}', e);
    } on TimeoutException catch (e) {
      stopwatch.stop();
      throw FittorTimeoutException(
          'Request timeout', request.timeout ?? const Duration(seconds: 30), e);
    } catch (e) {
      stopwatch.stop();
      throw FittorNetworkException('Request failed: $e', e);
    }
  }

  @override
  void close() {
    _httpClient.close();
  }
}

PlatformAdapter createPlatformAdapter() => MobileAdapter();
