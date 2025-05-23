import 'package:fittor/fittor.dart';

import '../../presentation/screen/fitter_view.dart';
import '../../presentation/screen/readmore.dart';
import '../../presentation/screen/sample_router.dart';

class Routes {
  static const String initialRoute = splash;
  static const splash = '/';
  static const sample = '/sample';
  static const readmore = '/readmore';

  static final routes = [
    FitPage(name: splash, page: () => const FittorView()),
    FitPage(name: sample, page: () => const SampleRouter()),
    FitPage(name: readmore, page: () => const FitReadMoreExample()),
  ];
}
