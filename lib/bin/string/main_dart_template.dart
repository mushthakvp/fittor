String mainDartTemplate = '''
import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

import 'fit_bindings.dart';
import 'presentation/screen/fitter_view.dart';

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ConnectivityWrapper(
          onConnectivityChanged: (status) {
            debugPrint('Connectivity status: status');
          },
          child: const FittorView(),
        ),
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
            Spacer(),
            const Text(
              'Powered By: Fittor',
              style: TextStyle(
                fontSize: 16,
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
    updateAll(); // Updates all builders regardless of tags
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
