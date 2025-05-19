import 'package:fittor/fittor.dart';

import '../../presentation/screen/fitter_view.dart';
import '../../presentation/screen/sample_router.dart';

class Routes {
  static const splash = '/';
  static const sample = '/sample';
  static const String initialRoute = splash;

  static final routes = [
    FitPage(
      name: initialRoute,
      page: () => const FittorView(),
      transition: Transition.fade,
    ),
    FitPage(
      name: sample,
      page: () => const SampleRouter(),
      transition: Transition.rightToLeft,
    ),
  ];
}
