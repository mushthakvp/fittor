import 'package:fittor/fittor.dart';

import '../../presentation/screen/demo_code.dart';
import '../../presentation/screen/fitter_view.dart';
import '../../presentation/screen/no_screen.dart';

class Routes {
  static const String initialRoute = splash;
  static const splash = '/';
  static const no = '/404';
  static const demoCodeView = '/demo-code-view';

  static final Map<String, FitRoute> routes = {
    splash: FitRoute.page(
      path: splash,
      pageBuilder: (context, args) =>
          const FitPage(child: ConnectivityWrapper(child: FittorView())),
    ),
    no: FitRoute.page(
      path: no,
      pageBuilder: (context, args) => const FitPage(child: NoScreen()),
    ),
    demoCodeView: FitRoute.page(
      path: demoCodeView,
      pageBuilder: (context, args) => const FitPage(child: DemoCodeView()),
    ),
  };
}
