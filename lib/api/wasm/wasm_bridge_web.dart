import 'dart:async';
import 'dart:js_interop';

import '../models/exceptions.dart';
import 'wasm_bridge.dart';

// External JS interfaces for modern web APIs
@JS('globalThis.WasmHttpClient')
external JSObject? get wasmHttpClient;

@JS('globalThis.WasmHttpClient.initialize')
external JSPromise? _initializeWasm();

@JS('globalThis.WasmHttpClient.performRequest')
external JSPromise? _performWasmRequest(JSObject options);

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
      // Check if WASM client is available
      if (wasmHttpClient == null) {
        throw const FittorWasmException(
            'WasmHttpClient not available in global scope');
      }

      final initPromise = _initializeWasm();
      if (initPromise == null) {
        throw const FittorWasmException(
            'WasmHttpClient.initialize not available');
      }

      await initPromise.toDart;
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
      final options = <String, dynamic>{
        'method': method,
        'url': url,
        'headers': headers,
        'body': body,
        'timeout': timeout.inMilliseconds,
      }.jsify() as JSObject;

      final requestPromise = _performWasmRequest(options);
      if (requestPromise == null) {
        throw const FittorWasmException(
            'WasmHttpClient.performRequest not available');
      }

      final result = await requestPromise.toDart;
      return (result as JSObject).dartify() as Map<String, dynamic>;
    } catch (e) {
      throw FittorWasmException('WASM request failed: $e', e);
    }
  }

  @override
  void dispose() {
    _isInitialized = false;
  }
}
