import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

import '../screen/readmore.dart';
import 'counter_section.dart';
import 'currency.dart';
import 'demo_api.dart';
import 'demo_code.dart';
import 'selectors_section.dart';
import 'user_section.dart';

class FittorView extends StatefulWidget {
  const FittorView({super.key});

  @override
  State<FittorView> createState() => _FittorViewState();
}

class _FittorViewState extends State<FittorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          'Fittor Example',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.p12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            30.h,
            const Text(
              'Fittor State Management Example',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            30.h,
            SizedBox(width: context.wp(95), child: CounterSection()),
            10.h,
            SizedBox(width: context.wp(95), child: UserSection()),
            10.h,
            SizedBox(width: context.wp(95), child: SelectorsSection()),
            10.h,
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FitReadMoreExample(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Test Readmore Text'),
            ),
            10.h,
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CurrencyConverterPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Currency Converter'),
            ),
            10.h,
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DemoApi()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Demo API'),
            ),
            10.h,
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const DemoCodeView()),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Demo Code View'),
            ),
            20.h,
            Text(
              'Powered By: Fittor',
              style: TextStyle(
                fontSize: context.fs16,
                fontWeight: FontWeight.bold,
                color: Colors.indigoAccent,
              ),
            ),
            40.h,
          ],
        ),
      ),
    );
  }
}
