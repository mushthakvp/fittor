import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:test/presentation/controller/api_controller.dart';

class DemoApi extends StatefulWidget {
  const DemoApi({super.key});

  @override
  State<DemoApi> createState() => _DemoApiState();
}

class _DemoApiState extends State<DemoApi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo Api')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate API call
                debugPrint('API call simulated');
                Fit.find<ApiController>().getPosts();
              },
              child: const Text('Call API'),
            ),
            const SizedBox(height: 20),
            Text(
              'This is a demo screen for API calls.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
