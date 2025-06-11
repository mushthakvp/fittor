// lib/fitroute/fit_app_stub.dart

import 'package:flutter/material.dart';

import '../core/fit_route.dart';
import '../fit_app_interface.dart';

/// Stub implementation for mobile platforms
class FitAppStub implements FitAppInterface {
  @override
  String? processInitialUrl(Map<String, FitRoute> routes) {
    // No URL processing needed for mobile platforms
    return null;
  }

  @override
  RouteInformation? getInitialRouteInfo() {
    // No initial route info needed for mobile platforms
    return null;
  }
}

/// Factory function for mobile platforms
FitAppInterface createFitAppImplementation() {
  return FitAppStub();
}
