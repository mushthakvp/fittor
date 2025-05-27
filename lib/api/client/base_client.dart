import 'dart:async';

import '../interceptors/base_interceptor.dart';
import '../models/headers.dart';
import '../models/request.dart';
import '../models/response.dart';

abstract class FittorBaseClient {
  final List<FittorInterceptor> _interceptors = [];
  final Duration defaultTimeout;
  final bool enableLogging;

  FittorBaseClient({
    this.defaultTimeout = const Duration(seconds: 30),
    this.enableLogging = false,
  });

  void addInterceptor(FittorInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  void removeInterceptor(FittorInterceptor interceptor) {
    _interceptors.remove(interceptor);
  }

  void clearInterceptors() {
    _interceptors.clear();
  }

  Future<FittorResponse> send(FittorRequest request) async {
    var processedRequest = request;

    // Apply request interceptors
    for (final interceptor in _interceptors) {
      processedRequest = await interceptor.onRequest(processedRequest);
    }

    try {
      var response = await performRequest(processedRequest);

      // Apply response interceptors
      for (final interceptor in _interceptors) {
        response = await interceptor.onResponse(response);
      }

      return response;
    } catch (error, stackTrace) {
      // Apply error interceptors
      dynamic processedError = error;
      for (final interceptor in _interceptors) {
        processedError = await interceptor.onError(processedError, stackTrace);
      }

      if (processedError is Exception) {
        throw processedError;
      } else {
        rethrow;
      }
    }
  }

  // Abstract method to be implemented by platform-specific clients
  Future<FittorResponse> performRequest(FittorRequest request);

  // Convenience methods
  Future<FittorResponse> get(String url,
      {Map<String, String>? headers, Map<String, String>? queryParameters}) {
    return send(FittorRequest(
      url: url,
      method: HttpMethod.get,
      headers: headers != null ? FittorHeaders(headers) : null,
      queryParameters: queryParameters,
    ));
  }

  Future<FittorResponse> post(String url,
      {dynamic body,
      Map<String, String>? headers,
      Map<String, String>? queryParameters}) {
    return send(FittorRequest(
      url: url,
      method: HttpMethod.post,
      body: body,
      headers: headers != null ? FittorHeaders(headers) : null,
      queryParameters: queryParameters,
    ));
  }

  Future<FittorResponse> put(String url,
      {dynamic body,
      Map<String, String>? headers,
      Map<String, String>? queryParameters}) {
    return send(FittorRequest(
      url: url,
      method: HttpMethod.put,
      body: body,
      headers: headers != null ? FittorHeaders(headers) : null,
      queryParameters: queryParameters,
    ));
  }

  Future<FittorResponse> delete(String url,
      {Map<String, String>? headers, Map<String, String>? queryParameters}) {
    return send(FittorRequest(
      url: url,
      method: HttpMethod.delete,
      headers: headers != null ? FittorHeaders(headers) : null,
      queryParameters: queryParameters,
    ));
  }

  Future<FittorResponse> patch(String url,
      {dynamic body,
      Map<String, String>? headers,
      Map<String, String>? queryParameters}) {
    return send(FittorRequest(
      url: url,
      method: HttpMethod.patch,
      body: body,
      headers: headers != null ? FittorHeaders(headers) : null,
      queryParameters: queryParameters,
    ));
  }

  void close() {
    // Override in implementations if needed
  }
}
