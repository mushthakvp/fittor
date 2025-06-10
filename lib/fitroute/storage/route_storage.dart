import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'storage_interface.dart';
import 'state_persistence.dart';

/// Storage specifically for route-related data
class RouteStorage {
  static const String _routeArgsPrefix = 'fitrouter_args_';
  static const String _currentRouteKey = 'fitrouter_current_route';
  static const String _navigationStackKey = 'fitrouter_navigation_stack';

  late final IStorage _storage;

  RouteStorage() {
    _storage = StatePersistence.createStorage();
  }

  /// Save route arguments for a specific route
  Future<void> saveRouteArguments(
      String routeName, Map<String, dynamic> arguments) async {
    if (!kIsWeb || arguments.isEmpty) return;

    try {
      final key = _routeArgsPrefix + routeName;
      final json = jsonEncode(arguments);
      await _storage.set(key, json);
    } catch (e) {
      debugPrint('Error saving route arguments for $routeName: $e');
    }
  }

  /// Get saved route arguments for a specific route
  Future<Map<String, dynamic>?> getRouteArguments(String routeName) async {
    if (!kIsWeb) return null;

    try {
      final key = _routeArgsPrefix + routeName;
      final json = await _storage.get(key);

      if (json != null) {
        return Map<String, dynamic>.from(jsonDecode(json));
      }
    } catch (e) {
      debugPrint('Error getting route arguments for $routeName: $e');
    }

    return null;
  }

  /// Clear saved route arguments for a specific route
  Future<void> clearRouteArguments(String routeName) async {
    if (!kIsWeb) return;

    try {
      final key = _routeArgsPrefix + routeName;
      await _storage.remove(key);
    } catch (e) {
      debugPrint('Error clearing route arguments for $routeName: $e');
    }
  }

  /// Save current route name
  Future<void> saveCurrentRoute(String routeName) async {
    if (!kIsWeb) return;

    try {
      await _storage.set(_currentRouteKey, routeName);
    } catch (e) {
      debugPrint('Error saving current route: $e');
    }
  }

  /// Get saved current route name
  Future<String?> getCurrentRoute() async {
    if (!kIsWeb) return null;

    try {
      return await _storage.get(_currentRouteKey);
    } catch (e) {
      debugPrint('Error getting current route: $e');
      return null;
    }
  }

  /// Save navigation stack
  Future<void> saveNavigationStack(List<Map<String, dynamic>> stack) async {
    if (!kIsWeb || stack.isEmpty) return;

    try {
      final json = jsonEncode(stack);
      await _storage.set(_navigationStackKey, json);
    } catch (e) {
      debugPrint('Error saving navigation stack: $e');
    }
  }

  /// Get saved navigation stack
  Future<List<Map<String, dynamic>>?> getNavigationStack() async {
    if (!kIsWeb) return null;

    try {
      final json = await _storage.get(_navigationStackKey);

      if (json != null) {
        final List<dynamic> list = jsonDecode(json);
        return list.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (e) {
      debugPrint('Error getting navigation stack: $e');
    }

    return null;
  }

  /// Clear navigation stack
  Future<void> clearNavigationStack() async {
    if (!kIsWeb) return;

    try {
      await _storage.remove(_navigationStackKey);
    } catch (e) {
      debugPrint('Error clearing navigation stack: $e');
    }
  }

  /// Save custom data with a key
  Future<void> saveCustomData(String key, Map<String, dynamic> data) async {
    if (!kIsWeb || data.isEmpty) return;

    try {
      final json = jsonEncode(data);
      await _storage.set('fitrouter_custom_$key', json);
    } catch (e) {
      debugPrint('Error saving custom data for $key: $e');
    }
  }

  /// Get custom data by key
  Future<Map<String, dynamic>?> getCustomData(String key) async {
    if (!kIsWeb) return null;

    try {
      final json = await _storage.get('fitrouter_custom_$key');

      if (json != null) {
        return Map<String, dynamic>.from(jsonDecode(json));
      }
    } catch (e) {
      debugPrint('Error getting custom data for $key: $e');
    }

    return null;
  }

  /// Clear custom data by key
  Future<void> clearCustomData(String key) async {
    if (!kIsWeb) return;

    try {
      await _storage.remove('fitrouter_custom_$key');
    } catch (e) {
      debugPrint('Error clearing custom data for $key: $e');
    }
  }

  /// Clear all route-related data
  Future<void> clearAll() async {
    if (!kIsWeb) return;

    try {
      final keys = await _storage.getAllKeys();
      final routerKeys = keys.where((key) => key.startsWith('fitrouter_'));

      for (final key in routerKeys) {
        await _storage.remove(key);
      }
    } catch (e) {
      debugPrint('Error clearing all route data: $e');
    }
  }

  /// Get all saved route names with arguments
  Future<Map<String, Map<String, dynamic>>> getAllRouteArguments() async {
    if (!kIsWeb) return {};

    try {
      final keys = await _storage.getAllKeys();
      final routeArgKeys =
          keys.where((key) => key.startsWith(_routeArgsPrefix));

      final result = <String, Map<String, dynamic>>{};

      for (final key in routeArgKeys) {
        final routeName = key.substring(_routeArgsPrefix.length);
        final arguments = await getRouteArguments(routeName);

        if (arguments != null) {
          result[routeName] = arguments;
        }
      }

      return result;
    } catch (e) {
      debugPrint('Error getting all route arguments: $e');
      return {};
    }
  }

  /// Check if route has saved arguments
  Future<bool> hasRouteArguments(String routeName) async {
    if (!kIsWeb) return false;

    try {
      final key = _routeArgsPrefix + routeName;
      return await _storage.containsKey(key);
    } catch (e) {
      debugPrint('Error checking route arguments for $routeName: $e');
      return false;
    }
  }

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final keys = await _storage.getAllKeys();
      final routerKeys = keys.where((key) => key.startsWith('fitrouter_'));

      final stats = {
        'totalKeys': keys.length,
        'routerKeys': routerKeys.length,
        'routeArgsCount':
            routerKeys.where((key) => key.startsWith(_routeArgsPrefix)).length,
        'hasCurrentRoute': await _storage.containsKey(_currentRouteKey),
        'hasNavigationStack': await _storage.containsKey(_navigationStackKey),
      };

      return stats;
    } catch (e) {
      debugPrint('Error getting storage stats: $e');
      return {};
    }
  }

  /// Dispose storage
  void dispose() {
    _storage.dispose();
  }
}
