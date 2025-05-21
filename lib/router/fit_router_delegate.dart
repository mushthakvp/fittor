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

  /// Default transition duration
  final Duration defaultTransitionDuration;

  /// Enable or disable deep linking
  final bool enableDeepLinking;

  /// Enable or disable iOS swipe back gesture
  final bool enableSwipeBack;

  /// Error builder for handling navigation errors

  final Widget Function(BuildContext, Object?)? errorBuilder;

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
    this.defaultTransitionDuration = const Duration(milliseconds: 300),
    this.enableDeepLinking = false,
    this.enableSwipeBack = true,
    this.errorBuilder,
  });

  @override
  State<FitRouterConfig> createState() => _FitRouterConfigState();
}

class _FitRouterConfigState extends State<FitRouterConfig> {
  late final FitRouterController routerController;

  @override
  void initState() {
    super.initState();

    // Initialize bindings if provided
    widget.initialBindings?.forEach((binding) => binding.dependencies());

    // Initialize the router controller
    routerController = FitRouterController(
      pages: widget.routes,
      initialRoute: widget.initialRoute,
      enableSwipeBack: widget.enableSwipeBack,
    );

    // Make controller globally accessible
    if (!Fit.isRegistered<FitRouterController>()) {
      Fit.put(routerController);
    }

    // Process routes to ensure transitions are set
    _processRoutes();
  }

  void _processRoutes() {
    for (var i = 0; i < widget.routes.length; i++) {
      final page = widget.routes[i];
      widget.routes[i] = FitPage(
        name: page.name,
        page: page.page,
        bindings: page.bindings,
        middlewares: page.middlewares,
        transitionDuration:
            page.transitionDuration ?? widget.defaultTransitionDuration,
        customTransition: page.customTransition,
      );
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
      builder: (context, child) {
        // Apply custom builder if provided
        Widget resultChild = child ?? const SizedBox.shrink();

        if (widget.builder != null) {
          resultChild = widget.builder!(context, resultChild);
        }

        return resultChild;
      },
      onUnknownRoute: widget.onUnknownRoute != null
          ? (settings) => MaterialPageRoute(
                builder: widget.onUnknownRoute!,
                settings: settings,
              )
          : null,
      // onUnknownRoute: (settings) {
      //   // Handle truly unknown routes as a last resort
      //   return MaterialPageRoute(
      //     settings: settings,
      //     builder: (context) => const FittorErrorScreen(
      //       message: 'Route not found',
      //     ),
      //   );
      // },
    );
  }

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }
}
