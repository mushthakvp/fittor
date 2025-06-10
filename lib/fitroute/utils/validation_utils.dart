import 'package:flutter/foundation.dart';

import '../core/index.dart';
import 'route_utils.dart';

/// Validation result
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  const ValidationResult({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
  });

  /// Create a successful validation result
  factory ValidationResult.success({List<String> warnings = const []}) {
    return ValidationResult(
      isValid: true,
      warnings: warnings,
    );
  }

  /// Create a failed validation result
  factory ValidationResult.failure(List<String> errors,
      {List<String> warnings = const []}) {
    return ValidationResult(
      isValid: false,
      errors: errors,
      warnings: warnings,
    );
  }

  @override
  String toString() {
    if (isValid) {
      return 'ValidationResult: SUCCESS${warnings.isNotEmpty ? ' (${warnings.length} warnings)' : ''}';
    } else {
      return 'ValidationResult: FAILED (${errors.length} errors, ${warnings.length} warnings)';
    }
  }
}

/// Utilities for validating routes and navigation
class ValidationUtils {
  /// Validate a single route configuration
  static ValidationResult validateRoute(String routeName, FitRoute route) {
    final errors = <String>[];
    final warnings = <String>[];

    // Validate route name
    if (routeName.isEmpty) {
      errors.add('Route name cannot be empty');
    } else if (!_isValidRouteName(routeName)) {
      errors.add('Route name "$routeName" contains invalid characters');
    }

    // Validate route path
    if (route.path.isEmpty) {
      errors.add('Route path cannot be empty');
    } else if (!RouteUtils.isValidRoutePattern(route.path)) {
      errors.add('Route path "${route.path}" is not a valid pattern');
    }

    // Check for path normalization issues
    if (route.path != route.path.trim()) {
      warnings.add('Route path has leading/trailing whitespace');
    }

    // Validate path parameters
    final pathParams = RouteUtils.getParameterNames(route.path);
    for (final param in pathParams) {
      if (!_isValidParameterName(param)) {
        errors.add('Parameter name "$param" is invalid');
      }
    }

    // Check for duplicate parameter names
    if (pathParams.length != pathParams.toSet().length) {
      errors.add('Route path contains duplicate parameter names');
    }

    // Validate transition duration
    if (route.transitionDuration != null &&
        route.transitionDuration!.inMilliseconds < 0) {
      errors.add('Transition duration cannot be negative');
    }

    // Check guards
    if (route.guards.isEmpty && route.path.contains('admin')) {
      warnings.add('Admin route without guards might be a security risk');
    }

    return errors.isEmpty
        ? ValidationResult.success(warnings: warnings)
        : ValidationResult.failure(errors, warnings: warnings);
  }

  /// Validate a complete route configuration
  static ValidationResult validateRoutes(Map<String, FitRoute> routes) {
    final errors = <String>[];
    final warnings = <String>[];

    if (routes.isEmpty) {
      errors.add('No routes defined');
      return ValidationResult.failure(errors);
    }

    // Validate each route individually
    for (final entry in routes.entries) {
      final routeName = entry.key;
      final route = entry.value;

      final routeValidation = validateRoute(routeName, route);
      if (!routeValidation.isValid) {
        errors.addAll(routeValidation.errors.map((e) => '$routeName: $e'));
      }
      warnings.addAll(routeValidation.warnings.map((w) => '$routeName: $w'));
    }

    // Check for duplicate paths
    final pathCounts = <String, List<String>>{};
    for (final entry in routes.entries) {
      final routeName = entry.key;
      final path = entry.value.path;

      pathCounts.putIfAbsent(path, () => []).add(routeName);
    }

    for (final entry in pathCounts.entries) {
      if (entry.value.length > 1) {
        errors.add(
            'Duplicate path "${entry.key}" used by routes: ${entry.value.join(', ')}');
      }
    }

    // Check for conflicting route patterns
    final conflictingRoutes = _findConflictingRoutes(routes);
    for (final conflict in conflictingRoutes) {
      errors.add('Conflicting routes: ${conflict.join(' and ')}');
    }

    // Check for unreachable routes
    final unreachableRoutes = _findUnreachableRoutes(routes);
    for (final unreachable in unreachableRoutes) {
      warnings.add(
          'Route "$unreachable" may be unreachable due to conflicting patterns');
    }

    // Validate route hierarchy
    final hierarchyValidation = _validateRouteHierarchy(routes);
    errors.addAll(hierarchyValidation.errors);
    warnings.addAll(hierarchyValidation.warnings);

    return errors.isEmpty
        ? ValidationResult.success(warnings: warnings)
        : ValidationResult.failure(errors, warnings: warnings);
  }

