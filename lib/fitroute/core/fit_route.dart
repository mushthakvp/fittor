import 'package:flutter/material.dart';
import 'fit_page.dart';

/// Defines a route configuration for FitRouter
class FitRoute {
  /// The path pattern for this route (e.g., '/product/:id')
  final String path;

  /// Builder function that creates the page widget
  final Widget Function(BuildContext context, Map<String, dynamic> arguments)
      builder;

  /// Optional page builder for custom page transitions
  final FitPage Function(BuildContext context, Map<String, dynamic> arguments)?
      pageBuilder;

  /// Whether this route should be added to browser history (web only)
  final bool addToHistory;

  /// Whether arguments should be persisted in storage (web only)
  final bool persistArguments;

  /// Custom transition duration
  final Duration? transitionDuration;

  /// Custom page transition builder
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  )? transitionBuilder;

  /// Route guards - functions that return true if navigation is allowed
  final List<bool Function(Map<String, dynamic> arguments)> guards;

  /// Middleware functions to process arguments before navigation
  final List<Map<String, dynamic> Function(Map<String, dynamic> arguments)>
      middleware;

  const FitRoute({
    required this.path,
    required this.builder,
    this.pageBuilder,
    this.addToHistory = true,
    this.persistArguments = true,
    this.transitionDuration,
    this.transitionBuilder,
    this.guards = const [],
    this.middleware = const [],
  });

  /// Create a route with a custom page
  factory FitRoute.page({
    required String path,
    required FitPage Function(
            BuildContext context, Map<String, dynamic> arguments)
        pageBuilder,
    bool addToHistory = true,
    bool persistArguments = true,
    List<bool Function(Map<String, dynamic> arguments)> guards = const [],
    List<Map<String, dynamic> Function(Map<String, dynamic> arguments)>
        middleware = const [],
  }) {
    return FitRoute(
      path: path,
      builder: (context, arguments) => pageBuilder(context, arguments).child,
      pageBuilder: pageBuilder,
      addToHistory: addToHistory,
      persistArguments: persistArguments,
      guards: guards,
      middleware: middleware,
    );
  }

  /// Create a route with a simple widget builder
  factory FitRoute.builder({
    required String path,
    required Widget Function(
            BuildContext context, Map<String, dynamic> arguments)
        builder,
    bool addToHistory = true,
    bool persistArguments = true,
    Duration? transitionDuration,
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    )? transitionBuilder,
    List<bool Function(Map<String, dynamic> arguments)> guards = const [],
    List<Map<String, dynamic> Function(Map<String, dynamic> arguments)>
        middleware = const [],
  }) {
    return FitRoute(
      path: path,
      builder: builder,
      addToHistory: addToHistory,
      persistArguments: persistArguments,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      guards: guards,
      middleware: middleware,
    );
  }

  /// Check if navigation to this route is allowed
  bool canNavigate(Map<String, dynamic> arguments) {
    for (final guard in guards) {
      if (!guard(arguments)) {
        return false;
      }
    }
    return true;
  }

  /// Process arguments through middleware
  Map<String, dynamic> processArguments(Map<String, dynamic> arguments) {
    Map<String, dynamic> processed = Map.from(arguments);
    for (final middleware in this.middleware) {
      processed = middleware(processed);
    }
    return processed;
  }

  /// Extract parameters from a URL path based on this route's path pattern
  Map<String, dynamic>? extractParameters(String urlPath) {
    final routeSegments = path.split('/').where((s) => s.isNotEmpty).toList();
    final urlSegments = urlPath.split('/').where((s) => s.isNotEmpty).toList();

    if (routeSegments.length != urlSegments.length) {
      return null;
    }

    final parameters = <String, dynamic>{};

    for (int i = 0; i < routeSegments.length; i++) {
      final routeSegment = routeSegments[i];
      final urlSegment = urlSegments[i];

      if (routeSegment.startsWith(':')) {
        // Parameter segment
        final paramName = routeSegment.substring(1);
        parameters[paramName] = Uri.decodeComponent(urlSegment);
      } else if (routeSegment != urlSegment) {
        // Literal segment doesn't match
        return null;
      }
    }

    return parameters;
  }

  /// Generate URL path with given parameters
  String generatePath([Map<String, dynamic>? parameters]) {
    if (parameters == null || parameters.isEmpty) {
      return path.replaceAll(RegExp(r':[^/]+'), '');
    }

    String result = path;
    parameters.forEach((key, value) {
      result =
          result.replaceAll(':$key', Uri.encodeComponent(value.toString()));
    });

    return result;
  }

  /// Check if this route matches a URL path
  bool matches(String urlPath) {
    return extractParameters(urlPath) != null;
  }

  @override
  String toString() {
    return 'FitRoute(path: $path, addToHistory: $addToHistory, persistArguments: $persistArguments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FitRoute && other.path == path;
  }

  @override
  int get hashCode => path.hashCode;
}

/// Represents a parsed route with its name and extracted arguments
class ParsedRoute {
  final String routeName;
  final Map<String, dynamic> arguments;
  final String originalPath;

  const ParsedRoute({
    required this.routeName,
    required this.arguments,
    required this.originalPath,
  });

  @override
  String toString() {
    return 'ParsedRoute(routeName: $routeName, arguments: $arguments, originalPath: $originalPath)';
  }
}
