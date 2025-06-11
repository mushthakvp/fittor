import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import 'core/index.dart';

/// FitApp - A replacement for MaterialApp that uses FitRouter
class FitApp extends StatefulWidget {
  /// Map of route names to FitRoute configurations
  final Map<String, FitRoute> routes;

  /// Initial route name
  final String? initialRoute;

  /// Route to show when no matching route is found
  final FitRoute? notFoundRoute;

  /// Navigator observers
  final List<NavigatorObserver>? observers;

  /// App title
  final String title;

  /// Theme data
  final ThemeData? theme;

  /// Dark theme data
  final ThemeData? darkTheme;

  /// Theme mode
  final ThemeMode? themeMode;

  /// Locale
  final Locale? locale;

  /// Supported locales
  final Iterable<Locale> supportedLocales;

  /// Localizations delegates
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Debug banner
  final bool debugShowCheckedModeBanner;

  /// On generate title callback
  final String Function(BuildContext)? onGenerateTitle;

  /// Builder callback for wrapping the Navigator
  final Widget Function(BuildContext, Widget?)? builder;

  /// Scaffold messenger key
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// Router config (advanced usage)
  final RouterConfig<Object>? routerConfig;

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
    this.debugShowCheckedModeBanner = true,
    this.onGenerateTitle,
    this.builder,
    this.scaffoldMessengerKey,
    this.routerConfig,
  });

  @override
  State<FitApp> createState() => _FitAppState();
}

class _FitAppState extends State<FitApp> {
  late FitRouter _router;
  String? _initialRouteFromUrl;

  @override
  void initState() {
    super.initState();
    _processInitialUrl();
    _initializeRouter();
  }

  /// Process initial URL and clean up any hash fragments
  void _processInitialUrl() {
    if (!kIsWeb) return;

    try {
      final currentUrl = web.window.location.href;
      final currentPath = web.window.location.pathname;

      // Clean up hash-based URLs
      if (currentUrl.contains('#/')) {
        final hashPath = currentUrl.split('#/')[1];
        final cleanPath = '/$hashPath';

        // Replace the URL without the hash
        web.window.history.replaceState(null, '', cleanPath);

        // Set the initial route based on the cleaned path
        _initialRouteFromUrl = _parsePathToRouteName(cleanPath);
      } else if (currentPath != '/' && currentPath.isNotEmpty) {
        // Direct path access
        _initialRouteFromUrl = _parsePathToRouteName(currentPath);
      }
    } catch (e) {
      debugPrint('Error processing initial URL: $e');
    }
  }

  /// Parse path to determine route name
  String? _parsePathToRouteName(String path) {
    // Remove leading/trailing slashes and convert to route name
    final cleanPath = path.replaceAll(RegExp(r'^/+|/+$'), '');
    if (cleanPath.isEmpty) return null;

    // Try to find matching route
    for (final entry in widget.routes.entries) {
      final route = entry.value;
      if (route.extractParameters(path) != null) {
        return entry.key;
      }
    }

    return null;
  }

  void _initializeRouter() {
    _router = FitRouter.instance;

    // Use initial route from URL if available, otherwise use provided initial route
    final effectiveInitialRoute =
        _initialRouteFromUrl ?? widget.initialRoute ?? widget.routes.keys.first;

    _router.initialize(
      routes: widget.routes,
      initialRoute: effectiveInitialRoute,
      notFoundRoute: widget.notFoundRoute,
      observers: widget.observers,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.routerConfig != null) {
      // Use custom router config if provided
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
      final currentPath = web.window.location.pathname;
      if (currentPath != '/' && currentPath.isNotEmpty) {
        initialRouteInfo = RouteInformation(uri: Uri.parse(currentPath));
      }
    }

    // Use FitRouter configuration
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
        initialRouteInformation: initialRouteInfo ??
            RouteInformation(
              uri: Uri.parse('/'),
            ),
      ),
    );
  }
}

/// Extension to provide convenient static methods for FitRoute
extension FitRouteNavigation on FitRoute {
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
}
