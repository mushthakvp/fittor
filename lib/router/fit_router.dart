import 'dart:io' show Platform;

import 'package:fittor/fittor.dart';
import 'package:flutter/cupertino.dart';

/// Class to define a page in the router
class FitPage {
  /// The name/path of the route (e.g., '/home')
  final String name;

  /// Function that creates the page widget
  final Widget Function() page;

  /// Optional bindings to initialize before the page loads
  final List<FitBindings>? bindings;

  /// Optional middleware to run before navigating to this page
  final List<FitMiddleware>? middlewares;

  /// Duration of the transition animation
  final Duration? transitionDuration;

  /// Optional custom transition builder
  final Widget Function(
    BuildContext,
    Animation<double>,
    Animation<double>,
    Widget,
  )? customTransition;

  /// Enable/disable iOS swipe back gesture for this specific route

  const FitPage({
    required this.name,
    required this.page,
    this.bindings,
    this.middlewares,
    this.transitionDuration,
    this.customTransition,
  });
}

/// Middleware interface for route guards
abstract class FitMiddleware {
  Future<bool> redirect(String route, dynamic arguments);
}

/// Core router controller that manages navigation
class FitRouterController extends FitController {
  static FitRouterController get to => Fit.find<FitRouterController>();

  final List<FitPage> pages;
  final String initialRoute;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final bool enableSwipeBack;

  // Current arguments passed to the active route
  dynamic _currentArguments;
  dynamic get arguments => _currentArguments;

  FitRouterController({
    required this.pages,
    required this.initialRoute,
    this.enableSwipeBack = true,
  });

  @override
  void onInit() {
    super.onInit();
    // Register self to be globally accessible
    if (!Fit.isRegistered<FitRouterController>()) {
      Fit.put(this);
    }
  }

  // Generate routes for MaterialApp
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name;
    final arguments = settings.arguments;

    // Find the page configuration for this route
    final page = pages.firstWhere(
      (page) => page.name == routeName,
      orElse: () => throw Exception('Route "$routeName" not found'),
    );

    // Store the arguments for access by the page
    _currentArguments = arguments;

    // Initialize bindings if provided
    page.bindings?.forEach((binding) => binding.dependencies());

    // Create the route with appropriate transition
    return _buildRoute(page, arguments);
  }

  // Build a route with specified transition
  Route<dynamic> _buildRoute(FitPage page, dynamic arguments) {
    Widget pageWidget = page.page();

    // Get the allowSwipeBack value for this specific route (default to controller setting)
    const allowSwipeBack = true;

    // For iOS with swipe enabled and custom transition, we need special handling
    bool isIOS = Platform.isIOS;

    // Use custom transition if specified
    if (page.customTransition != null) {
      return _buildCustomTransitionRoute(
        page: page,
        arguments: arguments,
        pageWidget: pageWidget,
        allowSwipeBack: allowSwipeBack && isIOS,
        transitionsBuilder: page.customTransition!,
      );
    }

    // For transitions=none on iOS with swipe back enabled, use pure CupertinoPageRoute

    return CupertinoPageRoute(
      settings: RouteSettings(name: page.name, arguments: arguments),
      builder: (context) => pageWidget,
    );

    // For other transitions
  }

  // Helper method to create custom route with iOS swipe gesture support
  Route<dynamic> _buildCustomTransitionRoute({
    required FitPage page,
    required dynamic arguments,
    required Widget pageWidget,
    required bool allowSwipeBack,
    required Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) transitionsBuilder,
  }) {
    final settings = RouteSettings(name: page.name, arguments: arguments);
    final duration =
        page.transitionDuration ?? const Duration(milliseconds: 300);

    // For iOS with swipe back enabled, use CupertinoPageRoute with custom transitions
    if (Platform.isIOS && allowSwipeBack) {
      return _CupertinoSwipeBackPageRoute(
        builder: (context) => pageWidget,
        settings: settings,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: transitionsBuilder,
      );
    } else {
      // For other cases, use standard PageRouteBuilder
      return PageRouteBuilder(
        settings: settings,
        transitionDuration: duration,
        pageBuilder: (context, animation, secondaryAnimation) => pageWidget,
        transitionsBuilder: transitionsBuilder,
      );
    }
  }

  /// Navigate to a named route
  Future<T?> toNamed<T>(
    String routeName, {
    dynamic arguments,
    bool preventDuplicates = true,
  }) async {
    // Check for middlewares
    final page = pages.firstWhere(
      (page) => page.name == routeName,
      orElse: () => throw Exception('Route "$routeName" not found'),
    );

    // Run middleware checks if present
    if (page.middlewares?.isNotEmpty == true) {
      for (var middleware in page.middlewares!) {
        final shouldProceed = await middleware.redirect(routeName, arguments);
        if (!shouldProceed) {
          // Middleware blocked navigation
          return null;
        }
      }
    }

    // Handle preventDuplicates - note the corrected logic here
    if (preventDuplicates && navigatorKey.currentState != null) {
      // Get current route name
      final currentRoute =
          ModalRoute.of(navigatorKey.currentContext!)?.settings.name;

      // If current route is the same as requested route, pop back instead
      if (currentRoute == routeName) {
        navigatorKey.currentState?.pop();
        return null;
      }
    }

    return navigatorKey.currentState?.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Replace current route with a new named route
  Future<T?> offNamed<T>(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState?.pushReplacementNamed<T, dynamic>(
          routeName,
          arguments: arguments,
        ) ??
        Future.value(null);
  }

  /// Clear all routes and navigate to a named route
  Future<T?> offAllNamed<T>(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
          routeName,
          (_) => false,
          arguments: arguments,
        ) ??
        Future.value(null);
  }

  /// Go back to previous route
  void back<T>([T? result]) {
    if (navigatorKey.currentState?.canPop() == true) {
      navigatorKey.currentState?.pop<T>(result);
    }
  }

  /// Check if can go back
  bool canBack() => navigatorKey.currentState?.canPop() ?? false;
}

