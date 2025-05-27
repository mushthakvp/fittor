class FittorException implements Exception {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const FittorException(this.message, [this.error, this.stackTrace]);

  @override
  String toString() => 'FittorException: $message';
}

class FittorNetworkException extends FittorException {
  const FittorNetworkException(super.message, [super.error, super.stackTrace]);

  @override
  String toString() => 'FittorNetworkException: $message';
}

class FittorTimeoutException extends FittorException {
  final Duration timeout;

  const FittorTimeoutException(String message, this.timeout,
      [dynamic error, StackTrace? stackTrace])
      : super(message, error, stackTrace);

  @override
  String toString() => 'FittorTimeoutException: $message (timeout: $timeout)';
}

class FittorHttpException extends FittorException {
  final int statusCode;
  final String? statusMessage;

  const FittorHttpException(String message, this.statusCode,
      [this.statusMessage, dynamic error, StackTrace? stackTrace])
      : super(message, error, stackTrace);

  @override
  String toString() =>
      'FittorHttpException: $message ($statusCode ${statusMessage ?? ''})';
}

class FittorParseException extends FittorException {
  const FittorParseException(super.message, [super.error, super.stackTrace]);

  @override
  String toString() => 'FittorParseException: $message';
}

class FittorWasmException extends FittorException {
  const FittorWasmException(super.message, [super.error, super.stackTrace]);

  @override
  String toString() => 'FittorWasmException: $message';
}
