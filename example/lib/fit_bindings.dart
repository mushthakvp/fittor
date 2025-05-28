import 'package:fittor/fittor.dart';

import 'presentation/controller/api_controller.dart';
import 'presentation/controller/sample_controller.dart';
import 'presentation/controller/user_controller.dart';

class AppBindings extends FitBindings {
  @override
  void register() {
    Fit.explore<CounterController>(() => CounterController());
    Fit.explore<ApiController>(() => ApiController());
    Fit.explore<UserController>(() => UserController());
  }
}
