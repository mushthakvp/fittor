import 'package:flutter/material.dart';

import '../fittor.dart';

mixin FittorMixin<T extends StatefulWidget> on State<T> {
  @protected
  FittorHelper get responsive => FittorHelper();

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
  double wp(double percentage) => FittorHelper.wp(percentage);
  double hp(double percentage) => FittorHelper.hp(percentage);
  double swp(double percentage) => FittorHelper.swp(percentage);
  double shp(double percentage) => FittorHelper.shp(percentage);
  double fs(double size) => FittorHelper.adaptiveFontSize(size);
  double get p4 => FittorHelper.p4;
  double get p8 => FittorHelper.p8;
  double get p12 => FittorHelper.p12;
  double get p16 => FittorHelper.p16;
  double get p20 => FittorHelper.p20;
  double get p24 => FittorHelper.p24;
  double get p32 => FittorHelper.p32;
  double get r4 => FittorHelper.r4;
  double get r8 => FittorHelper.r8;
  double get r12 => FittorHelper.r12;
  double get r16 => FittorHelper.r16;
  double get r20 => FittorHelper.r20;
  double get r24 => FittorHelper.r24;
  double get r30 => FittorHelper.r30;

  Widget get s_5 => FittorHelper.s_5;
  Widget get s1 => FittorHelper.s1;
  Widget get s_15 => FittorHelper.s_15;
  Widget get s2 => FittorHelper.s2;
  Widget get s4 => FittorHelper.s4;
  Widget get s8 => FittorHelper.s8;
  Widget get s12 => FittorHelper.s12;
  Widget get s16 => FittorHelper.s16;
  Widget get s20 => FittorHelper.s20;
  Widget get s_5w => FittorHelper.s_5w;
  Widget get s1w => FittorHelper.s1w;
  Widget get s_15w => FittorHelper.s_15w;
  Widget get s2w => FittorHelper.s2w;
  Widget get s4w => FittorHelper.s4w;
  Widget get s8w => FittorHelper.s8w;
  Widget get s12w => FittorHelper.s12w;
  Widget get s16w => FittorHelper.s16w;
  Widget get s20w => FittorHelper.s20w;

  T deviceValue<T>({required T mobile, T? tablet, T? desktop}) =>
      FittorHelper.deviceValue(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );
}
