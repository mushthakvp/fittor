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
            const BoxConstraints();
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

  T deviceValue({required T mobile, T? tablet, T? desktop}) =>
      FittorHelper.deviceValue(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );
}
