class FittorConstants {
  static const String version = '1.0.0';
  static const String userAgent = 'Fittor/$version';

  // Common HTTP status codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusAccepted = 202;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusMethodNotAllowed = 405;
  static const int statusTimeout = 408;
  static const int statusTooManyRequests = 429;
  static const int statusInternalServerError = 500;
  static const int statusBadGateway = 502;
  static const int statusServiceUnavailable = 503;
  static const int statusGatewayTimeout = 504;

  // Common content types
  static const String contentTypeJson = 'application/json';
  static const String contentTypeFormData = 'application/x-www-form-urlencoded';
  static const String contentTypeMultipart = 'multipart/form-data';
  static const String contentTypeText = 'text/plain';
  static const String contentTypeHtml = 'text/html';
  static const String contentTypeXml = 'application/xml';

  // Common headers
  static const String headerContentType = 'content-type';
  static const String headerContentLength = 'content-length';
  static const String headerAuthorization = 'authorization';
  static const String headerUserAgent = 'user-agent';
  static const String headerAccept = 'accept';
  static const String headerAcceptEncoding = 'accept-encoding';
  static const String headerCacheControl = 'cache-control';
  static const String headerConnection = 'connection';

  // Default timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration defaultConnectTimeout = Duration(seconds: 10);
  static const Duration defaultReceiveTimeout = Duration(seconds: 30);
}
