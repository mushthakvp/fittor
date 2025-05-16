import 'package:flutter/widgets.dart';

import 'fit_control_core.dart';

/// Bindings class to register controllers before a route is loaded
abstract class FitBindings {
  /// Implement this method to register controllers
  void dependencies();

  /// Helper method to register a controller with Fit.lazyPut
  T lazyPut<T>(T Function() creator, {String? tag}) {
    Fit.lazyPut<T>(creator, tag: tag);
    return creator();
  }
}

/// Extension on BuildContext to easily access Fit controllers
extension FitControlContextExtension on BuildContext {
  /// Find a controller by type and optional tag
  T find<T>({String? tag}) => Fit.find<T>(tag: tag);

  /// Check if a controller is registered
  bool isRegistered<T>({String? tag}) => Fit.isRegistered<T>(tag: tag);
}

/// Widget to initialize bindings for a route or app
class FitControllerScope extends InheritedWidget {
  final FitBindings bindings;

  FitControllerScope({
    super.key,
    required this.bindings,
    required super.child,
  }) {
    bindings.dependencies();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  /// Find the closest FitControllerScope ancestor
  static FitControllerScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FitControllerScope>();
  }
}

/// Initializer widget for the FitControl system
class FitInitializer extends StatefulWidget {
  final Widget child;
  final List<FitBindings>? initialBindings;

  const FitInitializer({super.key, required this.child, this.initialBindings});

  @override
  State<FitInitializer> createState() => _FitInitializerState();
}

class _FitInitializerState extends State<FitInitializer> {
  @override
  void initState() {
    super.initState();
    widget.initialBindings?.forEach((binding) => binding.dependencies());
  }

  @override
  void dispose() {
    Fit.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
