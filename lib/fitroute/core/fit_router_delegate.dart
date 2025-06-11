// lib/fitroute/core/fit_router_delegate.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../storage/index.dart';
import '../utils/index.dart';
import 'fit_page.dart';
import 'fit_route.dart';

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

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'routeName': routeName,
      'arguments': arguments,
    };
  }

  /// Create from JSON
  static NavigationEntry fromJson(Map<String, dynamic> json, Page page) {
    return NavigationEntry(
      routeName: json['routeName'] as String,
      arguments: Map<String, dynamic>.from(json['arguments'] as Map),
      page: page,
    );
  }

  @override
  String toString() {
    return 'NavigationEntry(routeName: $routeName, arguments: $arguments)';
  }
}

/// Fixed context-aware page that properly handles settings
class _ContextAwarePage extends Page {
  final FitRoute route;
  final Map<String, dynamic> routeArguments;

  const _ContextAwarePage({
    required this.route,
    required this.routeArguments,
    super.key,
    super.name,
    super.arguments,
  });

  @override
  Route createRoute(BuildContext context) {
    final fitPage = route.pageBuilder!(context, routeArguments);
    return _CustomPageRoute(page: this, fitPage: fitPage);
  }
}

/// Custom route that ensures settings return the correct page
class _CustomPageRoute<T> extends PageRoute<T> {
  final _ContextAwarePage page;
  final FitPage fitPage;

  _CustomPageRoute({
    required this.page,
    required this.fitPage,
  }) : super(settings: page);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return fitPage.child;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final route = fitPage.createRoute(context);
    if (route is PageRoute) {
      return route.buildTransitions(
          context, animation, secondaryAnimation, child);
    }
    return child;
  }

  @override
  Duration get transitionDuration => fitPage.transitionDuration;

  @override
  Duration get reverseTransitionDuration => fitPage.reverseTransitionDuration;

  @override
  bool get maintainState => fitPage.maintainState;

  @override
  bool get fullscreenDialog => fitPage.fullscreenDialog;

  @override
  Color? get barrierColor => fitPage.barrierColor;

  @override
  bool get barrierDismissible => fitPage.barrierDismissible;

  @override
  String? get barrierLabel => fitPage.barrierLabel;
}

