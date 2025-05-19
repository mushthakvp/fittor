import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

/// Enum defining transition types for routes
enum Transition {
  fade,
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  scale,
  rotate,
  size,
  none,
}

/// Class to define a page in the router
class FitPage {
  /// The name/path of the route (e.g., '/home')
  final String name;

  /// Function that creates the page widget
  final Widget Function() page;

  /// Transition animation to use for this route
  final Transition? transition;

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
  )?
  customTransition;

  const FitPage({
    required this.name,
    required this.page,
    this.transition,
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

  // Current arguments passed to the active route
  dynamic _currentArguments;
  dynamic get arguments => _currentArguments;

  FitRouterController({required this.pages, required this.initialRoute});

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

    switch (page.transition ?? Transition.none) {
      case Transition.fade:
        return PageRouteBuilder(
          settings: RouteSettings(name: page.name, arguments: arguments),
          transitionDuration:
              page.transitionDuration ?? const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => pageWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case Transition.rightToLeft:
        return PageRouteBuilder(
          settings: RouteSettings(name: page.name, arguments: arguments),
          transitionDuration:
              page.transitionDuration ?? const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => pageWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: Curves.easeInOut));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case Transition.leftToRight:
        return PageRouteBuilder(
          settings: RouteSettings(name: page.name, arguments: arguments),
          transitionDuration:
              page.transitionDuration ?? const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => pageWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(-1.0, 0.0);
            var end = Offset.zero;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: Curves.easeInOut));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case Transition.upToDown:
        return PageRouteBuilder(
          settings: RouteSettings(name: page.name, arguments: arguments),
          transitionDuration:
              page.transitionDuration ?? const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => pageWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, -1.0);
            var end = Offset.zero;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: Curves.easeInOut));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case Transition.downToUp:
        return PageRouteBuilder(
          settings: RouteSettings(name: page.name, arguments: arguments),
          transitionDuration:
              page.transitionDuration ?? const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => pageWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, 1.0);
            var end = Offset.zero;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: Curves.easeInOut));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case Transition.scale:
        return PageRouteBuilder(
          settings: RouteSettings(name: page.name, arguments: arguments),
          transitionDuration:
              page.transitionDuration ?? const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => pageWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(scale: animation, child: child);
          },
        );
      case Transition.rotate:
        return PageRouteBuilder(
          settings: RouteSettings(name: page.name, arguments: arguments),
          transitionDuration:
              page.transitionDuration ?? const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => pageWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return RotationTransition(turns: animation, child: child);
          },
        );
      case Transition.size:
        return PageRouteBuilder(
          settings: RouteSettings(name: page.name, arguments: arguments),
          transitionDuration:
              page.transitionDuration ?? const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => pageWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Align(
              child: SizeTransition(sizeFactor: animation, child: child),
            );
          },
        );
      case Transition.none:
        return MaterialPageRoute(
          settings: RouteSettings(name: page.name, arguments: arguments),
          builder: (context) => pageWidget,
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

    // Prevent duplicate navigation
    if (preventDuplicates) {
      // if (navigatorKey.currentState?.routeSettings.name == routeName) {
      //   return null;
      // }
      if (navigatorKey.currentState?.canPop() == true) {
        navigatorKey.currentState?.pop();
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
