import 'package:flutter/material.dart';

class NoScreen extends StatefulWidget {
  const NoScreen({super.key});

  @override
  State<NoScreen> createState() => _NoScreenState();
}

class _NoScreenState extends State<NoScreen> {
  @override
  Widget build(BuildContext context) {
    //404 PAge
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Text(
              'Page Not Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
