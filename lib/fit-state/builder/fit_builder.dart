// lib/state/builder/fit_builder.dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../core/fit_core.dart';

/// Widget that rebuilds when controller calls fittor() or fitAll()
class FitBuilder<T extends FitState> extends StatefulWidget {
  /// The builder function that returns the widget tree
  final Widget Function(BuildContext context, T controller) builder;

  /// Optional tag to identify this specific builder
  final String? tag;

  /// Optional init function called when widget is first built
  final Function(T)? init;

  /// Optional dispose function called when widget is removed
  final Function(T)? dispose;

  const FitBuilder({
    super.key,
    required this.builder,
    this.tag,
    this.init,
    this.dispose,
  });

  @override
  State<FitBuilder<T>> createState() => _FitBuilderState<T>();
}

class _FitBuilderState<T extends FitState> extends State<FitBuilder<T>> {
  late T controller;
  StreamSubscription<String?>? _subscription;

  @override
  void initState() {
    super.initState();

    // Get controller automatically
    controller = Fit.find<T>();

    // Setup stream listener
    _subscription = controller.updateStream.listen((updateTag) {
      if (!mounted) return;

      // Check if this builder should update based on tag
      bool shouldUpdate = false;

      if (updateTag == '__ALL__') {
        // fitAll() was called - update all builders
        shouldUpdate = true;
      } else if (updateTag == null && widget.tag == null) {
        // fittor() was called with no tag - update builders with no tag
        shouldUpdate = true;
      } else if (updateTag != null && updateTag == widget.tag) {
        // fittor(tag) was called - update builders with matching tag
        shouldUpdate = true;
      }

      if (shouldUpdate) {
        setState(() {});
      }
    });

    // Call init if provided
    widget.init?.call(controller);
  }

  @override
  void dispose() {
    // Cancel subscription
    _subscription?.cancel();

    // Call dispose if provided
    widget.dispose?.call(controller);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, controller);
  }
}

/// Simple builder that gets controller automatically
class FitGet<T extends FitState> extends StatelessWidget {
  /// The builder function that returns the widget tree
  final Widget Function(T controller) builder;

  const FitGet({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Fit.find<T>();
    return builder(controller);
  }
}
