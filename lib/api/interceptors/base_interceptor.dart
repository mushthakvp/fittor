import 'dart:async';

import '../models/request.dart';
import '../models/response.dart';

/// Base class for all Fittor interceptors
///
/// Interceptors can modify requests before they are sent,
/// modify responses before they are returned to the caller,
/// or handle errors that occur during request processing.
abstract class FittorInterceptor {
  /// Called before a request is sent
  ///
  /// Can modify the request or return a completely new request.
  /// The returned request will be used for the actual HTTP call.
  ///
  /// [request] The original request
  /// Returns the request to be sent (can be modified or replaced)
  Future<FittorRequest> onRequest(FittorRequest request) async => request;

  /// Called after a successful response is received
  ///
  /// Can modify the response or return a completely new response.
  /// The returned response will be passed to the next interceptor
  /// or returned to the caller.
  ///
  /// [response] The received response
  /// Returns the response to be processed (can be modified or replaced)
  Future<FittorResponse> onResponse(FittorResponse response) async => response;

  /// Called when an error occurs during request processing
  ///
  /// Can handle the error, modify it, or return a different error.
  /// If this method returns normally (doesn't throw), the returned
  /// value will be thrown as the final error.
  ///
  /// [error] The error that occurred
  /// [stackTrace] The stack trace when the error occurred
  /// Returns the error to be thrown (can be modified or replaced)
  Future<dynamic> onError(dynamic error, StackTrace stackTrace) async => error;
}

/// Manages a chain of interceptors
///
/// This class is used internally by FittorClient to manage
/// the list of interceptors and their execution order.
class FittorInterceptorChain {
  final List<FittorInterceptor> _interceptors = [];

  /// Adds an interceptor to the end of the chain
  ///
  /// Interceptors are executed in the order they are added:
  /// - For requests: first added = first executed
  /// - For responses: first added = last executed (reverse order)
  /// - For errors: first added = first chance to handle
  void add(FittorInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  /// Removes an interceptor from the chain
  ///
  /// [interceptor] The interceptor instance to remove
  void remove(FittorInterceptor interceptor) {
    _interceptors.remove(interceptor);
  }

  /// Removes all interceptors from the chain
  void clear() {
    _interceptors.clear();
  }

  /// Returns an unmodifiable list of all interceptors
  ///
  /// The interceptors are returned in the order they were added.
  List<FittorInterceptor> get interceptors => List.unmodifiable(_interceptors);

  /// Returns the number of interceptors in the chain
  int get length => _interceptors.length;

  /// Returns true if the chain is empty
  bool get isEmpty => _interceptors.isEmpty;

  /// Returns true if the chain has interceptors
  bool get isNotEmpty => _interceptors.isNotEmpty;

  /// Executes all request interceptors in order
  ///
  /// Each interceptor receives the request returned by the previous one.
  ///
  /// [request] The initial request
  /// Returns the final processed request
  Future<FittorRequest> processRequest(FittorRequest request) async {
    var currentRequest = request;

    for (final interceptor in _interceptors) {
      currentRequest = await interceptor.onRequest(currentRequest);
    }

    return currentRequest;
  }

  /// Executes all response interceptors in reverse order
  ///
  /// Response interceptors are executed in reverse order so that
  /// the last added interceptor processes the response first.
  ///
  /// [response] The initial response
  /// Returns the final processed response
  Future<FittorResponse> processResponse(FittorResponse response) async {
    var currentResponse = response;

    // Execute in reverse order for responses
    for (final interceptor in _interceptors.reversed) {
      currentResponse = await interceptor.onResponse(currentResponse);
    }

    return currentResponse;
  }

  /// Executes all error interceptors in order
  ///
  /// Each interceptor gets a chance to handle or modify the error.
  /// The first interceptor that doesn't rethrow the error will
  /// determine the final error that gets thrown.
  ///
  /// [error] The initial error
  /// [stackTrace] The stack trace when the error occurred
  /// Returns the final error to be thrown
  Future<dynamic> processError(dynamic error, StackTrace stackTrace) async {
    var currentError = error;
    var currentStackTrace = stackTrace;

    for (final interceptor in _interceptors) {
      try {
        currentError =
            await interceptor.onError(currentError, currentStackTrace);
      } catch (newError, newStackTrace) {
        // If an interceptor throws a different error, use that instead
        currentError = newError;
        currentStackTrace = newStackTrace;
      }
    }

    return currentError;
  }
}

/// A simple interceptor that can be created with function callbacks
///
/// This is useful for creating quick interceptors without having to
/// create a full class that extends FittorInterceptor.
///
/// Example:
/// ```dart
/// final loggingInterceptor = CallbackInterceptor(
///   onRequest: (request) async {
///     print('Sending request to ${request.url}');
///     return request;
///   },
///   onResponse: (response) async {
///     print('Received response: ${response.statusCode}');
///     return response;
///   },
/// );
/// ```
class CallbackInterceptor extends FittorInterceptor {
  final Future<FittorRequest> Function(FittorRequest)? _onRequest;
  final Future<FittorResponse> Function(FittorResponse)? _onResponse;
  final Future<dynamic> Function(dynamic, StackTrace)? _onError;

  /// Creates a callback-based interceptor
  ///
  /// [onRequest] Optional callback for request processing
  /// [onResponse] Optional callback for response processing
  /// [onError] Optional callback for error handling
  CallbackInterceptor({
    Future<FittorRequest> Function(FittorRequest)? onRequest,
    Future<FittorResponse> Function(FittorResponse)? onResponse,
    Future<dynamic> Function(dynamic, StackTrace)? onError,
  })  : _onRequest = onRequest,
        _onResponse = onResponse,
        _onError = onError;

  @override
  Future<FittorRequest> onRequest(FittorRequest request) async {
    return _onRequest != null ? await _onRequest(request) : request;
  }

  @override
  Future<FittorResponse> onResponse(FittorResponse response) async {
    return _onResponse != null ? await _onResponse(response) : response;
  }

  @override
  Future<dynamic> onError(dynamic error, StackTrace stackTrace) async {
    return _onError != null ? await _onError(error, stackTrace) : error;
  }
}

/// A conditional interceptor that only executes when a condition is met
///
/// This is useful for creating interceptors that should only run
/// under certain conditions (e.g., only for specific URLs or methods).
///
/// Example:
/// ```dart
/// final conditionalInterceptor = ConditionalInterceptor(
///   condition: (request) => request.url.contains('api.example.com'),
///   interceptor: LoggingInterceptor(),
/// );
/// ```
class ConditionalInterceptor extends FittorInterceptor {
  final bool Function(FittorRequest) condition;
  final FittorInterceptor interceptor;

  /// Creates a conditional interceptor
  ///
  /// [condition] Function that determines whether to execute the interceptor
  /// [interceptor] The interceptor to execute when condition is true
  ConditionalInterceptor({
    required this.condition,
    required this.interceptor,
  });

  @override
  Future<FittorRequest> onRequest(FittorRequest request) async {
    if (condition(request)) {
      return await interceptor.onRequest(request);
    }
    return request;
  }

  @override
  Future<FittorResponse> onResponse(FittorResponse response) async {
    // We can't easily check the original request here, so we always process responses
    // You might want to store the request in the response's extra data for this to work
    return await interceptor.onResponse(response);
  }

  @override
  Future<dynamic> onError(dynamic error, StackTrace stackTrace) async {
    // Always try to handle errors
    return await interceptor.onError(error, stackTrace);
  }
}
