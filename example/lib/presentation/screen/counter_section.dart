import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

import '../controller/sample_controller.dart';

/// Counter section demonstrating different update methods
class CounterSection extends StatelessWidget {
  const CounterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Counter Controller Demo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Normal builder (no tag)
            FitBuilder<CounterController>(
              builder: (context, controller) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Normal Builder: Count = ${controller.count}',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // Status display
            FitBuilder<CounterController>(
              builder: (context, controller) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Status: ${controller.status}',
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // Control buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      Fit.find<CounterController>().incrementNormal(),
                  child: const Text('Normal ++'),
                ),
                ElevatedButton(
                  onPressed: () => Fit.find<CounterController>().incrementAll(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('All ++'),
                ),
                ElevatedButton(
                  onPressed: () => Fit.find<CounterController>().reset(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Reset'),
                ),
                FitGet<CounterController>(
                  builder: (controller) => ElevatedButton(
                    onPressed: controller.incrementAsync,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(
                      controller.isLoading ? 'Loading...' : 'Async ++',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
