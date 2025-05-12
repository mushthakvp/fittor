import 'package:adaptix/fittor.dart';
import 'package:flutter/material.dart';
import 'package:test/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with FittorAppMixin {
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