  /// Validate navigation arguments
  static ValidationResult validateArguments(
    String routeName,
    FitRoute route,
    Map<String, dynamic> arguments,
  ) {
    final errors = <String>[];
    final warnings = <String>[];

    // Get required parameters from route path
    final requiredParams = RouteUtils.getParameterNames(route.path);

    // Check for missing required parameters
    for (final param in requiredParams) {
      if (!arguments.containsKey(param) || arguments[param] == null) {
        errors.add('Missing required parameter: $param');
      }
    }

    // Check parameter types and values
    for (final entry in arguments.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) {
        warnings.add('Parameter "$key" is null');
        continue;
      }

      // Validate parameter value
      final paramValidation = _validateParameterValue(key, value);
      if (!paramValidation.isValid) {
        errors.addAll(paramValidation.errors.map((e) => '$key: $e'));
      }
      warnings.addAll(paramValidation.warnings.map((w) => '$key: $w'));
    }

    // Check for extra parameters not used in path
    final extraParams =
        arguments.keys.where((key) => !requiredParams.contains(key));
    if (extraParams.isNotEmpty) {
      warnings
          .add('Extra parameters not used in path: ${extraParams.join(', ')}');
    }

    return errors.isEmpty
        ? ValidationResult.success(warnings: warnings)
        : ValidationResult.failure(errors, warnings: warnings);
  }

  /// Validate a URL path against routes
  static ValidationResult validateUrlPath(
      String path, Map<String, FitRoute> routes) {
    final errors = <String>[];
    final warnings = <String>[];

    if (path.isEmpty) {
      errors.add('URL path cannot be empty');
      return ValidationResult.failure(errors);
    }

    // Check if path can be parsed
    final parsed = RouteUtils.parseUrlPath(path, routes);
    if (parsed == null) {
      errors.add('URL path "$path" does not match any route');
      return ValidationResult.failure(errors);
    }

    // Validate the matched route's arguments
    final route = routes[parsed.routeName]!;
    final argValidation =
        validateArguments(parsed.routeName, route, parsed.arguments);
    if (!argValidation.isValid) {
      errors.addAll(argValidation.errors);
    }
    warnings.addAll(argValidation.warnings);

    return errors.isEmpty
        ? ValidationResult.success(warnings: warnings)
        : ValidationResult.failure(errors, warnings: warnings);
  }

  /// Validate route name format
  static bool _isValidRouteName(String name) {
    // Route names should be alphanumeric with underscores and hyphens
    final regex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_-]*$');
    return regex.hasMatch(name);
  }

  /// Validate parameter name format
  static bool _isValidParameterName(String name) {
    // Parameter names should be valid Dart identifiers
    final regex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
    return regex.hasMatch(name);
  }

  /// Validate parameter value
  static ValidationResult _validateParameterValue(String name, dynamic value) {
    final errors = <String>[];
    final warnings = <String>[];

    if (value == null) {
      warnings.add('Value is null');
      return ValidationResult.success(warnings: warnings);
    }

    // Check for common issues
    final stringValue = value.toString();

    if (stringValue.isEmpty) {
      warnings.add('Value is empty string');
    }

    if (stringValue.contains('/')) {
      warnings.add('Value contains "/" which may cause URL parsing issues');
    }

    if (stringValue.contains('?')) {
      warnings
          .add('Value contains "?" which may interfere with query parameters');
    }

    if (stringValue.contains('#')) {
      warnings.add('Value contains "#" which may interfere with URL fragments');
    }

    // Check for SQL injection patterns (basic check)
    if (_containsSQLInjectionPattern(stringValue)) {
      errors.add('Value contains potential SQL injection pattern');
    }

    // Check for XSS patterns (basic check)
    if (_containsXSSPattern(stringValue)) {
      errors.add('Value contains potential XSS pattern');
    }

    return errors.isEmpty
        ? ValidationResult.success(warnings: warnings)
        : ValidationResult.failure(errors, warnings: warnings);
  }

  /// Check for basic SQL injection patterns
  static bool _containsSQLInjectionPattern(String value) {
    final patterns = [
      'union',
      'select',
      'insert',
      'delete',
      'drop',
      'exec',
      '--',
      ';'
    ];
    final lowerValue = value.toLowerCase();
    return patterns.any((pattern) => lowerValue.contains(pattern));
  }

  /// Check for basic XSS patterns
  static bool _containsXSSPattern(String value) {
    final patterns = ['<script', 'javascript:', 'onerror=', 'onload='];
    final lowerValue = value.toLowerCase();
    return patterns.any((pattern) => lowerValue.contains(pattern));
  }

  /// Find conflicting route patterns
  static List<List<String>> _findConflictingRoutes(
      Map<String, FitRoute> routes) {
    final conflicts = <List<String>>[];
    final routeList = routes.entries.toList();

    for (int i = 0; i < routeList.length; i++) {
      for (int j = i + 1; j < routeList.length; j++) {
        final route1 = routeList[i];
        final route2 = routeList[j];

        if (_routesConflict(route1.value.path, route2.value.path)) {
          conflicts.add([route1.key, route2.key]);
        }
      }
    }

    return conflicts;
  }

  /// Check if two route patterns conflict
  static bool _routesConflict(String pattern1, String pattern2) {
    if (pattern1 == pattern2) return true;

    final segments1 = pattern1.split('/').where((s) => s.isNotEmpty).toList();
    final segments2 = pattern2.split('/').where((s) => s.isNotEmpty).toList();

    if (segments1.length != segments2.length) return false;

    for (int i = 0; i < segments1.length; i++) {
      final seg1 = segments1[i];
      final seg2 = segments2[i];

      // If both are parameters, they conflict
      if (seg1.startsWith(':') && seg2.startsWith(':')) {
        continue;
      }

      // If one is parameter and other is literal, they conflict
      if (seg1.startsWith(':') || seg2.startsWith(':')) {
        continue;
      }

      // If both are literals but different, no conflict
      if (seg1 != seg2) {
        return false;
      }
    }

    return true;
  }

  /// Find potentially unreachable routes
  static List<String> _findUnreachableRoutes(Map<String, FitRoute> routes) {
    final unreachable = <String>[];
    final sortedRoutes = RouteUtils.sortRoutesByPriority(routes);

    for (int i = 0; i < sortedRoutes.length; i++) {
      final currentRoute = sortedRoutes[i];

      for (int j = 0; j < i; j++) {
        final higherPriorityRoute = sortedRoutes[j];

        if (_routeShadows(
            higherPriorityRoute.value.path, currentRoute.value.path)) {
          unreachable.add(currentRoute.key);
          break;
        }
      }
    }

    return unreachable;
  }

  /// Check if one route pattern shadows another
  static bool _routeShadows(String shadowingPattern, String shadowedPattern) {
    final shadowingSegments =
        shadowingPattern.split('/').where((s) => s.isNotEmpty).toList();
    final shadowedSegments =
        shadowedPattern.split('/').where((s) => s.isNotEmpty).toList();

    if (shadowingSegments.length != shadowedSegments.length) return false;

    for (int i = 0; i < shadowingSegments.length; i++) {
      final shadowingSeg = shadowingSegments[i];
      final shadowedSeg = shadowedSegments[i];

      // If shadowing segment is parameter, it can match anything
      if (shadowingSeg.startsWith(':')) {
        continue;
      }

      // If shadowed segment is parameter but shadowing is literal
      if (shadowedSeg.startsWith(':')) {
        return false;
      }

      // Both are literals, must match
      if (shadowingSeg != shadowedSeg) {
        return false;
      }
    }

    return true;
  }

  /// Validate route hierarchy
  static ValidationResult _validateRouteHierarchy(
      Map<String, FitRoute> routes) {
    final errors = <String>[];
    final warnings = <String>[];

    // Check for circular dependencies
    for (final routeName in routes.keys) {
      if (_hasCircularDependency(routeName, routes, [])) {
        errors.add('Circular dependency detected involving route: $routeName');
      }
    }

    return errors.isEmpty
        ? ValidationResult.success(warnings: warnings)
        : ValidationResult.failure(errors, warnings: warnings);
  }

  /// Check for circular dependencies in route hierarchy
  static bool _hasCircularDependency(
    String routeName,
    Map<String, FitRoute> routes,
    List<String> visited,
  ) {
    if (visited.contains(routeName)) {
      return true;
    }

    final route = routes[routeName];
    if (route == null) return false;

    visited.add(routeName);

    // Check parent route (simplified logic)
    final parentPath = RouteUtils.getParentRoute(route.path);
    if (parentPath != null) {
      final parentRoute = routes.entries
          .where((entry) => entry.value.path == parentPath)
          .firstOrNull;

      if (parentRoute != null) {
        if (_hasCircularDependency(parentRoute.key, routes, visited)) {
          return true;
        }
      }
    }

    visited.remove(routeName);
    return false;
  }

  /// Get validation summary
  static Map<String, dynamic> getValidationSummary(
      Map<String, FitRoute> routes) {
    final validation = validateRoutes(routes);
    final stats = RouteUtils.getRouteStatistics(routes);

    return {
      'isValid': validation.isValid,
      'totalErrors': validation.errors.length,
      'totalWarnings': validation.warnings.length,
      'errors': validation.errors,
      'warnings': validation.warnings,
      'statistics': stats,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
