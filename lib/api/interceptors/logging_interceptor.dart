import 'dart:async';
import 'dart:developer' as developer;

import '../models/request.dart';
import '../models/response.dart';
import 'base_interceptor.dart';

class LoggingInterceptor extends FittorInterceptor {
  final bool logRequest;
  final bool logResponse;
  final bool logError;
  final String logTag;

  LoggingInterceptor({
    this.logRequest = true,
    this.logResponse = true,
    this.logError = true,
    this.logTag = 'FittorClient',
  });

  @override
  Future<FittorRequest> onRequest(FittorRequest request) async {
    if (logRequest) {
      developer.log(
        '→ ${request.methodName} ${request.uri}',
        name: logTag,
      );

      if (request.headers.toMap().isNotEmpty) {
        developer.log(
          'Headers: ${request.headers.toMap()}',
          name: logTag,
        );
      }

      if (request.body != null) {
        developer.log(
          'Body: ${request.body}',
          name: logTag,
        );
      }
    }
    return request;
  }

  @override
  Future<FittorResponse> onResponse(FittorResponse response) async {
    if (logResponse) {
      developer.log(
        '← ${response.statusCode} ${response.statusMessage} (${response.requestDuration.inMilliseconds}ms)',
        name: logTag,
      );

      if (response.headers.toMap().isNotEmpty) {
        developer.log(
          'Response Headers: ${response.headers.toMap()}',
          name: logTag,
        );
      }

      if (response.bodyBytes.isNotEmpty) {
        final bodyPreview = response.body.length > 1000
            ? '${response.body.substring(0, 1000)}...'
            : response.body;
        developer.log(
          'Response Body: $bodyPreview',
          name: logTag,
        );
      }
    }
    return response;
  }

  @override
  Future<dynamic> onError(dynamic error, StackTrace stackTrace) async {
    if (logError) {
      developer.log(
        '✗ Error: $error',
        name: logTag,
        error: error,
        stackTrace: stackTrace,
      );
    }
    return error;
  }
}
