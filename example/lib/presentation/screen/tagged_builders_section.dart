import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:test/presentation/controller/sample_controller.dart';
import 'package:test/presentation/controller/user_controller.dart';

/// Tagged builders section demonstrating selective updates
class TaggedBuildersSection extends StatelessWidget {
  const TaggedBuildersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tagged Builders Demo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Special tagged builder
            FitBuilder<CounterController>(
              tag: 'special',
              builder: (context, controller) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Special Tagged Builder: Count = ${controller.count}',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // Email tagged builder
            FitBuilder<UserController>(
              tag: 'email',
              builder: (context, controller) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Email Tagged Builder: ${controller.email.isEmpty ? 'No email' : controller.email}',
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // Tag control buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed:
                      () => Fit.find<CounterController>().incrementSpecial(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text('Special ++'),
                ),
                FitGet<UserController>(
                  builder:
                      (controller) => ElevatedButton(
                        onPressed:
                            () => controller.updateEmail('tagged@example.com'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                        ),
                        child: const Text('Update Email'),
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
