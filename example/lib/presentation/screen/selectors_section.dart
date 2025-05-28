import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:test/presentation/controller/sample_controller.dart';
import 'package:test/presentation/controller/user_controller.dart';

/// Selectors section demonstrating automatic updates
class SelectorsSection extends StatelessWidget {
  const SelectorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selectors Demo (Auto-Update)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Counter selector
            FitSelector<CounterController, int>(
              selector: (controller) => controller.count,
              builder: (context, count) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Count Selector: $count (Auto-updates!)',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            // User display name selector
            FitSelector<UserController, String>(
              selector: (controller) => controller.displayName,
              builder: (context, displayName) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'User Selector: $displayName (Auto-updates!)',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            // Login status selector
            FitSelector<UserController, bool>(
              selector: (controller) => controller.isLoggedIn,
              builder: (context, isLoggedIn) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isLoggedIn ? Colors.green.shade50 : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Login Status Selector: ${isLoggedIn ? 'Logged In' : 'Guest'} (Auto-updates!)',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
