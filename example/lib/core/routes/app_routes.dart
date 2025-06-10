import 'package:fittor/fittor.dart';
import 'package:test/presentation/screen/no_screen.dart';

import '../../presentation/screen/fitter_view.dart';

class Routes {
  static const String initialRoute = splash;
  static const splash = '/';
  static const no = '/404';

  static final Map<String, FitRoute> routes = {
    splash: FitRoute.page(
      path: splash,
      pageBuilder: (context, args) => FitPage.fade(child: const FittorView()),
    ),
    no: FitRoute.page(
      path: no,
      pageBuilder: (context, args) => FitPage.fade(child: const NoScreen()),
    ),
  };
}
