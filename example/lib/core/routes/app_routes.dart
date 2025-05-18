import 'package:flutter/material.dart';

import '../../presentation/screen/fitter_view.dart';

/// Handles all the routes for the application
class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String profile = '/profile';

  /// Route generator function for MaterialApp
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const FittorView());
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }

  // Don't allow instantiation
  AppRoutes._();
}
