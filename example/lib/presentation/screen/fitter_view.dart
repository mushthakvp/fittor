import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../controller/sample_controller.dart';

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
                  onPressed: () => Fit.find<SampleController>().incrementAll(),
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
                context.go(Routes.sample, pass: 'Using Fittor Navigator');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Test Fittor Navigator'),
            ),
            30.h,
            ElevatedButton(
              onPressed: () {
                FitRoute.go(Routes.readmore);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Test Readmore Text'),
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
