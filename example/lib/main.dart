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
