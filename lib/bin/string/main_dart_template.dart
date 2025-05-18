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
import 'package:flutter/widgets.dart';

import '../../core/network/fit_urls.dart';
import '../repo/sample_repository.dart';

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

import 'presentation/controller/fitter_controller.dart';

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

import '../controller/fitter_controller.dart';

class FittorView extends StatefulWidget {
  const FittorView({super.key});

  @override
  State<FittorView> createState() => _FittorViewState();
}

class _FittorViewState extends State<FittorView>
    with ConnectivityMixin, FittorMixin {
  @override
  void onConnectivityChanged(ConnectivityStatus status) {
    if (status == ConnectivityStatus.online) {
      // Handle online state
    } else {
      // Handle offline state
    }
  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          20.h,
          Center(
            child: Text(
              'Fittor State Management Example',
              style: TextStyle(
                fontSize: context.fs20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          30.h,
          FitBuilder<SampleController>(
            tag: 'tag1',
            controller: Fit.find<SampleController>(),
            builder: (context, controller) {
              return Text(
                'With Tags: {controller.count}',
                style: TextStyle(
                  fontSize: context.fs40,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          20.h,
          FitBuilder<SampleController>(
            tag: 'tag2',
            controller: Fit.find<SampleController>(),
            builder: (context, controller) {
              return Text(
                'WithOut Tags: {controller.count}',
                style: TextStyle(
                  fontSize: context.fs40,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          20.h,
          ElevatedButton(
            onPressed: () {
              Fit.find<SampleController>().increment();
            },
            child: const Text('Count Without Tags'),
          ),
          Spacer(),
          Text(
            'Powered By: Fittor',
            style: TextStyle(
              fontSize: context.fs20,
              fontWeight: FontWeight.bold,
              color: Colors.indigoAccent,
            ),
          ),
          40.h,
        ],
      ),
    );
  }
}
''';

String sampleController = '''
import 'package:fittor/fittor.dart';

class SampleController extends FitController {
  int count = 0;

  void increment() {
    count++;
    fittor('tag2');
  }

  void incrementUsingTags() {
    count++;
    fittor('tag1');
  }

  @override
  void onDelete() {
    // Clean up resources when controller is removed
    super.onDelete();
  }
}
''';
