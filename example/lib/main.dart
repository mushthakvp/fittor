import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'fit_bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
  };
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
        enableSwipeBack: true,
        initialRoute: Routes.initialRoute,
        routes: Routes.routes,
        builder: (context, child) {
          return ConnectivityWrapper(
            onConnectivityChanged: (status) {
              debugPrint('Connectivity status: $status');
            },
            child: child ?? const SizedBox(),
          );
        },
      ),
    );
  }
}
