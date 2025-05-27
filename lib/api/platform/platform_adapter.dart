// lib/api/platform/platform_adapter.dart
import 'dart:async';

import '../models/request.dart';
import '../models/response.dart';
import 'mobile_adapter.dart';

abstract class PlatformAdapter {
  bool get supportsWasm;

  Future<FittorResponse> performRequest(
      FittorRequest request, Stopwatch stopwatch);
  void close();

  factory PlatformAdapter.create() {
    return createPlatformAdapter();
  }
}
