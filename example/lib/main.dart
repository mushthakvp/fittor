import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:test/home.dart';

import 'app/bindings/fit_bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FittorStore.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget with FittorAppMixin {
  MyApp({super.key});

  @override
  Widget responsive(BuildContext context) {
    return FitInitializer(
      initialBindings: [AppBindings()],
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'Responsive Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ConnectivityWrapper(
          ignoreOfflineState: false,
          onConnectivityChanged: (status) {
            debugPrint('Connectivity status: $status');
          },
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
