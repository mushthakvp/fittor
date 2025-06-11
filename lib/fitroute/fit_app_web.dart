// lib/fitroute/fit_app_web.dart

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import 'core/index.dart';
import 'fit_app_interface.dart';
import 'utils/route_utils.dart';

/// Web-specific implementation of FitAppInterface
class FitAppWeb implements FitAppInterface {
  @override
  String? processInitialUrl(Map<String, FitRoute> routes) {
    try {
      final currentUrl = web.window.location.href;
      final currentPath = web.window.location.pathname;

      // Clean up hash-based URLs
      if (currentUrl.contains('#/')) {
        final hashPath = currentUrl.split('#/')[1];
        final cleanPath = '/$hashPath';

        // Replace the URL without the hash
        web.window.history.replaceState(null, '', cleanPath);
        return _parsePathToRouteName(cleanPath, routes);
      } else if (currentPath != '/' && currentPath.isNotEmpty) {
        // Direct path access
        return _parsePathToRouteName(currentPath, routes);
      }
    } catch (e) {
      // Error processing URL - return null to use default
    }
    return null;
  }

  @override
  RouteInformation? getInitialRouteInfo() {
    final currentPath = web.window.location.pathname;
    final currentSearch = web.window.location.search;
    final fullPath = currentPath + currentSearch;

    if (fullPath != '/' && fullPath.isNotEmpty) {
      return RouteInformation(uri: Uri.parse(fullPath));
    }
    return null;
  }

  /// Parse path to determine route name
  String? _parsePathToRouteName(String path, Map<String, FitRoute> routes) {
    try {
      // Try to find matching route using RouteUtils
      final parsed = RouteUtils.parseUrlPath(path, routes);
      if (parsed != null) {
        return parsed.routeName;
      }

      // Fallback: remove leading/trailing slashes and convert to route name
      final cleanPath = path.replaceAll(RegExp(r'^/+|/+$'), '');
      if (cleanPath.isEmpty) return null;

      // Simple conversion for exact matches
      for (final routeName in routes.keys) {
        final route = routes[routeName]!;
        if (route.path == path || route.path == '/$cleanPath') {
          return routeName;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

/// Factory function for web platform
FitAppInterface createFitAppImplementation() {
  return FitAppWeb();
}
