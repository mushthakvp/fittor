import 'package:fittor/fittor.dart';
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
      debugShowCheckedModeBanner: true,
      title: 'Responsive Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ConnectivityWrapper(
        ignoreOfflineState: true,
        onConnectivityChanged: (status) {
          debugPrint('Connectivity status: $status');
        },
        child: const HomeScreen(),
      ),
    );
  }
}
