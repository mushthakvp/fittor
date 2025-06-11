// lib/fitroute/fit_app_interface.dart

import 'package:flutter/material.dart';

import 'core/index.dart';

/// Abstract interface for FitApp platform-specific functionality
abstract class FitAppInterface {
  String? processInitialUrl(Map<String, FitRoute> routes);
  RouteInformation? getInitialRouteInfo();
}

/// Factory function - will be implemented by platform-specific files
FitAppInterface createFitAppImplementation() {
  throw UnsupportedError('No implementation available for this platform');
}
