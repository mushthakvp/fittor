import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:test/presentation/controller/user_controller.dart';

/// User section demonstrating user controller
class UserSection extends StatelessWidget {
  const UserSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Controller Demo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // User info display
            FitBuilder<UserController>(
              builder: (context, controller) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Display Name: ${controller.displayName}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Email: ${controller.email.isEmpty ? 'Not set' : controller.email}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Login Status: ${controller.isLoggedIn ? 'Logged In' : 'Guest'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Permissions: ${controller.permissions.join(', ')}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // User control buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FitGet<UserController>(
                  builder:
                      (controller) => ElevatedButton(
                        onPressed:
                            () => controller.updateUser(
                              'John Doe',
                              25,
                              email: 'john@example.com',
                            ),
                        child: const Text('Update User'),
                      ),
                ),
                FitGet<UserController>(
                  builder:
                      (controller) => ElevatedButton(
                        onPressed:
                            () => controller.login(
                              'Jane Smith',
                              'jane@example.com',
                              userPermissions: ['read', 'write', 'admin'],
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Login'),
                      ),
                ),
                FitGet<UserController>(
                  builder:
                      (controller) => ElevatedButton(
                        onPressed: controller.logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Logout'),
                      ),
                ),
                FitGet<UserController>(
                  builder:
                      (controller) => ElevatedButton(
                        onPressed: controller.fetchUserData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Fetch Data'),
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
