// Step 2: Create bindings to initialize controllers
import 'package:fittor/fittor.dart';

import '../controller/counter_fit.dart';

class AppBindings extends FitBindings {
  @override
  void dependencies() {
    // Register controllers with lazy initialization
    lazyPut(() => CounterController());

    // You can also register with tags for multiple instances
    // lazyPut(() => AnotherController(), tag: 'special');
  }
}
