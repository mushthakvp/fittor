import 'dart:convert';
import 'dart:typed_data';

import '../models/exceptions.dart';
import '../models/headers.dart';
import 'constants.dart';

class FittorHelpers {
  static String buildQueryString(Map<String, dynamic> parameters) {
    if (parameters.isEmpty) return '';

    final buffer = StringBuffer();
    var first = true;

    parameters.forEach((key, value) {
      if (!first) buffer.write('&');
      first = false;

      if (value is List) {
        for (var i = 0; i < value.length; i++) {
          if (i > 0) buffer.write('&');
          buffer.write(
              '${Uri.encodeComponent(key)}=${Uri.encodeComponent(value[i].toString())}');
        }
      } else {
        buffer.write(
            '${Uri.encodeComponent(key)}=${Uri.encodeComponent(value.toString())}');
      }
    });

    return buffer.toString();
  }

  static Map<String, dynamic> parseQueryString(String queryString) {
    final result = <String, dynamic>{};

    if (queryString.isEmpty) return result;

    final parts = queryString.split('&');
    for (final part in parts) {
      final keyValue = part.split('=');
      if (keyValue.length == 2) {
        final key = Uri.decodeComponent(keyValue[0]);
        final value = Uri.decodeComponent(keyValue[1]);

        if (result.containsKey(key)) {
          if (result[key] is List) {
            (result[key] as List).add(value);
          } else {
            result[key] = [result[key], value];
          }
        } else {
          result[key] = value;
        }
      }
    }

    return result;
  }

  static FittorHeaders createDefaultHeaders() {
    return FittorHeaders({
      FittorConstants.headerUserAgent: FittorConstants.userAgent,
      FittorConstants.headerAccept: '*/*',
      FittorConstants.headerConnection: 'keep-alive',
    });
  }

  static Uint8List encodeBody(dynamic body, String? contentType) {
    if (body == null) return Uint8List(0);

    if (body is String) {
      return Uint8List.fromList(utf8.encode(body));
    }

    if (body is List<int>) {
      return Uint8List.fromList(body);
    }

    if (body is Uint8List) {
      return body;
    }

    if (body is Map<String, dynamic>) {
      if (contentType?.contains('application/json') == true) {
        return Uint8List.fromList(utf8.encode(jsonEncode(body)));
      } else {
        // Form data
        final formData = buildQueryString(body);
        return Uint8List.fromList(utf8.encode(formData));
      }
    }

    // Fallback to string conversion
    return Uint8List.fromList(utf8.encode(body.toString()));
  }

  static T? parseJson<T>(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      return decoded is T ? decoded : null;
    } catch (e) {
      throw FittorParseException('Failed to parse JSON: $e', e);
    }
  }

  static bool isSuccessStatusCode(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  static bool isRedirectStatusCode(int statusCode) {
    return statusCode >= 300 && statusCode < 400;
  }

  static bool isClientErrorStatusCode(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  static bool isServerErrorStatusCode(int statusCode) {
    return statusCode >= 500;
  }

  static String getStatusMessage(int statusCode) {
    switch (statusCode) {
      case 200:
        return 'OK';
      case 201:
        return 'Created';
      case 202:
        return 'Accepted';
      case 204:
        return 'No Content';
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 405:
        return 'Method Not Allowed';
      case 408:
        return 'Request Timeout';
      case 429:
        return 'Too Many Requests';
      case 500:
        return 'Internal Server Error';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Service Unavailable';
      case 504:
        return 'Gateway Timeout';
      default:
        return 'Unknown';
    }
  }
}
