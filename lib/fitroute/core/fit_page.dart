import 'package:flutter/material.dart';

/// Predefined page transition types
enum FitPageTransition {
  fade,
  slide,
  scale,
  rotation,
  slideFromTop,
  slideFromBottom,
  slideFromLeft,
  slideFromRight,
  none,
}

/// A custom page configuration for FitRouter
class FitPage extends Page {
  /// The widget to display
  final Widget child;

  /// The type of transition animation
  final FitPageTransition transitionType;

  /// Custom transition duration
  final Duration transitionDuration;

  /// Custom reverse transition duration
  final Duration reverseTransitionDuration;

  /// Custom transition builder
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  )? customTransitionBuilder;

  /// Whether the page should maintain its state
  final bool maintainState;

  /// Whether the page is fullscreen dialog
  final bool fullscreenDialog;

  /// Custom page barrier color
  final Color? barrierColor;

  /// Whether the barrier is dismissible
  final bool barrierDismissible;

  /// Barrier label for accessibility
  final String? barrierLabel;

  const FitPage({
    required this.child,
    this.transitionType = FitPageTransition.slide,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.customTransitionBuilder,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.barrierColor,
    this.barrierDismissible = false,
    this.barrierLabel,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  /// Create a page with fade transition
  factory FitPage.fade({
    required Widget child,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    bool maintainState = true,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
  }) {
    return FitPage(
      child: child,
      transitionType: FitPageTransition.fade,
      transitionDuration:
          transitionDuration ?? const Duration(milliseconds: 300),
      reverseTransitionDuration:
          reverseTransitionDuration ?? const Duration(milliseconds: 300),
      maintainState: maintainState,
      key: key,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
    );
  }

  /// Create a page with slide transition
  factory FitPage.slide({
    required Widget child,
    FitPageTransition direction = FitPageTransition.slideFromRight,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    bool maintainState = true,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
  }) {
    return FitPage(
      child: child,
      transitionType: direction,
      transitionDuration:
          transitionDuration ?? const Duration(milliseconds: 300),
      reverseTransitionDuration:
          reverseTransitionDuration ?? const Duration(milliseconds: 300),
      maintainState: maintainState,
      key: key,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
    );
  }

  /// Create a page with scale transition
  factory FitPage.scale({
    required Widget child,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    bool maintainState = true,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
  }) {
    return FitPage(
      child: child,
      transitionType: FitPageTransition.scale,
      transitionDuration:
          transitionDuration ?? const Duration(milliseconds: 300),
      reverseTransitionDuration:
          reverseTransitionDuration ?? const Duration(milliseconds: 300),
      maintainState: maintainState,
      key: key,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
    );
  }

  /// Create a page with no transition
  factory FitPage.noTransition({
    required Widget child,
    bool maintainState = true,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
  }) {
    return FitPage(
      child: child,
      transitionType: FitPageTransition.none,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      maintainState: maintainState,
      key: key,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
    );
  }

  /// Create a page with custom transition
  factory FitPage.custom({
    required Widget child,
    required Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) transitionBuilder,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    bool maintainState = true,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
  }) {
    return FitPage(
      child: child,
      transitionType: FitPageTransition.none,
      customTransitionBuilder: transitionBuilder,
      transitionDuration:
          transitionDuration ?? const Duration(milliseconds: 300),
      reverseTransitionDuration:
          reverseTransitionDuration ?? const Duration(milliseconds: 300),
      maintainState: maintainState,
      key: key,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
    );
  }

  @override
  Route createRoute(BuildContext context) {
    return _FitPageRoute(page: this);
  }
}

/// Custom page route implementation for FitPage
class _FitPageRoute<T> extends PageRoute<T> {
  final FitPage page;

  _FitPageRoute({required this.page}) : super(settings: page);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return page.child;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (page.customTransitionBuilder != null) {
      return page.customTransitionBuilder!(
          context, animation, secondaryAnimation, child);
    }

    switch (page.transitionType) {
      case FitPageTransition.fade:
        return FadeTransition(opacity: animation, child: child);

      case FitPageTransition.scale:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case FitPageTransition.rotation:
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case FitPageTransition.slideFromRight:
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case FitPageTransition.slideFromLeft:
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                  .animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case FitPageTransition.slideFromTop:
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero)
                  .animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case FitPageTransition.slideFromBottom:
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
                  .animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case FitPageTransition.slide:
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case FitPageTransition.none:
        return child;
    }
  }

  @override
  Duration get transitionDuration => page.transitionDuration;

  @override
  Duration get reverseTransitionDuration => page.reverseTransitionDuration;

  @override
  bool get maintainState => page.maintainState;

  @override
  bool get fullscreenDialog => page.fullscreenDialog;

  @override
  Color? get barrierColor => page.barrierColor;

  @override
  bool get barrierDismissible => page.barrierDismissible;

  @override
  String? get barrierLabel => page.barrierLabel;
}