/// Custom CupertinoPageRoute that supports iOS swipe back gestures AND custom transitions
class _CupertinoSwipeBackPageRoute<T> extends CupertinoPageRoute<T> {
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) transitionsBuilder;

  final Duration _transitionDuration;
  final Duration _reverseTransitionDuration;

  _CupertinoSwipeBackPageRoute({
    required super.builder,
    required super.settings,
    required this.transitionsBuilder,
    required Duration transitionDuration,
    required Duration reverseTransitionDuration,
    super.maintainState,
    super.fullscreenDialog,
  })  : _transitionDuration = transitionDuration,
        _reverseTransitionDuration = reverseTransitionDuration;
  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Duration get reverseTransitionDuration => _reverseTransitionDuration;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return transitionsBuilder(context, animation, secondaryAnimation, child);
  }
}

/// Static access to router methods
class FitRoute {
  /// Navigate to a named route
  static Future<T?> go<T>(
    String routeName, {
    dynamic pass,
    bool preventDuplicates = true,
  }) {
    return FitRouterController.to.toNamed<T>(
      routeName,
      arguments: pass,
      preventDuplicates: preventDuplicates,
    );
  }

  /// Replace current route with a new named route
  static Future<T?> off<T>(String routeName, {dynamic pass}) {
    return FitRouterController.to.offNamed<T>(routeName, arguments: pass);
  }

  /// Clear all routes and navigate to a named route
  static Future<T?> offAll<T>(String routeName, {dynamic pass}) {
    return FitRouterController.to.offAllNamed<T>(routeName, arguments: pass);
  }

  /// Go back to previous route
  static void back<T>([T? result]) {
    FitRouterController.to.back<T>(result);
  }

  /// Check if can go back
  static bool canBack() => FitRouterController.to.canBack();

  /// Get current arguments
  static dynamic get arguments => FitRouterController.to.arguments;
}

/// Extension on BuildContext for navigation methods
extension FitRouterContextExtension on BuildContext {
  /// Navigate to a named route
  Future<T?> go<T>(
    String routeName, {
    dynamic pass,
    bool preventDuplicates = true,
  }) {
    return FitRoute.go<T>(
      routeName,
      pass: pass,
      preventDuplicates: preventDuplicates,
    );
  }

  /// Replace current route with a new named route
  Future<T?> off<T>(String routeName, {dynamic pass}) {
    return FitRoute.off<T>(routeName, pass: pass);
  }

  /// Clear all routes and navigate to a named route
  Future<T?> offAll<T>(String routeName, {dynamic pass}) {
    return FitRoute.offAll<T>(routeName, pass: pass);
  }

  /// Go back to previous route
  void back<T>([T? result]) {
    FitRoute.back<T>(result);
  }

  /// Check if can go back
  bool canBack() => FitRoute.canBack();
}
