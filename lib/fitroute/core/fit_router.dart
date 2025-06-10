import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fit_route.dart';
import 'fit_page.dart';
import 'fit_router_delegate.dart';
import 'fit_route_information_parser.dart';
import '../storage/index.dart';
import '../utils/index.dart';

class FitRouter {
  static FitRouter? _instance;
  static FitRouter get instance => _instance ??= FitRouter._internal();

  FitRouter._internal();

  late FitRouterDelegate _routerDelegate;
  late FitRouteInformationParser _routeInformationParser;
  late RouteStorage _storage;

  final Map<String, FitRoute> _routes = {};
  final List<NavigatorObserver> _observers = [];
  String? _initialRoute;
  FitRoute? _notFoundRoute;
  GlobalKey<NavigatorState>? _navigatorKey;

  /// Initialize the router with routes and configuration
  void initialize({
    required Map<String, FitRoute> routes,
    String? initialRoute,
    FitRoute? notFoundRoute,
    List<NavigatorObserver>? observers,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    _routes.clear();
    _routes.addAll(routes);
    _initialRoute = initialRoute ?? routes.keys.first;
    _notFoundRoute = notFoundRoute;
    _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

    if (observers != null) {
      _observers.clear();
      _observers.addAll(observers);
    }

    _storage = RouteStorage();
    _routerDelegate = FitRouterDelegate(
      routes: _routes,
      initialRoute: _initialRoute!,
      notFoundRoute: _notFoundRoute,
      observers: _observers,
      navigatorKey: _navigatorKey!,
      storage: _storage,
    );

    _routeInformationParser = FitRouteInformationParser(routes: _routes);

    // Restore state on web platform
    if (kIsWeb) {
      _restoreWebState();
    }
  }

  /// Get the router delegate
  FitRouterDelegate get routerDelegate => _routerDelegate;

  /// Get the route information parser
  FitRouteInformationParser get routeInformationParser =>
      _routeInformationParser;

  /// Get the navigator key
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  /// Navigate to a named route
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
    bool replace = false,
  }) async {
    if (!_routes.containsKey(routeName)) {
      debugPrint('Route "$routeName" not found');
      return null;
    }

    return _routerDelegate.pushNamed<T>(
      routeName,
      arguments: arguments,
      replace: replace,
    );
  }

  /// Navigate and replace current route
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
    TO? result,
  }) async {
    return pushNamed<T>(routeName, arguments: arguments, replace: true);
  }

  /// Navigate and clear all previous routes
  Future<T?> pushNamedAndClearStack<T extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    return _routerDelegate.pushNamedAndClearStack<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Pop current route
  void pop<T extends Object?>([T? result]) {
    _routerDelegate.pop<T>(result);
  }

  /// Pop until a specific route
  void popUntil(String routeName) {
    _routerDelegate.popUntil(routeName);
  }

  /// Check if can pop
  bool canPop() {
    return _routerDelegate.canPop();
  }

  /// Get current route name
  String? get currentRouteName => _routerDelegate.currentRouteName;

  /// Get current route arguments
  Map<String, dynamic>? get currentArguments =>
      _routerDelegate.currentArguments;

  /// Add route dynamically
  void addRoute(String name, FitRoute route) {
    _routes[name] = route;
    _routerDelegate.addRoute(name, route);
  }

  /// Remove route dynamically
  void removeRoute(String name) {
    _routes.remove(name);
    _routerDelegate.removeRoute(name);
  }

  /// Get all registered routes
  Map<String, FitRoute> get routes => Map.unmodifiable(_routes);

  /// Generate deep link URL for a route
  String generateDeepLink(String routeName, {Map<String, dynamic>? arguments}) {
    return PlatformUtils.generateDeepLink(routeName, arguments: arguments);
  }

  /// Parse deep link and navigate
  Future<bool> handleDeepLink(String url) async {
    final parsed = PlatformUtils.parseDeepLink(url);
    if (parsed != null && _routes.containsKey(parsed.routeName)) {
      await pushNamed(parsed.routeName, arguments: parsed.arguments);
      return true;
    }
    return false;
  }

  /// Restore web state from URL and storage
  Future<void> _restoreWebState() async {
    if (!kIsWeb) return;

    try {
      // Get current URL path
      final currentPath = PlatformUtils.getCurrentPath();
      if (currentPath != null && currentPath != '/') {
        final parsed = RouteUtils.parseUrlPath(currentPath, _routes);
        if (parsed != null) {
          // Restore saved arguments from storage
          final savedArguments =
              await _storage.getRouteArguments(parsed.routeName);
          final arguments = savedArguments ?? parsed.arguments;

          await _routerDelegate.restoreRoute(parsed.routeName,
              arguments: arguments);
          return;
        }
      }
    } catch (e) {
      debugPrint('Error restoring web state: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _storage.dispose();
  }
}
