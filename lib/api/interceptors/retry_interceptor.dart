import 'dart:async';
import 'dart:math';

import '../models/exceptions.dart';
import 'base_interceptor.dart';

class RetryInterceptor extends FittorInterceptor {
  final int maxRetries;
  final Duration baseDelay;
  final Duration maxDelay;
  final double backoffMultiplier;
  final bool retryOnTimeout;
  final bool retryOnConnectionError;
  final List<int> retryStatusCodes;

  RetryInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 1000),
    this.maxDelay = const Duration(seconds: 30),
    this.backoffMultiplier = 2.0,
    this.retryOnTimeout = true,
    this.retryOnConnectionError = true,
    this.retryStatusCodes = const [408, 429, 500, 502, 503, 504],
  });

  @override
  Future<dynamic> onError(dynamic error, StackTrace stackTrace) async {
    if (!_shouldRetry(error)) {
      return error;
    }

    // This would need to be implemented with access to the client
    // For now, we'll return the error as-is
    return error;
  }

  bool _shouldRetry(dynamic error) {
    if (error is FittorTimeoutException && retryOnTimeout) {
      return true;
    }

    if (error is FittorNetworkException && retryOnConnectionError) {
      return true;
    }

    if (error is FittorHttpException &&
        retryStatusCodes.contains(error.statusCode)) {
      return true;
    }

    return false;
  }

  Duration calculateDelay(int attempt) {
    final delay = Duration(
      milliseconds:
          (baseDelay.inMilliseconds * pow(backoffMultiplier, attempt)).round(),
    );

    return delay > maxDelay ? maxDelay : delay;
  }
}
