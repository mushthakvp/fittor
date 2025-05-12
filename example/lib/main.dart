import 'package:flutter/material.dart';
import 'package:responsive_helper/responsive_helper.dart';
import 'package:test/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with ResponsiveAppMixin {
  const MyApp({super.key});

  @override
  Widget responsive(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
