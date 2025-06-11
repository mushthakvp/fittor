import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'fit_bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FittorApp());
}

class FittorApp extends StatelessWidget with FittorAppMixin {
  const FittorApp({super.key});

  @override
  Widget responsive(BuildContext context) {
    return FitExplore(
      fitStates: AppBindings(),
      child: FitApp(initialRoute: Routes.initialRoute, routes: Routes.routes),
    );
  }
}
