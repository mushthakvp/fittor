import 'dart:typed_data';

import 'headers.dart';

class FittorResponse {
  final int statusCode;
  final String statusMessage;
  final FittorHeaders headers;
  final Uint8List bodyBytes;
  final String? redirectUrl;
  final List<String> redirectHistory;
  final Duration requestDuration;
  final Map<String, dynamic> extra;

  FittorResponse({
    required this.statusCode,
    required this.statusMessage,
    required this.headers,
    required this.bodyBytes,
    this.redirectUrl,
    List<String>? redirectHistory,
    Duration? requestDuration,
    Map<String, dynamic>? extra,
  })  : redirectHistory = redirectHistory ?? [],
        requestDuration = requestDuration ?? Duration.zero,
        extra = extra ?? {};

  String get body => String.fromCharCodes(bodyBytes);

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
  bool get isRedirect => statusCode >= 300 && statusCode < 400;
  bool get isClientError => statusCode >= 400 && statusCode < 500;
  bool get isServerError => statusCode >= 500;

  T? json<T>() {
    try {
      final jsonStr = body;
      if (jsonStr.isEmpty) return null;
      // You would typically use dart:convert here
      // For now, return null if conversion fails
      return null;
    } catch (e) {
      return null;
    }
  }

  FittorResponse copyWith({
    int? statusCode,
    String? statusMessage,
    FittorHeaders? headers,
    Uint8List? bodyBytes,
    String? redirectUrl,
    List<String>? redirectHistory,
    Duration? requestDuration,
    Map<String, dynamic>? extra,
  }) {
    return FittorResponse(
      statusCode: statusCode ?? this.statusCode,
      statusMessage: statusMessage ?? this.statusMessage,
      headers: headers ?? this.headers,
      bodyBytes: bodyBytes ?? this.bodyBytes,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      redirectHistory: redirectHistory ?? this.redirectHistory,
      requestDuration: requestDuration ?? this.requestDuration,
      extra: extra ?? this.extra,
    );
  }

  @override
  String toString() {
    return 'FittorResponse($statusCode $statusMessage)';
  }
}
