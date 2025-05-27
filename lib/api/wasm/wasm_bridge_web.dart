import 'dart:async';
import 'dart:js_interop';
import 'dart:js_util';

import '../models/exceptions.dart';
import 'wasm_bridge.dart';

@JS('WasmHttpClient')
external JSObject get wasmHttpClient;

@JS('WasmHttpClient.initialize')
external JSPromise _initializeWasm();

@JS('WasmHttpClient.performRequest')
external JSPromise _performWasmRequest(JSObject options);

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
    if (_isInitialized) return;

    try {
      await _initializeWasm().toDart;
      _isInitialized = true;
    } catch (e) {
      throw FittorWasmException('Failed to initialize WASM: $e', e);
    }
  }

  @override
  Future<Map<String, dynamic>> performHttpRequest({
    required String method,
    required String url,
    required Map<String, String> headers,
    dynamic body,
    required Duration timeout,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final options = jsify({
        'method': method,
        'url': url,
        'headers': headers,
        'body': body,
        'timeout': timeout.inMilliseconds,
      }) as JSObject;

      final result = await _performWasmRequest(options).toDart;
      return dartify(result) as Map<String, dynamic>;
    } catch (e) {
      throw FittorWasmException('WASM request failed: $e', e);
    }
  }

  @override
  void dispose() {
    _isInitialized = false;
  }
}
