import 'package:flutter/material.dart';

import '../adaptix.dart';

mixin ResponsiveMixin<T extends StatefulWidget> on State<T> {
  @protected
  AdaptixHelper get responsive => AdaptixHelper();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initResponsive();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initResponsive();
  }

  void _initResponsive() {
    final mediaQuery = MediaQuery.of(context);
    final constraints =
        (context.findRenderObject() as RenderBox?)?.constraints ??
        BoxConstraints();
    final orientation = mediaQuery.orientation;

    responsive.init(context, constraints, orientation);
  }

  // Shortcut methods
  double wp(double percentage) => AdaptixHelper.wp(percentage);
  double hp(double percentage) => AdaptixHelper.hp(percentage);
  double swp(double percentage) => AdaptixHelper.swp(percentage);
  double shp(double percentage) => AdaptixHelper.shp(percentage);
  double fs(double size) => AdaptixHelper.adaptiveFontSize(size);
  double get p4 => AdaptixHelper.p4;
  double get p8 => AdaptixHelper.p8;
  double get p12 => AdaptixHelper.p12;
  double get p16 => AdaptixHelper.p16;
  double get p20 => AdaptixHelper.p20;
  double get p24 => AdaptixHelper.p24;
  double get p32 => AdaptixHelper.p32;
  double get r4 => AdaptixHelper.r4;
  double get r8 => AdaptixHelper.r8;
  double get r12 => AdaptixHelper.r12;
  double get r16 => AdaptixHelper.r16;
  double get r20 => AdaptixHelper.r20;
  double get r24 => AdaptixHelper.r24;
  double get r30 => AdaptixHelper.r30;

  Widget get s_5 => AdaptixHelper.s_5;
  Widget get s1 => AdaptixHelper.s1;
  Widget get s_15 => AdaptixHelper.s_15;
  Widget get s2 => AdaptixHelper.s2;
  Widget get s4 => AdaptixHelper.s4;
  Widget get s8 => AdaptixHelper.s8;
  Widget get s12 => AdaptixHelper.s12;
  Widget get s16 => AdaptixHelper.s16;
  Widget get s20 => AdaptixHelper.s20;
  Widget get s_5w => AdaptixHelper.s_5w;
  Widget get s1w => AdaptixHelper.s1w;
  Widget get s_15w => AdaptixHelper.s_15w;
  Widget get s2w => AdaptixHelper.s2w;
  Widget get s4w => AdaptixHelper.s4w;
  Widget get s8w => AdaptixHelper.s8w;
  Widget get s12w => AdaptixHelper.s12w;
  Widget get s16w => AdaptixHelper.s16w;
  Widget get s20w => AdaptixHelper.s20w;

  T deviceValue<T>({required T mobile, T? tablet, T? desktop}) =>
      AdaptixHelper.deviceValue(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );
}
