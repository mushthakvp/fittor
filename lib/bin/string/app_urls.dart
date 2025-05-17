String appUrls = '''
class Urls {
  static const String baseUrl = 'http://192.168.3.115:4000';

  // Auth Endpoints

  static const String login = '/auth';
  static const String register = '/register';
}
''';

String appRoutes = '''
import 'package:flutter/material.dart';
import '../../../fittor/presentation/screen/sample_screen.dart';

/// Handles all the routes for the application
class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String profile = '/profile';
  
  /// Route generator function for MaterialApp
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const SampleScreen(title: 'Home'),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
  
  // Don't allow instantiation
  AppRoutes._();
}
''';

String sampleModel = '''
/// Sample data model class
class SampleModel {
  final int id;
  final String title;
  final String description;
  
  SampleModel({
    required this.id,
    required this.title,
    required this.description,
  });
  
  /// Create from JSON map
  factory SampleModel.fromJson(Map<String, dynamic> json) {
    return SampleModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
  
  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
  
  /// Create a copy with updated fields
  SampleModel copyWith({
    int? id,
    String? title,
    String? description,
  }) {
    return SampleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
''';
