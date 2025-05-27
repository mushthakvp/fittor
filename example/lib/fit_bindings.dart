import 'package:fittor/fittor.dart';

import 'presentation/controller/api_controller.dart';
import 'presentation/controller/sample_controller.dart';

class AppBindings extends FitBindings {
  @override
  void dependencies() {
    lazyPut(() => SampleController());
    lazyPut(() => ApiController());
  }
}
