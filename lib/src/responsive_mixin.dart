import 'package:flutter/material.dart';

import '../responsive_helper.dart';

mixin ResponsiveMixin<T extends StatefulWidget> on State<T> {
  @protected
  ResponsiveHelper get responsive => ResponsiveHelper();

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
  double wp(double percentage) => ResponsiveHelper.wp(percentage);
  double hp(double percentage) => ResponsiveHelper.hp(percentage);
  double swp(double percentage) => ResponsiveHelper.swp(percentage);
  double shp(double percentage) => ResponsiveHelper.shp(percentage);
  double fs(double size) => ResponsiveHelper.adaptiveFontSize(size);
  double get p4 => ResponsiveHelper.p4;
  double get p8 => ResponsiveHelper.p8;
  double get p12 => ResponsiveHelper.p12;
  double get p16 => ResponsiveHelper.p16;
  double get p20 => ResponsiveHelper.p20;
  double get p24 => ResponsiveHelper.p24;
  double get p32 => ResponsiveHelper.p32;
  double get r4 => ResponsiveHelper.r4;
  double get r8 => ResponsiveHelper.r8;
  double get r12 => ResponsiveHelper.r12;
  double get r16 => ResponsiveHelper.r16;
  double get r20 => ResponsiveHelper.r20;
  double get r24 => ResponsiveHelper.r24;
  double get r30 => ResponsiveHelper.r30;

  Widget get s_5 => ResponsiveHelper.s_5;
  Widget get s1 => ResponsiveHelper.s1;
  Widget get s_15 => ResponsiveHelper.s_15;
  Widget get s2 => ResponsiveHelper.s2;
  Widget get s4 => ResponsiveHelper.s4;
  Widget get s8 => ResponsiveHelper.s8;
  Widget get s12 => ResponsiveHelper.s12;
  Widget get s16 => ResponsiveHelper.s16;
  Widget get s20 => ResponsiveHelper.s20;
  Widget get s_5w => ResponsiveHelper.s_5w;
  Widget get s1w => ResponsiveHelper.s1w;
  Widget get s_15w => ResponsiveHelper.s_15w;
  Widget get s2w => ResponsiveHelper.s2w;
  Widget get s4w => ResponsiveHelper.s4w;
  Widget get s8w => ResponsiveHelper.s8w;
  Widget get s12w => ResponsiveHelper.s12w;
  Widget get s16w => ResponsiveHelper.s16w;
  Widget get s20w => ResponsiveHelper.s20w;

  T deviceValue<T>({required T mobile, T? tablet, T? desktop}) =>
      ResponsiveHelper.deviceValue(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );
}
