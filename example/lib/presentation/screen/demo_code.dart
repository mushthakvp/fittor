import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

class DemoCodeView extends StatefulWidget {
  const DemoCodeView({super.key});

  @override
  State<DemoCodeView> createState() => _DemoCodeViewState();
}

final co = '''class DemoWidget extends StatefulWidget {
  const DemoWidget({super.key});

  @override
  State<DemoWidget> createState() => _DemoWidgetState();
}

class _DemoWidgetState extends State<DemoWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}''';

class _DemoCodeViewState extends State<DemoCodeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo Code')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FittorCode(language: 'dart', title: 'Demo Code', code: co),
          ],
        ),
      ),
    );
  }
}
