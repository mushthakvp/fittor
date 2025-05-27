// lib/api/platform/platform_adapter_stub.dart
import 'dart:async';

import '../models/exceptions.dart';
import '../models/request.dart';
import '../models/response.dart';
import 'platform_adapter.dart';

class StubAdapter implements PlatformAdapter {
  @override
  bool get supportsWasm => false;

  @override
  Future<FittorResponse> performRequest(
      FittorRequest request, Stopwatch stopwatch) async {
    throw const FittorException(
        'Platform not supported. This should not be called.');
  }

  @override
  void close() {
    // No-op
  }
}

PlatformAdapter createPlatformAdapter() => StubAdapter();
