import 'dart:async';

import '../models/exceptions.dart';

class WasmBridge {
  bool _isInitialized = false;
  static WasmBridge? _instance;

  WasmBridge._internal();

  factory WasmBridge() {
    return _instance ??= WasmBridge._internal();
  }

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    // WASM not supported on this platform
    throw const FittorWasmException('WASM not supported on this platform');
  }

  Future<Map<String, dynamic>> performHttpRequest({
    required String method,
    required String url,
    required Map<String, String> headers,
    dynamic body,
    required Duration timeout,
  }) async {
    throw const FittorWasmException('WASM not supported on this platform');
  }

  void dispose() {
    _isInitialized = false;
  }
}
