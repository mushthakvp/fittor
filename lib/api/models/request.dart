import 'headers.dart';

enum HttpMethod {
  get,
  post,
  put,
  delete,
  patch,
  head,
  options,
}

class FittorRequest {
  final String url;
  final HttpMethod method;
  final FittorHeaders headers;
  final dynamic body;
  final Map<String, String> queryParameters;
  final Duration? timeout;
  final bool followRedirects;
  final int maxRedirects;
  final Map<String, dynamic> extra;

  FittorRequest({
    required this.url,
    required this.method,
    FittorHeaders? headers,
    this.body,
    Map<String, String>? queryParameters,
    this.timeout,
    this.followRedirects = true,
    this.maxRedirects = 5,
    Map<String, dynamic>? extra,
  })  : headers = headers ?? FittorHeaders(),
        queryParameters = queryParameters ?? {},
        extra = extra ?? {};

  String get methodName => method.name.toUpperCase();

  Uri get uri {
    final uri = Uri.parse(url);
    if (queryParameters.isEmpty) return uri;

    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        ...queryParameters,
      },
    );
  }

  FittorRequest copyWith({
    String? url,
    HttpMethod? method,
    FittorHeaders? headers,
    dynamic body,
    Map<String, String>? queryParameters,
    Duration? timeout,
    bool? followRedirects,
    int? maxRedirects,
    Map<String, dynamic>? extra,
  }) {
    return FittorRequest(
      url: url ?? this.url,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      queryParameters: queryParameters ?? this.queryParameters,
      timeout: timeout ?? this.timeout,
      followRedirects: followRedirects ?? this.followRedirects,
      maxRedirects: maxRedirects ?? this.maxRedirects,
      extra: extra ?? this.extra,
    );
  }

  @override
  String toString() {
    return 'FittorRequest($methodName $uri)';
  }
}
