import 'package:fittor/fittor.dart';

class FittorValidators {
  static void validateUrl(String url) {
    if (url.isEmpty) {
      throw const FittorException('URL cannot be empty');
    }

    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme) {
        throw const FittorException('URL must have a scheme (http or https)');
      }

      if (uri.scheme != 'http' && uri.scheme != 'https') {
        throw const FittorException('URL scheme must be http or https');
      }

      if (!uri.hasAuthority) {
        throw const FittorException('URL must have a host');
      }
    } catch (e) {
      if (e is FittorException) rethrow;
      throw FittorException('Invalid URL format: $e', e);
    }
  }

  static void validateTimeout(Duration? timeout) {
    if (timeout != null && timeout.isNegative) {
      throw const FittorException('Timeout cannot be negative');
    }
  }

  static void validateMaxRedirects(int maxRedirects) {
    if (maxRedirects < 0) {
      throw const FittorException('Max redirects cannot be negative');
    }
  }

  static void validateHeaderName(String name) {
    if (name.isEmpty) {
      throw const FittorException('Header name cannot be empty');
    }

    // Basic header name validation
    if (name.contains('\n') || name.contains('\r') || name.contains(':')) {
      throw FittorException('Invalid header name: $name');
    }
  }

  static void validateHeaderValue(String value) {
    // Basic header value validation
    if (value.contains('\n') || value.contains('\r')) {
      throw FittorException('Invalid header value: $value');
    }
  }

  static void validateContentType(String? contentType) {
    if (contentType != null && contentType.isEmpty) {
      throw const FittorException('Content-Type cannot be empty string');
    }
  }
}
