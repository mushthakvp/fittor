import 'dart:async';

import '../models/request.dart';
import '../models/response.dart';

abstract class PlatformAdapter {
  bool get supportsWasm;

  Future<FittorResponse> performRequest(
      FittorRequest request, Stopwatch stopwatch);
  void close();

  factory PlatformAdapter.create() {
    // This will be replaced by conditional imports
    return createPlatformAdapter();
  }
}

// This function will be implemented differently in web_adapter.dart and mobile_adapter.dart
PlatformAdapter createPlatformAdapter() {
  throw UnsupportedError('Platform not supported');
}
