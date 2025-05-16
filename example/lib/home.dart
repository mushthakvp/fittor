import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:test/no_internet.dart';

import 'app/ui/home_fit.dart';
import 'currency_converter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fittor', style: TextStyle(fontSize: context.fs(20))),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NoInternet()),
              );
            },
            icon: Icon(Icons.wifi_off, size: 30, color: Colors.red),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.p16),
        child: Column(
          children: [
            10.h,
            Text(
              'Fittor is a Flutter package that provides a set of utilities to make your life easier.',
              style: TextStyle(fontSize: context.fs16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            20.h,
            items(
              context,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FitStateHomePage(),
                  ),
                );
              },
              heading: 'Fit State Management',
              content: 'Powered by Fittor',
              color: Colors.teal,
            ),
            10.h,
            items(
              context,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NoInternet()),
                );
              },
              heading: 'Internet Connectivity Checker',
              content: 'Powered by Fittor',
              color: Colors.blueAccent,
            ),
            10.h,
            items(
              context,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CurrencyConverterExample(),
                  ),
                );
              },
              heading: 'Currency Converter',
              content: 'Powered by Fittor',
              color: Colors.green,
            ),
            10.h,
            items(
              context,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NoInternet()),
                );
              },
              heading: 'Custom Sized Box',
              content: 'Powered by Fittor',
              color: Colors.orange,
            ),
            10.h,
            items(
              context,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NoInternet()),
                );
              },
              heading: 'Responsive',
              content: 'Powered by Fittor',
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector items(
    BuildContext context, {
    required Null Function() onTap,
    required String heading,
    required String content,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.hp(15),
        width: context.wp(90),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                heading,
                style: TextStyle(fontSize: context.fs(20), color: Colors.white),
              ),
            ),
            10.h,
            Text(
              content,
              style: TextStyle(fontSize: context.fs(16), color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
