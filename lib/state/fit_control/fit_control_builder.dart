import 'package:flutter/material.dart';

import 'fit_control_core.dart';

/// Widget that rebuilds when a controller calls update()
class FitBuilder<T extends FitController> extends StatefulWidget {
  /// The builder function that returns the widget tree
  final Widget Function(BuildContext, T) builder;

  /// The controller to listen to
  final T controller;

  /// Optional init function called when widget is first built
  final Function(T)? init;

  /// Optional dispose function called when widget is removed
  final Function(T)? dispose;

  /// Whether to automatically register controller with Fit (default: false)
  final bool autoRegister;

  /// Optional tag to identify this specific builder
  final String? tag;

  const FitBuilder({
    super.key,
    required this.builder,
    required this.controller,
    this.init,
    this.dispose,
    this.autoRegister = false,
    this.tag,
  });

  @override
  State<FitBuilder<T>> createState() => _FitBuilderState<T>();
}

class _FitBuilderState<T extends FitController> extends State<FitBuilder<T>> {
  late FitListener _listener;

  @override
  void initState() {
    super.initState();

    // Auto-register if needed
    if (widget.autoRegister && !Fit.isRegistered<T>()) {
      Fit.put<T>(widget.controller);
    }

    // Setup listener
    _listener = FitListener(() {
      if (mounted) setState(() {});
    });

    widget.controller.addListener(_listener, widget.tag);

    // Call init if provided
    if (widget.init != null) {
      widget.init!(widget.controller);
    }
  }

  @override
  void dispose() {
    // Remove listener
    widget.controller.removeListener(_listener, widget.tag);

    // Call dispose if provided
    if (widget.dispose != null) {
      widget.dispose!(widget.controller);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.controller);
  }
}

/// Widget that rebuilds when a FitValue changes
class FitValueBuilder<T> extends StatefulWidget {
  /// The builder function that returns the widget tree
  final Widget Function(BuildContext, T) builder;

  /// The FitValue to listen to
  final FitValue<T> fitValue;

  const FitValueBuilder({
    super.key,
    required this.builder,
    required this.fitValue,
  });

  @override
  State<FitValueBuilder<T>> createState() => _FitValueBuilderState<T>();
}

class _FitValueBuilderState<T> extends State<FitValueBuilder<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.fitValue.val;
    widget.fitValue.addListener(_onValueChanged);
  }

  @override
  void dispose() {
    widget.fitValue.removeListener(_onValueChanged);
    super.dispose();
  }

  void _onValueChanged() {
    setState(() {
      value = widget.fitValue.val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value);
  }
}
