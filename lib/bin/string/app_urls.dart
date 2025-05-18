String appUrls = '''
class FitUrls {
  String baseUrl = 'https://api.fittor.com';

  String get sendOtpUrl => 'baseUrl/send-otp';

  String get verifyOtpUrl => 'baseUrl/verify-otp';
}
''';

String appRoutes = '''
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
''';

String sampleModel = '''
/// Sample data model class
class FitModel {
  final int id;
  final String title;
  final String description;

  FitModel({required this.id, required this.title, required this.description});

  factory FitModel.fromJson(Map<String, dynamic> json) {
    return FitModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
''';

String fittorSampleRepo = '''
abstract class FitterSampleRepo {
  Future<bool> sendOtp({required String number});
  Future<void> verifyOtp({required String number, required String otp});
}
''';

String apiClient = '''
/// Base API client for handling network requests
class ApiClient {

// Implement your API client methods here

}
''';

String fitColor = '''
import 'package:flutter/material.dart';

class FitColor {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFF44336);
  static const Color green = Color(0xFF4CAF50);
  static const Color blue = Color(0xFF2196F3);
  static const Color yellow = Color(0xFFFFEB3B);
  static const Color orange = Color(0xFFFF9800);
  static const Color purple = Color(0xFF9C27B0);
}
''';

String fittorStorage = '''
import 'package:fittor/fittor.dart';

class Storage {
  static const String _dbName = 'store.db';
  static const String _tableName = 'store';

  static String get dbName => FittorStore.getString(_dbName) ?? "";
  static set dbName(String value) => FittorStore.setString(_dbName, value);

  static String get tableName => FittorStore.getString(_tableName) ?? "";
  static set tableName(String value) => FittorStore.setString(_tableName, value);
}
''';
