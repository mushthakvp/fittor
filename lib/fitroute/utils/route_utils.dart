import 'package:flutter/foundation.dart';

import '../core/index.dart';

/// Utilities for route operations
class RouteUtils {
  /// Parse URL path to extract route and parameters
  static ParsedRoute? parseUrlPath(String path, Map<String, FitRoute> routes) {
    // Normalize path
    final normalizedPath = _normalizePath(path);

    // Try to match against each route
    for (final entry in routes.entries) {
      final routeName = entry.key;
      final route = entry.value;

      final parameters = route.extractParameters(normalizedPath);
      if (parameters != null) {
        return ParsedRoute(
          routeName: routeName,
          arguments: parameters,
          originalPath: path,
        );
      }
    }

    return null;
  }

  /// Normalize URL path for consistent parsing
  static String _normalizePath(String path) {
    if (path.isEmpty) return '/';

    // Ensure starts with /
    if (!path.startsWith('/')) {
      path = '/$path';
    }

    // Remove trailing / except for root
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }

    // Remove query parameters and fragments
    final questionIndex = path.indexOf('?');
    if (questionIndex != -1) {
      path = path.substring(0, questionIndex);
    }

    final hashIndex = path.indexOf('#');
    if (hashIndex != -1) {
      path = path.substring(0, hashIndex);
    }

