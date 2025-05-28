// lib/state/core/fit_core.dart
import 'dart:async';

import 'package:flutter/foundation.dart';

/// The core Fit state management system with automatic controller instantiation
class Fit {
  static final Fit _instance = Fit._internal();
  factory Fit() => _instance;
  Fit._internal();

  // Map to store all controller instances
  static final Map<String, FitState> _controllers = {};

  /// Register a factory function for a controller type
  static final Map<String, FitState Function()> _factories = {};

  static void registerFactory<T extends FitState>(T Function() factory) {
    _factories[T.toString()] = factory;
  }

  /// Register controller with explore method (used in FitBindings)
  static void explore<T extends FitState>(T Function() factory) {
    _factories[T.toString()] = factory;
  }

  /// Finds or creates a controller automatically
  static T find<T extends FitState>() {
    final String key = T.toString();

    if (!_controllers.containsKey(key)) {
      // Auto-instantiate the controller
      final controller = _createController<T>();
      _controllers[key] = controller;
      controller._initialize();
    }

    return _controllers[key] as T;
  }

  /// Updated create controller with factory support
  static T _createController<T extends FitState>() {
    final factory = _factories[T.toString()];
    if (factory == null) {
      throw Exception(
          'No factory registered for $T. Use Fit.explore<$T>(() => $T()) '
          'in your FitBindings class before using Fit.find<$T>()');
    }
    return factory() as T;
  }

  /// Reset all controllers
  static void reset() {
    for (final controller in _controllers.values) {
      controller._dispose();
    }
    _controllers.clear();
  }

  /// Check if controller exists
  static bool exists<T extends FitState>() {
    return _controllers.containsKey(T.toString());
  }
}

/// Base class for all state controllers
abstract class FitState {
  // Stream controllers for different update channels
  final StreamController<String?> _updateController =
      StreamController<String?>.broadcast();
  final Map<String, StreamController<dynamic>> _selectorControllers = {};

  bool _isInitialized = false;
  bool _isDisposed = false;

  /// Stream for general updates
  Stream<String?> get updateStream => _updateController.stream;

  /// Called when the controller is first created
  void onInit() {}

  /// Called when the controller is being disposed
  void onClose() {}

  /// Initialize the controller
  void _initialize() {
    if (!_isInitialized) {
      onInit();
      _isInitialized = true;
    }
  }

  /// Dispose the controller
  void _dispose() {
    if (!_isDisposed) {
      onClose();
      _updateController.close();

      // Close all selector streams
      for (final controller in _selectorControllers.values) {
        controller.close();
      }
      _selectorControllers.clear();

      _isDisposed = true;
    }
  }

  /// Update only builders with NO tag or specific tag
  void fittor([String? tag]) {
    if (!_isDisposed) {
      _updateController.add(tag);
    }
  }

  /// Update ALL builders regardless of tags
  void fitAll() {
    if (!_isDisposed) {
      _updateController.add('__ALL__');
    }
  }

  /// Selector system - get or create a stream for specific data
  Stream<T> fitSelect<T>(String key, T Function() selector) {
    if (_isDisposed) return Stream.empty();

    if (!_selectorControllers.containsKey(key)) {
      _selectorControllers[key] = StreamController<T>.broadcast();
    }

    final controller = _selectorControllers[key] as StreamController<T>;

    // Add current value immediately
    try {
      final currentValue = selector();
      if (!controller.isClosed) {
        controller.add(currentValue);
      }
    } catch (e) {
      debugPrint('Error in fitSelect selector: $e');
    }

    return controller.stream;
  }

  /// Update specific selector
  void fitSelectUpdate<T>(String key, T value) {
    if (_isDisposed) return;

    final controller = _selectorControllers[key];
    if (controller != null && !controller.isClosed) {
      (controller as StreamController<T>).add(value);
    }
  }

  /// Auto-update selector based on current state
  void fitSelectRefresh<T>(String key, T Function() selector) {
    if (_isDisposed) return;

    try {
      final newValue = selector();
      fitSelectUpdate<T>(key, newValue);
    } catch (e) {
      debugPrint('Error in fitSelectRefresh: $e');
    }
  }
}

/// Extension for easier controller access
extension FitExtension on Type {
  T find<T extends FitState>() => Fit.find<T>();
}
