import 'dart:async';

import '../models/exceptions.dart';
import 'wasm_bridge.dart';

class WasmBridgeImpl implements WasmBridge {
  bool _isInitialized = false;
  static WasmBridgeImpl? _instance;

  WasmBridgeImpl._internal();

  factory WasmBridgeImpl() {
    return _instance ??= WasmBridgeImpl._internal();
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    // WASM not supported on this platform
    throw const FittorWasmException('WASM not supported on this platform');
  }

  @override
  Future<Map<String, dynamic>> performHttpRequest({
    required String method,
    required String url,
    required Map<String, String> headers,
    dynamic body,
    required Duration timeout,
  }) async {
    throw const FittorWasmException('WASM not supported on this platform');
  }

  @override
  void dispose() {
    _isInitialized = false;
  }
}
