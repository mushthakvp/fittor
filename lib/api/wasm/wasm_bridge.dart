import 'dart:async';

import 'wasm_bridge_stub.dart'
    if (dart.library.js_interop) 'wasm_bridge_web.dart';

// This will be the common interface
abstract class WasmBridge {
  bool get isInitialized;

  Future<void> initialize();

  Future<Map<String, dynamic>> performHttpRequest({
    required String method,
    required String url,
    required Map<String, String> headers,
    dynamic body,
    required Duration timeout,
  });

  void dispose();

  factory WasmBridge() = WasmBridgeImpl;
}
