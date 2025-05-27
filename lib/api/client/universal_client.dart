import 'dart:async';
import 'dart:typed_data';

import '../models/exceptions.dart';
import '../models/headers.dart';
import '../models/request.dart';
import '../models/response.dart';
import '../platform/platform_adapter.dart';
import '../wasm/wasm_bridge_stub.dart'
    if (dart.library.js_interop) '../wasm/wasm_web.dart';
import 'base_client.dart';

// ../wasm/wasm_bridge_web.dart
class FittorClient extends FittorBaseClient {
  static FittorClient? _instance;
  final PlatformAdapter _platformAdapter;
  final WasmBridge? _wasmBridge;

  FittorClient._internal({
    required PlatformAdapter platformAdapter,
    WasmBridge? wasmBridge,
    super.defaultTimeout,
    super.enableLogging,
  })  : _platformAdapter = platformAdapter,
        _wasmBridge = wasmBridge;

  factory FittorClient({
    Duration defaultTimeout = const Duration(seconds: 30),
    bool enableLogging = false,
    bool useWasm = false,
  }) {
    if (_instance == null) {
      final platformAdapter = PlatformAdapter.create();
      WasmBridge? wasmBridge;

      if (useWasm && platformAdapter.supportsWasm) {
        try {
          wasmBridge = WasmBridge();
        } catch (e) {
          // WASM not supported on this platform, continue without it
          wasmBridge = null;
        }
      }

      _instance = FittorClient._internal(
        platformAdapter: platformAdapter,
        wasmBridge: wasmBridge,
        defaultTimeout: defaultTimeout,
        enableLogging: enableLogging,
      );
    }
    return _instance!;
  }

  static FittorClient get instance => _instance ?? FittorClient();

  @override
  Future<FittorResponse> performRequest(FittorRequest request) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Use WASM if available and enabled
      if (_wasmBridge != null && _wasmBridge.isInitialized) {
        return await _performWasmRequest(request, stopwatch);
      }

      // Fallback to platform-specific implementation
      return await _performPlatformRequest(request, stopwatch);
    } catch (e, stackTrace) {
      stopwatch.stop();
      if (e is FittorException) {
        rethrow;
      } else {
        throw FittorNetworkException('Request failed: $e', e, stackTrace);
      }
    }
  }

  Future<FittorResponse> _performWasmRequest(
      FittorRequest request, Stopwatch stopwatch) async {
    try {
      final result = await _wasmBridge!.performHttpRequest(
        method: request.methodName,
        url: request.uri.toString(),
        headers: request.headers.toMap(),
        body: request.body,
        timeout: request.timeout ?? defaultTimeout,
      );

      stopwatch.stop();

      return FittorResponse(
        statusCode: result['statusCode'],
        statusMessage: result['statusMessage'] ?? '',
        headers: FittorHeaders(result['headers']),
        bodyBytes: Uint8List.fromList(result['body'].cast<int>()),
        requestDuration: stopwatch.elapsed,
      );
    } catch (e) {
      throw FittorWasmException('WASM request failed: $e', e);
    }
  }

  Future<FittorResponse> _performPlatformRequest(
      FittorRequest request, Stopwatch stopwatch) async {
    return await _platformAdapter.performRequest(request, stopwatch);
  }

  @override
  void close() {
    _wasmBridge?.dispose();
    _platformAdapter.close();
    super.close();
  }
}