/// Router delegate that manages navigation stack with proper browser integration
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
  bool _isRestoringFromBrowser = false;
  bool _isHandlingBrowserEvent = false;
  bool _isInitialized = false; // Track initialization state

  // Counter to ensure unique keys
  static int _pageCounter = 0;

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
    _setupBrowserIntegration();
    // Initialize synchronously to prevent empty pages
    _initializeInitialRouteSync();
  }

  /// Setup browser integration for web platform
  void _setupBrowserIntegration() {
    if (kIsWeb) {
      // Listen to browser back/forward button events
      PlatformUtils.handleUrlChange(getCurrentPath() ?? '/', (path) {
        if (!_isHandlingBrowserEvent) {
          _handleBrowserNavigation(path);
        }
      });
    }
  }

  /// Handle browser navigation events (back/forward button)
  void _handleBrowserNavigation(String path) async {
    if (_isRestoringFromBrowser) return;

    _isHandlingBrowserEvent = true;
    try {
      final parsed = RouteUtils.parseUrlPath(path, _routes);
      if (parsed != null) {
        // Check if this route is already in our stack
        final existingIndex = _navigationStack.indexWhere(
          (entry) => entry.routeName == parsed.routeName,
        );

        if (existingIndex != -1) {
          // Route exists in stack, pop to that route
          while (_navigationStack.length > existingIndex + 1) {
            _navigationStack.removeLast();
          }
        } else {
          // New route, clear stack and navigate
          _navigationStack.clear();
          await _navigateToRoute(parsed.routeName,
              arguments: parsed.arguments, updateBrowser: false);
        }
        notifyListeners();
      }
    } finally {
      _isHandlingBrowserEvent = false;
    }
  }

  /// Initialize with the initial route synchronously
  void _initializeInitialRouteSync() {
    if (_routes.containsKey(_initialRoute)) {
      _addToStack(_initialRoute, {});
      _isInitialized = true;
    } else {
      if (_routes.isNotEmpty) {
        final firstRoute = _routes.keys.first;
        _addToStack(firstRoute, {});
        _isInitialized = true;
      }
    }

    // Start async initialization for web state restoration in the background
    if (kIsWeb) {
      _initializeWebStateAsync();
    }
  }

  /// Async initialization for web state restoration
  Future<void> _initializeWebStateAsync() async {
    try {
      // Try to restore navigation stack from storage
      final savedStack = await _storage.getNavigationStack();
      if (savedStack != null && savedStack.isNotEmpty) {
        _isRestoringFromBrowser = true;
        try {
          // Clear the current stack and restore from saved state
          _navigationStack.clear();

          for (final entry in savedStack) {
            final routeName = entry['routeName'] as String;
            final arguments =
                Map<String, dynamic>.from(entry['arguments'] as Map);

            if (_routes.containsKey(routeName)) {
              _addToStack(routeName, arguments);
            }
          }
        } finally {
          _isRestoringFromBrowser = false;
        }

        if (_navigationStack.isNotEmpty) {
          notifyListeners();
          return;
        }
      }

      // If no saved state, check current URL
      final currentPath = PlatformUtils.getCurrentPath();
      if (currentPath != null && currentPath != '/') {
        final parsed = RouteUtils.parseUrlPath(currentPath, _routes);
        if (parsed != null && parsed.routeName != _initialRoute) {
          // URL indicates a different route, navigate to it
          _navigationStack.clear();
          await _navigateToRoute(parsed.routeName,
              arguments: parsed.arguments, updateBrowser: false);
        }
      }
    } catch (e) {
      debugPrint('Error during async web state initialization: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always ensure we have at least one page
    if (_navigationStack.isEmpty && _isInitialized) {
      // Fallback: add initial route if somehow we lost all pages
      _initializeInitialRouteSync();
    }

    // If still no pages (shouldn't happen now), show a loading page
    if (_navigationStack.isEmpty) {
      return Navigator(
        key: navigatorKey,
        pages: const [
          MaterialPage(
            key: ValueKey('loading'),
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
        onDidRemovePage: _onDidRemovePage,
        observers: _observers,
      );
    }

    return Navigator(
      key: navigatorKey,
      pages: _navigationStack.map((entry) => entry.page).toList(),
      onDidRemovePage: _onDidRemovePage,
      observers: _observers,
    );
  }

  /// Handle page removal with proper browser history management
  void _onDidRemovePage(Page<Object?> page) {
    final index = _navigationStack.indexWhere((entry) => entry.page == page);
    if (index != -1) {
      _navigationStack.removeAt(index);

      // Ensure we never have an empty stack
      if (_navigationStack.isEmpty) {
        _initializeInitialRouteSync();
      }

      // Update browser URL only if not handling browser event
      if (!_isHandlingBrowserEvent) {
        _updateWebUrl();
      }

      _saveNavigationStack();
      notifyListeners();
    }
  }

  @override
  Future<void> setNewRoutePath(RouteInformation routeInformation) async {
    final path = routeInformation.uri.path;
    final state = routeInformation.state as Map<String, dynamic>?;

    if (state != null && state.containsKey('routeName')) {
      final routeName = state['routeName'] as String;
      final arguments = state['arguments'] as Map<String, dynamic>? ?? {};

      _navigationStack.clear();
      await _navigateToRoute(routeName,
          arguments: arguments, updateBrowser: false);
      return;
    }

    final parsed = RouteUtils.parseUrlPath(path, _routes);
    if (parsed != null) {
      _navigationStack.clear();
      await _navigateToRoute(parsed.routeName,
          arguments: parsed.arguments, updateBrowser: false);
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

  /// Pop current route with proper browser history update
  void pop<T extends Object?>([T? result]) {
    if (canPop()) {
      // Remove the last entry from stack
      if (_navigationStack.length > 1) {
        _navigationStack.removeLast();

        // Update browser URL to previous route
        if (!_isHandlingBrowserEvent) {
          _updateWebUrl();
        }

        _saveNavigationStack();
        notifyListeners();
      }
    }
  }

  /// Pop until a specific route
  void popUntil(String routeName) {
    while (_navigationStack.length > 1 &&
        _navigationStack.last.routeName != routeName) {
      _navigationStack.removeLast();
    }

    if (!_isHandlingBrowserEvent) {
      _updateWebUrl();
    }

    _saveNavigationStack();
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
    await _navigateToRoute(routeName,
        arguments: arguments ?? {}, updateBrowser: false);
  }

  /// Navigate to a route with proper browser integration
  Future<T?> _navigateToRoute<T extends Object?>(
    String routeName, {
    Map<String, dynamic> arguments = const {},
    bool replace = false,
    bool updateBrowser = true,
  }) async {
    final route = _routes[routeName];
    if (route == null) {
      return null;
    }

    final processedArguments = route.processArguments(arguments);

    if (!route.canNavigate(processedArguments)) {
      return null;
    }

    if (replace && _navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
    }

    _addToStack(routeName, processedArguments);

    if (kIsWeb && route.persistArguments) {
      await _storage.saveRouteArguments(routeName, processedArguments);
    }

    if (updateBrowser && !_isHandlingBrowserEvent) {
      _updateWebUrl();
    }

    _saveNavigationStack();
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

  /// Create page for route with unique keys
  Page _createPage(
      String routeName, FitRoute route, Map<String, dynamic> arguments) {
    final uniqueKey = ValueKey(
        '${routeName}_${++_pageCounter}_${DateTime.now().microsecondsSinceEpoch}');

    if (route.pageBuilder != null) {
      return _ContextAwarePage(
        key: uniqueKey,
        name: routeName,
        arguments: arguments,
        route: route,
        routeArguments: arguments,
      );
    }

    return FitPage(
      key: uniqueKey,
      name: routeName,
      arguments: arguments,
      child: Builder(
        builder: (context) => route.builder(context, arguments),
      ),
      transitionType: _getTransitionType(route),
      transitionDuration:
          route.transitionDuration ?? const Duration(milliseconds: 300),
      customTransitionBuilder: route.transitionBuilder,
    );
  }

  /// Get transition type from route
  FitPageTransition _getTransitionType(FitRoute route) {
    if (route.transitionBuilder != null) {
      return FitPageTransition.none;
    }
    return FitPageTransition.slide;
  }

  /// Update web URL with browser history
  void _updateWebUrl() {
    if (!kIsWeb || _navigationStack.isEmpty) return;

    try {
      final currentEntry = _navigationStack.last;
      final route = _routes[currentEntry.routeName];

      if (route != null && route.addToHistory) {
        final path = route.generatePath(currentEntry.arguments);

        // Use pushState if we're navigating forward, replaceState if we're going back
        if (_navigationStack.length > 1) {
          PlatformUtils.updateUrl(path);
        } else {
          // For single routes or when stack is reset, replace state
          PlatformUtils.updateUrl(path);
        }
      }
    } catch (e) {
      debugPrint('Error updating web URL: $e');
    }
  }

  /// Save navigation stack to storage
  void _saveNavigationStack() {
    if (kIsWeb) {
      final stackData =
          _navigationStack.map((entry) => entry.toJson()).toList();
      _storage.saveNavigationStack(stackData);
    }
  }

  /// Handle not found route
  Future<void> _handleNotFound(String path) async {
    if (_notFoundRoute != null) {
      await _navigateToRoute('notFound', arguments: {'path': path});
    } else {
      _navigationStack.clear();
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
      return RouteInformation(
        uri: Uri.parse(path),
        state: {
          'routeName': currentEntry.routeName,
          'arguments': currentEntry.arguments,
        },
      );
    }

    return null;
  }

  /// Get current path for browser integration
  String? getCurrentPath() {
    return PlatformUtils.getCurrentPath();
  }

  /// Get the current navigation stack size
  int get navigationStackSize => _navigationStack.length;

  /// Get navigation stack for debugging purposes
  List<Map<String, dynamic>> get navigationStackDebug {
    return _navigationStack
        .map((entry) => {
              'routeName': entry.routeName,
              'arguments': entry.arguments,
            })
        .toList();
  }
}
