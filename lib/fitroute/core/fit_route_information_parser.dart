import 'package:flutter/material.dart';

import 'fit_route.dart';
import '../utils/index.dart';

/// Route information parser for FitRouter
class FitRouteInformationParser
    extends RouteInformationParser<RouteInformation> {
  final Map<String, FitRoute> _routes;

  FitRouteInformationParser({required Map<String, FitRoute> routes})
      : _routes = routes;

  @override
  Future<RouteInformation> parseRouteInformation(
      RouteInformation routeInformation) async {
    final path = routeInformation.location;

    // Parse the URL path and extract route information
    final parsed = RouteUtils.parseUrlPath(path, _routes);

    if (parsed != null) {
      // Valid route found
      return RouteInformation(
        uri: Uri.parse(path),
        state: {
          'routeName': parsed.routeName,
          'arguments': parsed.arguments,
        },
      );
    }

    // Invalid route, return original information
    return routeInformation;
  }

  @override
  RouteInformation restoreRouteInformation(RouteInformation configuration) {
    return configuration;
  }
}