    return path;
  }

  /// Generate URL from route and parameters
  static String generateUrl(String routeName, FitRoute route,
      [Map<String, dynamic>? parameters]) {
    final path = route.generatePath(parameters);
    return _normalizePath(path);
  }

  /// Extract path parameters from URL based on route pattern
  static Map<String, String>? extractPathParameters(
      String routePattern, String actualPath) {
    final routeSegments =
        routePattern.split('/').where((s) => s.isNotEmpty).toList();
    final pathSegments =
        actualPath.split('/').where((s) => s.isNotEmpty).toList();

    if (routeSegments.length != pathSegments.length) {
      return null;
    }

    final parameters = <String, String>{};

    for (int i = 0; i < routeSegments.length; i++) {
      final routeSegment = routeSegments[i];
      final pathSegment = pathSegments[i];

      if (routeSegment.startsWith(':')) {
        // Parameter segment
        final paramName = routeSegment.substring(1);
        parameters[paramName] = Uri.decodeComponent(pathSegment);
      } else if (routeSegment != pathSegment) {
        // Literal segment doesn't match
        return null;
      }
    }

    return parameters;
  }

  /// Build path with parameters
  static String buildPathWithParameters(
      String pattern, Map<String, dynamic> parameters) {
    String result = pattern;

    parameters.forEach((key, value) {
      final encodedValue = Uri.encodeComponent(value.toString());
      result = result.replaceAll(':$key', encodedValue);
    });

    // Remove any remaining parameter placeholders
    result = result.replaceAll(RegExp(r':[^/]+'), '');

    return _normalizePath(result);
  }

  /// Check if route pattern matches URL path
  static bool doesRouteMatch(String routePattern, String urlPath) {
    return extractPathParameters(routePattern, urlPath) != null;
  }

  /// Get route priority (more specific routes have higher priority)
  static int getRoutePriority(String routePattern) {
    final segments =
        routePattern.split('/').where((s) => s.isNotEmpty).toList();
    int priority = segments.length * 100;

    // Static segments have higher priority than dynamic ones
    for (final segment in segments) {
      if (!segment.startsWith(':')) {
        priority += 10;
      }
    }

    return priority;
  }

  /// Sort routes by priority (most specific first)
  static List<MapEntry<String, FitRoute>> sortRoutesByPriority(
      Map<String, FitRoute> routes) {
    final entries = routes.entries.toList();

    entries.sort((a, b) {
      final priorityA = getRoutePriority(a.value.path);
      final priorityB = getRoutePriority(b.value.path);
      return priorityB.compareTo(priorityA); // Descending order
    });

    return entries;
  }

  /// Validate route pattern
  static bool isValidRoutePattern(String pattern) {
    if (pattern.isEmpty) return false;

    try {
      // Check for valid parameter syntax
      final paramRegex = RegExp(r':([a-zA-Z_][a-zA-Z0-9_]*)');
      final matches = paramRegex.allMatches(pattern);

      // Check for duplicate parameter names
      final paramNames = <String>{};
      for (final match in matches) {
        final paramName = match.group(1)!;
        if (paramNames.contains(paramName)) {
          return false; // Duplicate parameter
        }
        paramNames.add(paramName);
      }

      // Check for invalid characters
      final validChars = RegExp(r'^[a-zA-Z0-9/_:-]+$');
      if (!validChars.hasMatch(pattern)) {
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error validating route pattern: $e');
      return false;
    }
  }

  /// Extract query parameters from URL
  static Map<String, String> extractQueryParameters(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      return uri.queryParameters;
    }
    return {};
  }

  /// Build URL with query parameters
  static String buildUrlWithQuery(
      String path, Map<String, String> queryParams) {
    if (queryParams.isEmpty) return path;

    final uri = Uri.parse(path);
    final newUri = uri.replace(queryParameters: queryParams);
    return newUri.toString();
  }

  /// Merge route arguments with query parameters
  static Map<String, dynamic> mergeArguments(
    Map<String, dynamic> routeArgs,
    Map<String, String> queryParams,
  ) {
    final merged = Map<String, dynamic>.from(routeArgs);
    queryParams.forEach((key, value) {
      merged[key] = value;
    });
    return merged;
  }

  /// Extract route name from URL path
  static String? extractRouteNameFromPath(
      String path, Map<String, FitRoute> routes) {
    final parsed = parseUrlPath(path, routes);
    return parsed?.routeName;
  }

  /// Check if path represents a valid route
  static bool isValidRoute(String path, Map<String, FitRoute> routes) {
    return parseUrlPath(path, routes) != null;
  }

  /// Get all parameter names from route pattern
  static List<String> getParameterNames(String routePattern) {
    final paramRegex = RegExp(r':([a-zA-Z_][a-zA-Z0-9_]*)');
    final matches = paramRegex.allMatches(routePattern);
    return matches.map((match) => match.group(1)!).toList();
  }

  /// Replace parameters in route pattern with actual values
  static String replaceParametersInPattern(
      String pattern, Map<String, dynamic> parameters) {
    String result = pattern;
    parameters.forEach((key, value) {
      result = result.replaceAll(':$key', value.toString());
    });
    return result;
  }

  /// Get route depth (number of segments)
  static int getRouteDepth(String routePattern) {
    return routePattern.split('/').where((s) => s.isNotEmpty).length;
  }

  /// Check if route is a child of another route
  static bool isChildRoute(String childPattern, String parentPattern) {
    final normalizedChild = _normalizePath(childPattern);
    final normalizedParent = _normalizePath(parentPattern);

    if (normalizedParent == '/') {
      return normalizedChild != '/';
    }

    return normalizedChild.startsWith('$normalizedParent/');
  }

  /// Get parent route pattern
  static String? getParentRoute(String routePattern) {
    final normalized = _normalizePath(routePattern);
    if (normalized == '/') return null;

    final lastSlash = normalized.lastIndexOf('/');
    if (lastSlash <= 0) return '/';

    return normalized.substring(0, lastSlash);
  }

  /// Get route breadcrumbs
  static List<String> getRouteBreadcrumbs(String routePattern) {
    final normalized = _normalizePath(routePattern);
    if (normalized == '/') return ['/'];

    final segments = normalized.split('/').where((s) => s.isNotEmpty).toList();
    final breadcrumbs = <String>[];

    String currentPath = '';
    for (final segment in segments) {
      currentPath += '/$segment';
      breadcrumbs.add(currentPath);
    }

    return breadcrumbs;
  }

  /// Convert route to regex pattern
  static RegExp routeToRegex(String routePattern) {
    String pattern = routePattern;

    // Escape special regex characters
    pattern = pattern.replaceAll(RegExp(r'[.*+?^${}()|[\]\\]'), r'\$&');

    // Replace parameter placeholders with regex groups
    pattern =
        pattern.replaceAll(RegExp(r':([a-zA-Z_][a-zA-Z0-9_]*)'), r'([^/]+)');

    // Ensure exact match
    pattern = '^$pattern\$';

    return RegExp(pattern);
  }

  /// Match route using regex
  static Map<String, String>? matchRouteWithRegex(
      String routePattern, String actualPath) {
    final regex = routeToRegex(routePattern);
    final match = regex.firstMatch(actualPath);

    if (match == null) return null;

    final paramNames = getParameterNames(routePattern);
    final parameters = <String, String>{};

    for (int i = 0; i < paramNames.length; i++) {
      final paramName = paramNames[i];
      final value = match.group(i + 1);
      if (value != null) {
        parameters[paramName] = Uri.decodeComponent(value);
      }
    }

    return parameters;
  }

  /// Get route statistics
  static Map<String, dynamic> getRouteStatistics(Map<String, FitRoute> routes) {
    int staticRoutes = 0;
    int dynamicRoutes = 0;
    int totalParameters = 0;
    int maxDepth = 0;

    for (final route in routes.values) {
      final paramNames = getParameterNames(route.path);
      if (paramNames.isEmpty) {
        staticRoutes++;
      } else {
        dynamicRoutes++;
        totalParameters += paramNames.length;
      }

      final depth = getRouteDepth(route.path);
      if (depth > maxDepth) {
        maxDepth = depth;
      }
    }

    return {
      'totalRoutes': routes.length,
      'staticRoutes': staticRoutes,
      'dynamicRoutes': dynamicRoutes,
      'totalParameters': totalParameters,
      'maxDepth': maxDepth,
      'averageParametersPerDynamicRoute':
          dynamicRoutes > 0 ? totalParameters / dynamicRoutes : 0,
    };
  }
}
