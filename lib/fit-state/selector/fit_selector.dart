// lib/state/selector/fit_selector.dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../core/fit_core.dart';

/// Widget that automatically rebuilds when specific selected data changes
class FitSelector<T extends FitState, R> extends StatefulWidget {
  /// The selector function that extracts specific data from controller
  final R Function(T controller) selector;

  /// The builder function that returns the widget tree
  final Widget Function(BuildContext context, R value) builder;

  /// Unique key for this selector (optional - auto-generated if not provided)
  final String? selectorKey;

  /// Whether to rebuild when values are equal (default: false)
  final bool rebuildOnEqual;

  const FitSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.selectorKey,
    this.rebuildOnEqual = false,
  });

  @override
  State<FitSelector<T, R>> createState() => _FitSelectorState<T, R>();
}

class _FitSelectorState<T extends FitState, R>
    extends State<FitSelector<T, R>> {
  late T controller;
  late R currentValue;
  StreamSubscription<R>? _subscription;
  late String _key;

  @override
  void initState() {
    super.initState();

    // Get controller automatically
    controller = Fit.find<T>();

    // Generate unique key for this selector
    _key = widget.selectorKey ??
        '${T.toString()}_${R.toString()}_${widget.hashCode}';

    // Get initial value
    currentValue = widget.selector(controller);

    // Setup selector stream
    _subscription = controller
        .fitSelect<R>(_key, () => widget.selector(controller))
        .listen((newValue) {
      if (!mounted) return;

      // Check if we should rebuild
      bool shouldRebuild = widget.rebuildOnEqual || (currentValue != newValue);

      if (shouldRebuild) {
        setState(() {
          currentValue = newValue;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, currentValue);
  }
}

/// Extension on FitState for easier selector updates
extension FitSelectorExtension on FitState {
  /// Notify selector to update with new value
  void notifySelector<R>(String key, R Function() selector) {
    fitSelectRefresh(key, selector);
  }

  /// Auto-notify all selectors (call this in your state changes)
  void notifySelectors() {
    // This would need to be implemented based on registered selectors
    // For now, controllers need to manually call specific selector updates
  }
}

/// Mixin for automatic selector notifications
mixin AutoSelectorMixin on FitState {
  final Set<String> _registeredSelectors = {};

  /// Register a selector for auto-updates
  void registerSelector(String key) {
    _registeredSelectors.add(key);
  }

  /// Unregister a selector
  void unregisterSelector(String key) {
    _registeredSelectors.remove(key);
  }

  /// Override fittor to also update selectors
  @override
  void fittor([String? tag]) {
    super.fittor(tag);
    _updateRegisteredSelectors();
  }

  /// Override fitAll to also update selectors
  @override
  void fitAll() {
    super.fitAll();
    _updateRegisteredSelectors();
  }

  void _updateRegisteredSelectors() {
    // Update all registered selectors
    // This is a placeholder - actual implementation would depend on
    // how selectors are tracked and updated
  }
}
