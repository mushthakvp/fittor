import 'package:flutter/material.dart';

import '../adaptix.dart';

extension ResponsiveExtensions on BuildContext {
  // Screen dimensions
  double get width => AdaptixHelper.width;
  double get height => AdaptixHelper.height;
  double get safeWidth => AdaptixHelper.safeWidth;
  double get safeHeight => AdaptixHelper.safeHeight;

  // Width percentage (regular and safe area)
  double wp(double val) => AdaptixHelper.wp(val);
  double swp(double val) => AdaptixHelper.swp(val);

  // Height percentage (regular and safe area)
  double hp(double val) => AdaptixHelper.hp(val);
  double shp(double val) => AdaptixHelper.shp(val);

  // Proportional scaling
  double scaleWidth(double val) => AdaptixHelper.scaleWidth(val);
  double scaleHeight(double val) => AdaptixHelper.scaleHeight(val);

  // Adaptive sizing
  double adaptiveSize(double val) => AdaptixHelper.adaptiveSize(val);

  // Font sizes
  double fs(double val) => AdaptixHelper.fontSize(val);
  double adaptiveFs(double val) => AdaptixHelper.adaptiveFontSize(val);

  // Convenience getters for common font sizes
  double get fs10 => AdaptixHelper.fs10;
  double get fs12 => AdaptixHelper.fs12;
  double get fs14 => AdaptixHelper.fs14;
  double get fs16 => AdaptixHelper.fs16;
  double get fs18 => AdaptixHelper.fs18;
  double get fs20 => AdaptixHelper.fs20;
  double get fs22 => AdaptixHelper.fs22;
  double get fs24 => AdaptixHelper.fs24;
  double get fs26 => AdaptixHelper.fs26;
  double get fs28 => AdaptixHelper.fs28;
  double get fs30 => AdaptixHelper.fs30;
  double get fs32 => AdaptixHelper.fs32;
  double get fs34 => AdaptixHelper.fs34;
  double get fs36 => AdaptixHelper.fs36;
  double get fs38 => AdaptixHelper.fs38;
  double get fs40 => AdaptixHelper.fs40;
  double get fs42 => AdaptixHelper.fs42;
  double get fs44 => AdaptixHelper.fs44;
  double get fs46 => AdaptixHelper.fs46;
  double get fs48 => AdaptixHelper.fs48;
  double get fs50 => AdaptixHelper.fs50;

  // Convenience getters for common paddings
  double get p4 => AdaptixHelper.p4;
  double get p8 => AdaptixHelper.p8;
  double get p10 => AdaptixHelper.p10;
  double get p12 => AdaptixHelper.p12;
  double get p16 => AdaptixHelper.p16;
  double get p20 => AdaptixHelper.p20;
  double get p24 => AdaptixHelper.p24;
  double get p32 => AdaptixHelper.p32;

  // Convenience getters for common border radius
  double get r4 => AdaptixHelper.r4;
  double get r8 => AdaptixHelper.r8;
  double get r12 => AdaptixHelper.r12;
  double get r16 => AdaptixHelper.r16;
  double get r18 => AdaptixHelper.r18;
  double get r20 => AdaptixHelper.r20;
  double get r24 => AdaptixHelper.r24;
  double get r30 => AdaptixHelper.r30;

  // Device-specific values
  T deviceValue<T>({required T mobile, T? tablet, T? desktop}) =>
      AdaptixHelper.deviceValue(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );

  // Spacing widgets
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
}
