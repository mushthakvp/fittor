import 'package:flutter/material.dart';

import '../utils/route_utils.dart';
import 'fit_route.dart';

/// Route information parser for FitRouter
class FitRouteInformationParser
    extends RouteInformationParser<RouteInformation> {
  final Map<String, FitRoute> _routes;

  FitRouteInformationParser({required Map<String, FitRoute> routes})
      : _routes = routes;

  @override
  Future<RouteInformation> parseRouteInformation(
      RouteInformation routeInformation) async {
    // Get the path from the URI
    final path = routeInformation.uri.path;

    // Clean up the path - remove any hash fragments and normalize
    final cleanPath = _cleanPath(path);

    // Parse the URL path and extract route information
    final parsed = RouteUtils.parseUrlPath(cleanPath, _routes);

    if (parsed != null) {
      // Valid route found - return configuration with cleaned path
      return RouteInformation(
        uri: Uri.parse(cleanPath),
        state: {
          'routeName': parsed.routeName,
          'arguments': parsed.arguments,
        },
      );
    }

    // Invalid route - check if it's root path
    if (cleanPath == '/' || cleanPath.isEmpty) {
      // Find the first route or initial route
      final initialRouteName = _routes.keys.first;
      return RouteInformation(
        uri: Uri.parse('/'),
        state: {
          'routeName': initialRouteName,
          'arguments': <String, dynamic>{},
        },
      );
    }

    // Return the original information for unknown routes
    return routeInformation;
  }

  @override
  RouteInformation restoreRouteInformation(RouteInformation configuration) {
    return configuration;
  }

  /// Clean up the path by removing hash fragments and normalizing
  String _cleanPath(String path) {
    if (path.isEmpty) return '/';

    // Remove hash fragments
    final hashIndex = path.indexOf('#');
    if (hashIndex != -1) {
      path = path.substring(0, hashIndex);
    }

    // Ensure starts with /
    if (!path.startsWith('/')) {
      path = '/$path';
    }

    // Remove trailing / except for root
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }

    return path;
  }
}
