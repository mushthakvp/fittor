// lib/fitroute/fit_app.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../connectivity/connectivity_wrapper.dart';
import 'core/index.dart';
// Conditional import for web functionality
import 'fit_app_interface.dart'
    if (dart.library.js_interop) 'fit_app_web.dart'
    if (dart.library.io) 'fit_app_stub.dart';
import 'utils/platform_utils.dart';
import 'utils/route_utils.dart';

/// FitApp - A replacement for MaterialApp that uses FitRouter with improved browser integration
class FitApp extends StatefulWidget {
  final Map<String, FitRoute> routes;
  final String? initialRoute;
  final FitRoute? notFoundRoute;
  final List<NavigatorObserver>? observers;
  final String title;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final Locale? locale;
  final Iterable<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final bool debugShowCheckedModeBanner;
  final String Function(BuildContext)? onGenerateTitle;
  final Widget Function(BuildContext, Widget?)? builder;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final RouterConfig<Object>? routerConfig;

  /// Whether to restore navigation stack from storage (web only)
  final bool restoreNavigationStack;

  /// Whether to persist navigation history (web only)
  final bool persistNavigationHistory;

  const FitApp({
    super.key,
    required this.routes,
    this.initialRoute,
    this.notFoundRoute,
    this.observers,
    this.title = '',
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.locale,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localizationsDelegates,
    this.debugShowCheckedModeBanner = false,
    this.onGenerateTitle,
    this.builder,
    this.scaffoldMessengerKey,
    this.routerConfig,
    this.restoreNavigationStack = true,
    this.persistNavigationHistory = true,
  });

  @override
  State<FitApp> createState() => _FitAppState();
}

class _FitAppState extends State<FitApp> {
  late FitRouter _router;
  String? _initialRouteFromUrl;
  bool _isInitialized = false;
  late FitAppInterface _implementation;

  @override
  void initState() {
    super.initState();
    _implementation = createFitAppImplementation();
    _processInitialUrl();
    _initializeRouter();
  }

  /// Process initial URL and clean up any hash fragments
  void _processInitialUrl() {
    if (!kIsWeb) return;

    _initialRouteFromUrl = _implementation.processInitialUrl(widget.routes);
  }

  /// Parse path to determine route name
  String? _parsePathToRouteName(String path) {
    try {
      // Try to find matching route using RouteUtils
      final parsed = RouteUtils.parseUrlPath(path, widget.routes);
      if (parsed != null) {
        return parsed.routeName;
      }

      // Fallback: remove leading/trailing slashes and convert to route name
      final cleanPath = path.replaceAll(RegExp(r'^/+|/+$'), '');
      if (cleanPath.isEmpty) return null;

      // Simple conversion for exact matches
      for (final routeName in widget.routes.keys) {
        final route = widget.routes[routeName]!;
        if (route.path == path || route.path == '/$cleanPath') {
          return routeName;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _initializeRouter() {
    _router = FitRouter.instance;

    // Determine effective initial route
    String effectiveInitialRoute;

    if (_initialRouteFromUrl != null &&
        widget.routes.containsKey(_initialRouteFromUrl)) {
      effectiveInitialRoute = _initialRouteFromUrl!;
    } else {
      effectiveInitialRoute = widget.initialRoute ?? widget.routes.keys.first;
    }

    _router.initialize(
      routes: widget.routes,
      initialRoute: effectiveInitialRoute,
      notFoundRoute: widget.notFoundRoute,
      observers: widget.observers,
    );

    _isInitialized = true;
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _router.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        home: ConnectivityWrapper(
          child: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    if (widget.routerConfig != null) {
      return MaterialApp.router(
        title: widget.title,
        theme: widget.theme,
        darkTheme: widget.darkTheme,
        themeMode: widget.themeMode,
        locale: widget.locale,
        supportedLocales: widget.supportedLocales,
        localizationsDelegates: widget.localizationsDelegates,
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        onGenerateTitle: widget.onGenerateTitle,
        builder: widget.builder,
        scaffoldMessengerKey: widget.scaffoldMessengerKey,
        routerConfig: widget.routerConfig,
      );
    }

    // Get initial route information for web
    RouteInformation? initialRouteInfo;
    if (kIsWeb) {
      initialRouteInfo = _implementation.getInitialRouteInfo();
    }

    return MaterialApp.router(
      title: widget.title,
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      themeMode: widget.themeMode,
      locale: widget.locale,
      supportedLocales: widget.supportedLocales,
      localizationsDelegates: widget.localizationsDelegates,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      onGenerateTitle: widget.onGenerateTitle,
      builder: widget.builder,
      scaffoldMessengerKey: widget.scaffoldMessengerKey,
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: PlatformRouteInformationProvider(
        initialRouteInformation:
            initialRouteInfo ?? RouteInformation(uri: Uri.parse('/')),
      ),
    );
  }
}

/// Extension to provide convenient static methods for FitRoute navigation
extension FitGo on FitRoute {
  /// Push a named route
  static Future<T?> push<T extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    return FitRouter.instance.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Push and replace current route
  static Future<T?> pushReplacement<T extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) async {
    return await FitRouter.instance.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// Push and clear all previous routes
  static Future<T?> pushAndClearStack<T extends Object?>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    return FitRouter.instance.pushNamedAndClearStack<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Pop current route
  static void pop<T extends Object?>([T? result]) {
    FitRouter.instance.pop<T>(result);
  }

  /// Pop until a specific route
  static void popUntil(String routeName) {
    FitRouter.instance.popUntil(routeName);
  }

  /// Check if can pop
  static bool canPop() {
    return FitRouter.instance.canPop();
  }

  /// Get current route name
  static String? get currentRoute => FitRouter.instance.currentRouteName;

  /// Get current route arguments
  static Map<String, dynamic>? get currentArguments =>
      FitRouter.instance.currentArguments;

  /// Generate deep link for a route
  static String generateLink(String routeName,
      {Map<String, dynamic>? arguments}) {
    return FitRouter.instance.generateDeepLink(routeName, arguments: arguments);
  }

  /// Handle deep link
  static Future<bool> handleLink(String url) {
    return FitRouter.instance.handleDeepLink(url);
  }

  /// Get navigation debug info
  static Map<String, dynamic> getDebugInfo() {
    final router = FitRouter.instance;
    return {
      'currentRoute': router.currentRouteName,
      'currentArguments': router.currentArguments,
      'canPop': router.canPop(),
      'stackSize': router.routerDelegate.navigationStackSize,
      'navigationStack': router.routerDelegate.navigationStackDebug,
      'platformInfo': PlatformUtils.getDebugInfo(),
    };
  }
}
