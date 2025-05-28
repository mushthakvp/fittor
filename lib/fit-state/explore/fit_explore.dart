// lib/state/explore/fit_explore.dart
import 'package:flutter/material.dart';

import '../core/fit_core.dart';

/// Abstract class for defining controller bindings
abstract class FitBindings {
  /// Override this method to register your controllers
  void register();
}

/// Widget that wraps MaterialApp and initializes controllers
class FitExplore extends StatefulWidget {
  /// The child widget (typically MaterialApp)
  final Widget child;

  /// Single binding class that registers controllers
  final FitBindings fitStates;

  /// Whether to dispose controllers when widget is disposed (default: true)
  final bool autoDispose;

  const FitExplore({
    super.key,
    required this.child,
    required this.fitStates,
    this.autoDispose = true,
  });

  @override
  State<FitExplore> createState() => _FitExploreState();
}

class _FitExploreState extends State<FitExplore> {
  @override
  void initState() {
    super.initState();
    _initializeBindings();
  }

  void _initializeBindings() {
    // Register controllers from the single binding
    try {
      widget.fitStates.register();
    } catch (e) {
      debugPrint(
          'Error registering binding ${widget.fitStates.runtimeType}: $e');
    }
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      Fit.reset();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Extension on Fit class for explore functionality
extension FitExploreExtension on Type {
  /// Convenience method to register controller from a single binding
  static void exploreBinding(FitBindings binding) {
    binding.register();
  }
}
