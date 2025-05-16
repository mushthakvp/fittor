import 'dart:developer';

import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

import '../controller/counter_fit.dart';

class FitStateHomePage extends StatelessWidget {
  const FitStateHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fit State Management')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            // Step 4a: Use FitBuilder with a controller
            // Note: controller object is now passed to the builder function
            FitBuilder<CounterController>(
              controller: Fit.find<CounterController>(),
              tag: 'display',
              builder: (context, ctrl) {
                log("its working \n ----- using tag display");
                return Text(
                  'Display ${ctrl.counter.val}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            const SizedBox(height: 20),
            FitBuilder<CounterController>(
              controller: Fit.find<CounterController>(),
              tag: 'sukoonn',
              builder: (context, ctrl) {
                log("its working \n ----- using tag sukoonn");
                return Text(
                  'Sukoon ${ctrl.counter.val}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            const SizedBox(height: 20),
            // // Step 4b: Use FitValueBuilder for simple state updates
            // FitValueBuilder<int>(
            //   fitValue: Fit.find<CounterController>().counter,

            //   builder: (context, count) {
            //     log("without tag \n $count");
            //     return Text(
            //       'Counter value: $count',
            //       style: Theme.of(context).textTheme.titleLarge,
            //     );
            //   },
            // ),
            const SizedBox(height: 20),
            // This button will only update widgets with 'display' tag
            ElevatedButton(
              onPressed:
                  () => Fit.find<CounterController>().incrementDisplayOnly(),
              child: const Text('Update Display Only'),
            ),
            const SizedBox(height: 10),
            // This button will update all widgets
            ElevatedButton(
              onPressed: () => Fit.find<CounterController>().increment(),
              child: const Text('Update All'),
            ),
          ],
        ),
      ),
    );
  }
}
