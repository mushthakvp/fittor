import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The core of the FitControl state management system
class Fit {
  // Singleton implementation
  static final Fit _instance = Fit._internal();
  factory Fit() => _instance;
  Fit._internal();

  // Map to store all controllers
  static final Map<String, dynamic> _controllers = {};

  /// Registers a controller with lazy initialization
  static void lazyPut<T>(T Function() creator, {String? tag}) {
    final key = _getKey<T>(tag);
    if (!_controllers.containsKey(key)) {
      _controllers[key] = _Lazy<T>(creator);
    }
  }

  /// Finds a controller by type [T] and optional [tag]
  static T find<T>({String? tag}) {
    final String key = _getKey<T>(tag);

    if (!_controllers.containsKey(key)) {
      throw Exception(
        'Controller of type $T with tag $tag not found. '
        'Make sure to register it using Fit.lazyPut before using Fit.find.',
      );
    }

    final controllerOrLazy = _controllers[key];

    // If it's a lazy instance, initialize it
    if (controllerOrLazy is _Lazy) {
      final instance = controllerOrLazy.create();
      _controllers[key] = instance;
      return instance as T;
    }

    return controllerOrLazy as T;
  }

  /// Directly puts a controller instance
  static void put<T>(T controller, {String? tag}) {
    final key = _getKey<T>(tag);
    _controllers[key] = controller;
  }

  /// Removes a controller
  static void delete<T>({String? tag}) {
    final key = _getKey<T>(tag);
    if (_controllers.containsKey(key)) {
      final controller = _controllers[key];
      if (controller is FitController) {
        controller.onDelete();
      }
      _controllers.remove(key);
    }
  }

  /// Checks if a controller is registered
  static bool isRegistered<T>({String? tag}) {
    return _controllers.containsKey(_getKey<T>(tag));
  }

  /// Helper to generate keys for the controllers map
  static String _getKey<T>(String? tag) {
    return tag == null ? T.toString() : '${T.toString()}_$tag';
  }

  /// Resets all controllers
  static void reset() {
    // Call onDelete for all FitControllers
    for (final controller in _controllers.values) {
      if (controller is FitController) {
        controller.onDelete();
      }
    }
    _controllers.clear();
  }
}

/// Lazy initializer for controllers
class _Lazy<T> {
  final T Function() _creator;

  _Lazy(this._creator);

  T create() => _creator();
}

/// Base class for all controllers in the FitControl system
abstract class FitController {
  final Map<String?, List<FitListener>> _listeners = {};

  /// Called when the controller is being removed
  void onDelete() {}

  /// Updates the UI of all listeners
  void fittor([String? tag]) {
    if (tag != null) {
      // Update only listeners with the specified tag
      _listeners[tag]?.forEach((listener) => listener.update());
    } else {
      // Update all listeners
      for (var listeners in _listeners.values) {
        for (var listener in listeners) {
          listener.update();
        }
      }
    }
  }

  /// Alias for fittor() for backwards compatibility
  void update([String? tag]) => fittor(tag);

  /// Internal method to add a listener
  void addListener(FitListener listener, [String? tag]) {
    if (!_listeners.containsKey(tag)) {
      _listeners[tag] = [];
    }
    _listeners[tag]!.add(listener);
  }

  /// Internal method to remove a listener
  void removeListener(FitListener listener, [String? tag]) {
    if (_listeners.containsKey(tag)) {
      _listeners[tag]!.remove(listener);
      if (_listeners[tag]!.isEmpty) {
        _listeners.remove(tag);
      }
    }
  }
}

/// Internal listener class
class FitListener {
  final Function update;
  FitListener(this.update);
}

/// Extends ValueNotifier to provide a simpler state update mechanism
class FitValue<T> extends ValueNotifier<T> {
  FitValue(super.value);

  // Getter for the current value
  T get val => value;

  // Setter for updating the value
  set val(T newValue) {
    if (value != newValue) {
      value = newValue;
      notifyListeners();
    }
  }
}

/// Extension to convert any value to a FitValue
extension FitValueExtension<T> on T {
  FitValue<T> get fit => FitValue<T>(this);
}
