// lib/fitroute/widgets/fit_app_bar.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/fit_router.dart';
import '../utils/platform_utils.dart';

/// Custom AppBar that integrates with FitRouter for proper back button behavior
class FitAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool? automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool? centerTitle;
  final TextStyle? titleTextStyle;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final double? leadingWidth;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final PreferredSizeWidget? bottom;
  final bool primary;
  final bool excludeHeaderSemantics;
  final double? scrolledUnderElevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final Clip? clipBehavior;

  /// Callback for custom back button behavior
  final VoidCallback? onBackPressed;

  /// Whether to show back button even when canPop is false (useful for web)
  final bool forceShowBackButton;

  /// Custom back button icon
  final Widget? backButtonIcon;

  const FitAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 4.0,
    this.centerTitle,
    this.titleTextStyle,
    this.iconTheme,
    this.actionsIconTheme,
    this.leadingWidth,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.bottom,
    this.primary = true,
    this.excludeHeaderSemantics = false,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
    this.onBackPressed,
    this.forceShowBackButton = false,
    this.backButtonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FitRouter.instance.routerDelegate,
      builder: (context, child) {
        final canPop = FitRouter.instance.canPop();
        final canGoBack = kIsWeb ? PlatformUtils.canGoBack() : canPop;
        final shouldShowBackButton = forceShowBackButton || canPop || canGoBack;

        Widget? leadingWidget = leading;

        // Only override leading if it's not explicitly set and we should show back button
        if (leading == null &&
            (automaticallyImplyLeading ?? true) &&
            shouldShowBackButton) {
          leadingWidget = _buildBackButton(context);
        }

        return AppBar(
          title: titleWidget ?? (title != null ? Text(title!) : null),
          actions: actions,
          leading: leadingWidget,
          automaticallyImplyLeading: false, // We handle this ourselves
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          centerTitle: centerTitle,
          titleTextStyle: titleTextStyle,
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          leadingWidth: leadingWidth,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
          bottom: bottom,
          primary: primary,
          excludeHeaderSemantics: excludeHeaderSemantics,
          scrolledUnderElevation: scrolledUnderElevation,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          shape: shape,
          systemOverlayStyle: systemOverlayStyle,
          forceMaterialTransparency: forceMaterialTransparency,
          clipBehavior: clipBehavior,
        );
      },
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: backButtonIcon ?? const BackButtonIcon(),
      onPressed: () => _handleBackPressed(context),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }

  void _handleBackPressed(BuildContext context) {
    if (onBackPressed != null) {
      onBackPressed!();
      return;
    }

    final router = FitRouter.instance;

    // Try to pop using FitRouter first
    if (router.canPop()) {
      router.pop();
    }
    // On web, if we can't pop in our stack but browser has history, go back
    else if (kIsWeb && PlatformUtils.canGoBack()) {
      PlatformUtils.goBack();
    }
    // Fallback to Navigator.maybePop for other scenarios
    else {
      Navigator.maybePop(context);
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

/// Extension to easily create FitAppBar
extension FitAppBarHelper on AppBar {
  /// Convert regular AppBar to FitAppBar
  static FitAppBar fromAppBar(
    AppBar appBar, {
    VoidCallback? onBackPressed,
    bool forceShowBackButton = false,
    Widget? backButtonIcon,
  }) {
    return FitAppBar(
      title: (appBar.title as Text?)?.data,
      titleWidget: appBar.title,
      actions: appBar.actions,
      leading: appBar.leading,
      automaticallyImplyLeading: appBar.automaticallyImplyLeading,
      backgroundColor: appBar.backgroundColor,
      foregroundColor: appBar.foregroundColor,
      elevation: appBar.elevation ?? 4.0,
      centerTitle: appBar.centerTitle,
      titleTextStyle: appBar.titleTextStyle,
      iconTheme: appBar.iconTheme,
      actionsIconTheme: appBar.actionsIconTheme,
      leadingWidth: appBar.leadingWidth,
      titleSpacing: appBar.titleSpacing,
      toolbarOpacity: appBar.toolbarOpacity,
      bottomOpacity: appBar.bottomOpacity,
      bottom: appBar.bottom,
      primary: appBar.primary,
      excludeHeaderSemantics: appBar.excludeHeaderSemantics,
      scrolledUnderElevation: appBar.scrolledUnderElevation,
      shadowColor: appBar.shadowColor,
      surfaceTintColor: appBar.surfaceTintColor,
      shape: appBar.shape,
      systemOverlayStyle: appBar.systemOverlayStyle,
      forceMaterialTransparency: appBar.forceMaterialTransparency,
      clipBehavior: appBar.clipBehavior,
      onBackPressed: onBackPressed,
      forceShowBackButton: forceShowBackButton,
      backButtonIcon: backButtonIcon,
    );
  }
}

/// Custom back button that integrates with FitRouter
class FitBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? icon;
  final String? tooltip;
  final Color? color;

  const FitBackButton({
    super.key,
    this.onPressed,
    this.icon,
    this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FitRouter.instance.routerDelegate,
      builder: (context, child) {
        final canPop = FitRouter.instance.canPop();
        final canGoBack = kIsWeb ? PlatformUtils.canGoBack() : canPop;

        if (!canPop && !canGoBack) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: icon ?? const BackButtonIcon(),
          color: color,
          tooltip:
              tooltip ?? MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: onPressed ?? () => _handleBackPressed(context),
        );
      },
    );
  }

  void _handleBackPressed(BuildContext context) {
    final router = FitRouter.instance;

    if (router.canPop()) {
      router.pop();
    } else if (kIsWeb && PlatformUtils.canGoBack()) {
      PlatformUtils.goBack();
    } else {
      Navigator.maybePop(context);
    }
  }
}
