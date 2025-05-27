// lib/api/platform/platform_adapter.dart
import 'dart:async';

import '../models/request.dart';
import '../models/response.dart';
// Conditional imports - this is the key fix
import 'platform_adapter_stub.dart'
    if (dart.library.io) 'mobile_adapter.dart'
    if (dart.library.html) 'web_adapter.dart';

abstract class PlatformAdapter {
  bool get supportsWasm;

  Future<FittorResponse> performRequest(
      FittorRequest request, Stopwatch stopwatch);
  void close();

  factory PlatformAdapter.create() {
    return createPlatformAdapter();
  }
}
