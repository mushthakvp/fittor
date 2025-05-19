// lib/router/fit_router_delegate.dart
import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

/// Widget to configure the MaterialApp with FitRouter
class FitRouterConfig extends StatefulWidget {
  /// Title of the app
  final String title;

  /// List of routes
  final List<FitPage> routes;

  /// Initial route name
  final String initialRoute;

  /// Theme data for light mode
  final ThemeData? theme;

  /// Theme data for dark mode
  final ThemeData? darkTheme;

  /// Theme mode (system, light, dark)
  final ThemeMode themeMode;

  /// Whether to show debug banner
  final bool debugShowCheckedModeBanner;

  /// Initial bindings to initialize
  final List<FitBindings>? initialBindings;

  /// Locale resolutions
  final Locale? locale;
  final List<LocalizationsDelegate>? localizationsDelegates;
  final List<Locale>? supportedLocales;

  /// Builder for wrapping the entire app
  final Widget Function(BuildContext, Widget?)? builder;

  /// Function to handle unknown routes
  final Widget Function(BuildContext)? onUnknownRoute;

  /// Key for the navigator
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Default transition for routes that don't specify one
  final Transition defaultTransition;

  /// Default transition duration
  final Duration defaultTransitionDuration;

  /// Enable or disable deep linking
  final bool enableDeepLinking;

  const FitRouterConfig({
    super.key,
    this.title = '',
    required this.routes,
    required this.initialRoute,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.debugShowCheckedModeBanner = false,
    this.initialBindings,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales,
    this.builder,
    this.onUnknownRoute,
    this.navigatorKey,
    this.defaultTransition = Transition.none,
    this.defaultTransitionDuration = const Duration(milliseconds: 300),
    this.enableDeepLinking = false,
  });

  @override
  State<FitRouterConfig> createState() => _FitRouterConfigState();
}

class _FitRouterConfigState extends State<FitRouterConfig> {
  late final FitRouterController routerController;

  @override
  void initState() {
    super.initState();

    // Initialize the router controller
    routerController = FitRouterController(
      pages: widget.routes,
      initialRoute: widget.initialRoute,
    );
    Fit.put(routerController);

    // Process routes to ensure transitions are set
    _processRoutes();
  }

  void _processRoutes() {
    for (var i = 0; i < widget.routes.length; i++) {
      final page = widget.routes[i];
      if (page.transition == null) {
        widget.routes[i] = FitPage(
          name: page.name,
          page: page.page,
          transition: widget.defaultTransition,
          bindings: page.bindings,
          middlewares: page.middlewares,
          transitionDuration:
              page.transitionDuration ?? widget.defaultTransitionDuration,
          customTransition: page.customTransition,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      themeMode: widget.themeMode,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      initialRoute: widget.initialRoute,
      navigatorKey: widget.navigatorKey ?? routerController.navigatorKey,
      onGenerateRoute: routerController.onGenerateRoute,
      locale: widget.locale,
      localizationsDelegates: widget.localizationsDelegates,
      supportedLocales: widget.supportedLocales ?? const [Locale('en', 'US')],
      builder: widget.builder,
      onUnknownRoute:
          widget.onUnknownRoute != null
              ? (settings) => MaterialPageRoute(
                builder: widget.onUnknownRoute!,
                settings: settings,
              )
              : null,
    );
  }
}
