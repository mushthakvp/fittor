import 'package:flutter/material.dart';

import '../fittor.dart';

extension FittorExtensions on BuildContext {
  // Screen dimensions
  double get width => FittorHelper.width;
  double get height => FittorHelper.height;
  double get safeWidth => FittorHelper.safeWidth;
  double get safeHeight => FittorHelper.safeHeight;

  // Width percentage (regular and safe area)
  double wp(double val) => FittorHelper.wp(val);
  double swp(double val) => FittorHelper.swp(val);

  // Height percentage (regular and safe area)
  double hp(double val) => FittorHelper.hp(val);
  double shp(double val) => FittorHelper.shp(val);

  // Proportional scaling
  double scaleWidth(double val) => FittorHelper.scaleWidth(val);
  double scaleHeight(double val) => FittorHelper.scaleHeight(val);

  // Adaptive sizing
  double adaptiveSize(double val) => FittorHelper.adaptiveSize(val);

  // Font sizes
  double fs(double val) => FittorHelper.fontSize(val);
  double adaptiveFs(double val) => FittorHelper.adaptiveFontSize(val);

  // Convenience getters for common font sizes
  double get fs10 => FittorHelper.fs10;
  double get fs12 => FittorHelper.fs12;
  double get fs14 => FittorHelper.fs14;
  double get fs16 => FittorHelper.fs16;
  double get fs18 => FittorHelper.fs18;
  double get fs20 => FittorHelper.fs20;
  double get fs22 => FittorHelper.fs22;
  double get fs24 => FittorHelper.fs24;
  double get fs26 => FittorHelper.fs26;
  double get fs28 => FittorHelper.fs28;
  double get fs30 => FittorHelper.fs30;
  double get fs32 => FittorHelper.fs32;
  double get fs34 => FittorHelper.fs34;
  double get fs36 => FittorHelper.fs36;
  double get fs38 => FittorHelper.fs38;
  double get fs40 => FittorHelper.fs40;
  double get fs42 => FittorHelper.fs42;
  double get fs44 => FittorHelper.fs44;
  double get fs46 => FittorHelper.fs46;
  double get fs48 => FittorHelper.fs48;
  double get fs50 => FittorHelper.fs50;

  // Convenience getters for common paddings
  double get p4 => FittorHelper.p4;
  double get p8 => FittorHelper.p8;
  double get p10 => FittorHelper.p10;
  double get p12 => FittorHelper.p12;
  double get p16 => FittorHelper.p16;
  double get p20 => FittorHelper.p20;
  double get p24 => FittorHelper.p24;
  double get p32 => FittorHelper.p32;

  // Convenience getters for common border radius
  double get r4 => FittorHelper.r4;
  double get r8 => FittorHelper.r8;
  double get r12 => FittorHelper.r12;
  double get r16 => FittorHelper.r16;
  double get r18 => FittorHelper.r18;
  double get r20 => FittorHelper.r20;
  double get r24 => FittorHelper.r24;
  double get r30 => FittorHelper.r30;

  // Device-specific values
  T deviceValue<T>({required T mobile, T? tablet, T? desktop}) =>
      FittorHelper.deviceValue(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );
}
