import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:test/presentation/screen/readmore.dart';

import '../controller/sample_controller.dart';
import 'currency.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            30.h,
            const Text(
              'Fittor State Management Example',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            30.h,
            FitBuilder<SampleController>(
              controller: Fit.find<SampleController>(),
              builder: (context, ctrl) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text('Builder WITHOUT Tag'),
                      const SizedBox(height: 10),
                      Text(
                        'Count: ${ctrl.count}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            20.h,
            FitBuilder<SampleController>(
              tag: 'tag2',
              controller: Fit.find<SampleController>(),
              builder: (context, ctrl) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text('Builder WITH Tag2'),
                      const SizedBox(height: 10),
                      Text(
                        'Count: ${ctrl.count} ',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            30.h,
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed:
                      () => Fit.find<SampleController>().incrementNormal(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Update No-Tag Only'),
                ),

                ElevatedButton(
                  onPressed: () => Fit.find<SampleController>().incrementTag2(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Update Tag2 Only'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    Fit.find<SampleController>().incrementAll();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Update All'),
                ),
              ],
            ),
            30.h,
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
            30.h,
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
            Spacer(),
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
