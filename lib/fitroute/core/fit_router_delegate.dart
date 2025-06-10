import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'fit_route.dart';
import 'fit_page.dart';
import '../storage/index.dart';
import '../utils/index.dart';

/// Navigation stack entry
class NavigationEntry {
  final String routeName;
  final Map<String, dynamic> arguments;
  final Page page;

  NavigationEntry({
    required this.routeName,
    required this.arguments,
    required this.page,
  });

  @override
  String toString() {
    return 'NavigationEntry(routeName: $routeName, arguments: $arguments)';
  }
}

/// Router delegate that manages navigation stack
class FitRouterDelegate extends RouterDelegate<RouteInformation>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteInformation> {
  final Map<String, FitRoute> _routes;
  final String _initialRoute;
  final FitRoute? _notFoundRoute;
  final List<NavigatorObserver> _observers;
  final RouteStorage _storage;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final List<NavigationEntry> _navigationStack = [];

  FitRouterDelegate({
    required Map<String, FitRoute> routes,
    required String initialRoute,
    required FitRoute? notFoundRoute,
    required List<NavigatorObserver> observers,
    required GlobalKey<NavigatorState> navigatorKeys,
    required RouteStorage storage,
  })  : _routes = routes,
        _initialRoute = initialRoute,
        _notFoundRoute = notFoundRoute,
        _observers = observers,
        _storage = storage,
        navigatorKey = navigatorKeys {
    _initializeInitialRoute();
  }

  /// Initialize with the initial route
  void _initializeInitialRoute() {
    if (_routes.containsKey(_initialRoute)) {
      _addToStack(_initialRoute, {});
    } else {
      debugPrint('Initial route "$_initialRoute" not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _navigationStack.map((entry) => entry.page).toList(),
      onPopPage: _onPopPage,
      observers: _observers,
    );
  }

  /// Handle pop page
  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }

    if (_navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
      _updateWebUrl();
      notifyListeners();
    }

    return true;
  }

  @override
  Future<void> setNewRoutePath(RouteInformation routeInformation) async {
    final path = routeInformation.location;
    final parsed = RouteUtils.parseUrlPath(path, _routes);

    if (parsed != null) {
      await _navigateToRoute(parsed.routeName,
          arguments: parsed.arguments, replace: true);
    } else {
      await _handleNotFound(path);
    }
  }

  /// Navigate to a named route
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
    bool replace = false,
  }) async {
    return _navigateToRoute<T>(routeName,
        arguments: arguments ?? {}, replace: replace);
  }

  /// Navigate and clear entire stack
  Future<T?> pushNamedAndClearStack<T extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    _navigationStack.clear();
    return _navigateToRoute<T>(routeName, arguments: arguments ?? {});
  }

  /// Pop current route
  void pop<T extends Object?>([T? result]) {
    if (canPop()) {
      navigatorKey.currentState?.pop<T>(result);
    }
  }

  /// Pop until a specific route
  void popUntil(String routeName) {
    while (_navigationStack.length > 1 &&
        _navigationStack.last.routeName != routeName) {
      _navigationStack.removeLast();
    }
    _updateWebUrl();
    notifyListeners();
  }

  /// Check if can pop
  bool canPop() {
    return _navigationStack.length > 1;
  }

  /// Get current route name
  String? get currentRouteName {
    return _navigationStack.isNotEmpty ? _navigationStack.last.routeName : null;
  }

  /// Get current route arguments
  Map<String, dynamic>? get currentArguments {
    return _navigationStack.isNotEmpty ? _navigationStack.last.arguments : null;
  }

  /// Add route dynamically
  void addRoute(String name, FitRoute route) {
    _routes[name] = route;
  }

  /// Remove route dynamically
  void removeRoute(String name) {
    _routes.remove(name);
  }

  /// Restore route state (used for web refresh)
  Future<void> restoreRoute(String routeName,
      {Map<String, dynamic>? arguments}) async {
    _navigationStack.clear();
    await _navigateToRoute(routeName, arguments: arguments ?? {});
  }

  /// Navigate to a route
  Future<T?> _navigateToRoute<T extends Object?>(
    String routeName, {
    Map<String, dynamic> arguments = const {},
    bool replace = false,
  }) async {
    final route = _routes[routeName];
    if (route == null) {
      debugPrint('Route "$routeName" not found');
      return null;
    }

    // Process arguments through middleware
    final processedArguments = route.processArguments(arguments);

    // Check route guards
    if (!route.canNavigate(processedArguments)) {
      debugPrint('Navigation to "$routeName" blocked by guards');
      return null;
    }

    if (replace && _navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
    }

    _addToStack(routeName, processedArguments);

    // Persist arguments if needed (web only)
    if (kIsWeb && route.persistArguments) {
      await _storage.saveRouteArguments(routeName, processedArguments);
    }

    _updateWebUrl();
    notifyListeners();

    return null;
  }

  /// Add entry to navigation stack
  void _addToStack(String routeName, Map<String, dynamic> arguments) {
    final route = _routes[routeName]!;
    final page = _createPage(routeName, route, arguments);

    _navigationStack.add(NavigationEntry(
      routeName: routeName,
      arguments: arguments,
      page: page,
    ));
  }

  /// Create page for route
  Page _createPage(
      String routeName, FitRoute route, Map<String, dynamic> arguments) {
    final key = ValueKey('$routeName-${arguments.hashCode}');

    if (route.pageBuilder != null) {
      return route.pageBuilder!(navigatorKey.currentContext!, arguments);
    }

    // Create default page with route's transition settings
    return FitPage(
      key: key,
      name: routeName,
      arguments: arguments,
      child: route.builder(navigatorKey.currentContext!, arguments),
      transitionType: _getTransitionType(route),
      transitionDuration:
          route.transitionDuration ?? const Duration(milliseconds: 300),
      customTransitionBuilder: route.transitionBuilder,
    );
  }

  /// Get transition type from route
  FitPageTransition _getTransitionType(FitRoute route) {
    if (route.transitionBuilder != null) {
      return FitPageTransition.none; // Custom transition
    }
    return FitPageTransition.slide; // Default
  }

  /// Update web URL
  void _updateWebUrl() {
    if (!kIsWeb || _navigationStack.isEmpty) return;

    final currentEntry = _navigationStack.last;
    final route = _routes[currentEntry.routeName];

    if (route != null && route.addToHistory) {
      final path = route.generatePath(currentEntry.arguments);
      PlatformUtils.updateUrl(path);
    }
  }

  /// Handle not found route
  Future<void> _handleNotFound(String path) async {
    if (_notFoundRoute != null) {
      await _navigateToRoute('notFound', arguments: {'path': path});
    } else {
      debugPrint('Route not found: $path');
      // Navigate to initial route as fallback
      await _navigateToRoute(_initialRoute);
    }
  }

  @override
  RouteInformation? get currentConfiguration {
    if (_navigationStack.isEmpty) return null;

    final currentEntry = _navigationStack.last;
    final route = _routes[currentEntry.routeName];

    if (route != null) {
      final path = route.generatePath(currentEntry.arguments);
      return RouteInformation(uri: Uri.parse(path));
    }

    return null;
  }
}
