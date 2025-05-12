import 'package:flutter/material.dart';

import '../responsive_helper.dart';

extension ResponsiveExtensions on BuildContext {
  // Screen dimensions
  double get width => ResponsiveHelper.width;
  double get height => ResponsiveHelper.height;
  double get safeWidth => ResponsiveHelper.safeWidth;
  double get safeHeight => ResponsiveHelper.safeHeight;

  // Width percentage (regular and safe area)
  double wp(double val) => ResponsiveHelper.wp(val);
  double swp(double val) => ResponsiveHelper.swp(val);

  // Height percentage (regular and safe area)
  double hp(double val) => ResponsiveHelper.hp(val);
  double shp(double val) => ResponsiveHelper.shp(val);

  // Proportional scaling
  double scaleWidth(double val) => ResponsiveHelper.scaleWidth(val);
  double scaleHeight(double val) => ResponsiveHelper.scaleHeight(val);

  // Adaptive sizing
  double adaptiveSize(double val) => ResponsiveHelper.adaptiveSize(val);

  // Font sizes
  double fs(double val) => ResponsiveHelper.fontSize(val);
  double adaptiveFs(double val) => ResponsiveHelper.adaptiveFontSize(val);

  // Convenience getters for common font sizes
  double get fs10 => ResponsiveHelper.fs10;
  double get fs12 => ResponsiveHelper.fs12;
  double get fs14 => ResponsiveHelper.fs14;
  double get fs16 => ResponsiveHelper.fs16;
  double get fs18 => ResponsiveHelper.fs18;
  double get fs20 => ResponsiveHelper.fs20;
  double get fs22 => ResponsiveHelper.fs22;
  double get fs24 => ResponsiveHelper.fs24;
  double get fs26 => ResponsiveHelper.fs26;
  double get fs28 => ResponsiveHelper.fs28;
  double get fs30 => ResponsiveHelper.fs30;
  double get fs32 => ResponsiveHelper.fs32;
  double get fs34 => ResponsiveHelper.fs34;
  double get fs36 => ResponsiveHelper.fs36;
  double get fs38 => ResponsiveHelper.fs38;
  double get fs40 => ResponsiveHelper.fs40;
  double get fs42 => ResponsiveHelper.fs42;
  double get fs44 => ResponsiveHelper.fs44;
  double get fs46 => ResponsiveHelper.fs46;
  double get fs48 => ResponsiveHelper.fs48;
  double get fs50 => ResponsiveHelper.fs50;

  // Convenience getters for common paddings
  double get p4 => ResponsiveHelper.p4;
  double get p8 => ResponsiveHelper.p8;
  double get p10 => ResponsiveHelper.p10;
  double get p12 => ResponsiveHelper.p12;
  double get p16 => ResponsiveHelper.p16;
  double get p20 => ResponsiveHelper.p20;
  double get p24 => ResponsiveHelper.p24;
  double get p32 => ResponsiveHelper.p32;

  // Convenience getters for common border radius
  double get r4 => ResponsiveHelper.r4;
  double get r8 => ResponsiveHelper.r8;
  double get r12 => ResponsiveHelper.r12;
  double get r16 => ResponsiveHelper.r16;
  double get r18 => ResponsiveHelper.r18;
  double get r20 => ResponsiveHelper.r20;
  double get r24 => ResponsiveHelper.r24;
  double get r30 => ResponsiveHelper.r30;

  // Device-specific values
  T deviceValue<T>({required T mobile, T? tablet, T? desktop}) =>
      ResponsiveHelper.deviceValue(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );

  // Spacing widgets
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
}
