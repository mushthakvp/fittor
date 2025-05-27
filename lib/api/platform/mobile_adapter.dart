// lib/api/platform/mobile_adapter.dart
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
      // Create HTTP request - Fix: Use proper method conversion
      final HttpClientRequest httpRequest;
      switch (request.method) {
        case HttpMethod.get:
          httpRequest = await _httpClient.get(
              request.uri.host, request.uri.port, request.uri.path);
          break;
        case HttpMethod.post:
          httpRequest = await _httpClient.post(
              request.uri.host, request.uri.port, request.uri.path);
          break;
        case HttpMethod.put:
          httpRequest = await _httpClient.put(
              request.uri.host, request.uri.port, request.uri.path);
          break;
        case HttpMethod.delete:
          httpRequest = await _httpClient.delete(
              request.uri.host, request.uri.port, request.uri.path);
          break;
        case HttpMethod.patch:
          httpRequest = await _httpClient.patch(
              request.uri.host, request.uri.port, request.uri.path);
          break;
        case HttpMethod.head:
          httpRequest = await _httpClient.head(
              request.uri.host, request.uri.port, request.uri.path);
          break;
        case HttpMethod.options:
          httpRequest = await _httpClient.open(
              'OPTIONS', request.uri.host, request.uri.port, request.uri.path);
          break;
      }

      // Set timeout
      final timeout = request.timeout ?? const Duration(seconds: 30);

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
      final httpResponse = await httpRequest.close().timeout(timeout);

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
