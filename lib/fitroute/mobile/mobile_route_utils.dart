import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utilities for mobile routing
class MobileRouteUtils {
  /// Handle system back button (Android)
  static Future<bool> handleSystemBack(
    BuildContext context,
    bool Function() canPop,
    void Function() pop,
  ) async {
    if (canPop()) {
      pop();
      return false; // Don't let system handle back
    } else {
      // Show exit confirmation dialog
      final shouldExit = await showExitDialog(context);
      if (shouldExit) {
        SystemNavigator.pop(); // Exit app
      }
      return false;
    }
  }

  /// Show exit confirmation dialog
  static Future<bool> showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Create a WillPopScope wrapper for handling back button
  static Widget wrapWithBackHandler({
    required Widget child,
    required BuildContext context,
    required bool Function() canPop,
    required void Function() pop,
    bool showExitDialog = true,
  }) {
    return WillPopScope(
      onWillPop: () => handleSystemBack(context, canPop, pop),
      child: child,
    );
  }

  /// Get platform-specific page transition
  static PageTransitionsBuilder getPlatformTransition() {
    return const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: NoTransitionsBuilder(),
            TargetPlatform.windows: NoTransitionsBuilder(),
            TargetPlatform.linux: NoTransitionsBuilder(),
          },
        ).builders[Theme.of(NavigatorState().context).platform] ??
        const CupertinoPageTransitionsBuilder();
  }

  /// Create route with platform-specific transition
  static Route<T> createPlatformRoute<T extends Object?>({
    required Widget child,
    required RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return getPlatformTransition().buildTransitions(
          null,
          context,
          animation,
          secondaryAnimation,
          child,
        );
      },
    );
  }

  /// Handle orientation changes
  static void handleOrientationChange(
    BuildContext context,
    String routeName,
    Map<String, dynamic> arguments,
  ) {
    // This can be extended to handle orientation-specific layouts
    debugPrint('Orientation changed for route: $routeName');
  }

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get screen size
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final size = getScreenSize(context);
    final diagonal = (size.width * size.width + size.height * size.height);
    return diagonal > 1100000; // Rough tablet detection
  }

  /// Check if device is phone
  static bool isPhone(BuildContext context) {
    return !isTablet(context);
  }

  /// Get device type string
  static String getDeviceType(BuildContext context) {
    if (isTablet(context)) {
      return 'tablet';
    } else {
      return 'phone';
    }
  }

  /// Handle keyboard visibility changes
  static void handleKeyboardVisibility(
    BuildContext context,
    void Function(bool isVisible) onKeyboardToggle,
  ) {
    final mediaQuery = MediaQuery.of(context);
    final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
    onKeyboardToggle(isKeyboardVisible);
  }

  /// Hide keyboard
  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// Show keyboard
  static void showKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  /// Set status bar style
  static void setStatusBarStyle({
    Color? statusBarColor,
    Brightness? statusBarBrightness,
    Brightness? statusBarIconBrightness,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarBrightness: statusBarBrightness,
        statusBarIconBrightness: statusBarIconBrightness,
      ),
    );
  }

  /// Set preferred orientations
  static Future<void> setPreferredOrientations(
      List<DeviceOrientation> orientations) {
    return SystemChrome.setPreferredOrientations(orientations);
  }

  /// Lock to portrait mode
  static Future<void> lockPortrait() {
    return setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Lock to landscape mode
  static Future<void> lockLandscape() {
    return setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Allow all orientations
  static Future<void> allowAllOrientations() {
    return setPreferredOrientations(DeviceOrientation.values);
  }
}

/// Custom no-transition page builder
class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T extends Object?>(
    PageRoute<T>? route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
