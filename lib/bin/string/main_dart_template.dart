String mainDartTemplate = '''

// Flutter 3.29.3 • channel stable •
// Engine • revision cf56914b32
// Tools • Dart 3.7.2 • DevTools 2.42.3


import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'fit_bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FittorStore.init();
  runApp(FittorApp());
}

class FittorApp extends StatelessWidget with FittorAppMixin {
  const FittorApp({super.key});

  @override
  Widget responsive(BuildContext context) {
    return FitInitializer(
      initialBindings: [AppBindings()],
      child: FitRouterConfig(
        initialRoute: Routes.initialRoute,
        routes: Routes.routes,
        builder: (context, child) {
          return ConnectivityWrapper(
            onConnectivityChanged: (status) {
              debugPrint('Connectivity status: \$status');
            },
            child: child ?? const SizedBox(),
          );
        },
      ),
    );
  }
}
''';

String sampleDataSource = '''
import 'package:flutter/material.dart';

import '../../../core/network/fit_urls.dart';
import '../repo/fitter_sample_repo.dart';

class SampleFittorSource extends FitUrls implements FitterSampleRepo {
  @override
  Future<bool> sendOtp({required String number}) {
    String url = sendOtpUrl;
    debugPrint(url);
    throw UnimplementedError();
  }

  @override
  Future<void> verifyOtp({required String number, required String otp}) {
    String url = verifyOtpUrl;
    debugPrint(url);
    throw UnimplementedError();
  }
}

''';

String fitBinding = '''
import 'package:fittor/fittor.dart';

import 'presentation/controller/sample_controller.dart';

class AppBindings extends FitBindings {
  @override
  void dependencies() {
    lazyPut(() => SampleController());
  }
}
''';

String sampleHomeScreen = '''
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
                        'Count: \${ctrl.count}',
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
                        'Count: \${ctrl.count} ',
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
''';

String sampleController = '''
import 'package:fittor/fittor.dart';
import 'package:flutter/cupertino.dart';

class SampleController extends FitController {
  int count = 0;
  bool isInitialized = false;

  // Called when controller is first accessed
  @override
  void onInit() {
    super.onInit();
    debugPrint('SampleController initialized'); // For debugging
    isInitialized = true;

    // You can do initial setup here, like:
    // - Loading data from local storage
    // - Setting up initial state
    // - Initializing dependencies
  }

  // This will ONLY update builders with NO tag
  void incrementNormal() {
    count++;
    fittor(); // Only updates builders without tags
  }

  // This will ONLY update builders with the 'tag2' tag
  void incrementTag2() {
    count++;
    fittor('tag2'); // Only updates builders with 'tag2' tag
  }

  // This will update ALL builders regardless of tags
  void incrementAll() {
    count++;
    fitAll(); // Updates all builders regardless of tags
  }

  @override
  void onDelete() {
    debugPrint('SampleController being deleted'); // For debugging

    // Clean up resources when controller is removed
    // This is important to prevent memory leaks
    // Examples:
    // - Cancel subscriptions
    // - Close streams
    // - Dispose of animation controllers
    // - Close database connections

    super.onDelete();
  }
}
''';

String sampleRouterTemplate = '''
import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

class SampleRouter extends StatefulWidget {
  const SampleRouter({super.key});

  @override
  State<SampleRouter> createState() => _SampleRouterState();
}

class _SampleRouterState extends State<SampleRouter> {
  String? args;

  @override
  void initState() {
    super.initState();
    args = FitRoute.arguments as String?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text('Sample Router', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Sample Router',
              style: TextStyle(fontSize: context.fs30),
            ),
          ),
          Text('Args: \$args', style: TextStyle(fontSize: context.fs30)),
        ],
      ),
    );
  }
}
''';
