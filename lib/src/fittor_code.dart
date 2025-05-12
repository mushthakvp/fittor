import 'package:flutter/material.dart';

class FittorHelper {
  // Singleton instance
  static final FittorHelper _instance = FittorHelper._internal();
  factory FittorHelper() => _instance;
  FittorHelper._internal();

  // Screen dimensions
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  // Safe area insets
  static double _safeAreaHorizontal = 0;
  static double _safeAreaVertical = 0;
  static double _safeBlockHorizontal = 0;
  static double _safeBlockVertical = 0;

  // Device type indicators
  static bool isPortrait = true;
  static bool isMobile = false;
  static bool isTablet = false;
  static bool isDesktop = false;

  // Screen size brackets
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 1200;

  // Text scale factor from MediaQuery
  static double _textScaleFactor = 1.0;

  // Screen size for reference (based on design)
  static const double _designScreenWidth = 375.0;
  static const double _designScreenHeight = 812.0;

  // Scale factors to adjust UI relative to design screen size
  static double _widthFactor = 1.0;
  static double _heightFactor = 1.0;

  /// Initialize responsive values
  void init(
    BuildContext context,
    BoxConstraints constraints,
    Orientation orientation,
  ) {
    // Media query data
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _textScaleFactor = mediaQuery.textScaleFactor;

    // Screen dimensions based on orientation
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
    }

    // Device type detection
    if (_screenWidth < _mobileBreakpoint) {
      isMobile = true;
      isTablet = false;
      isDesktop = false;
    } else if (_screenWidth < _tabletBreakpoint) {
      isMobile = false;
      isTablet = true;
      isDesktop = false;
    } else {
      isMobile = false;
      isTablet = false;
      isDesktop = true;
    }

    // Calculate block sizes (percentage of screen)
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    // Calculate safe area adjustments
    _safeAreaHorizontal = mediaQuery.padding.left + mediaQuery.padding.right;
    _safeAreaVertical = mediaQuery.padding.top + mediaQuery.padding.bottom;
    _safeBlockHorizontal = (_screenWidth - _safeAreaHorizontal) / 100;
    _safeBlockVertical = (_screenHeight - _safeAreaVertical) / 100;

    // Calculate scale factors based on design screen size
    _widthFactor = _screenWidth / _designScreenWidth;
    _heightFactor = _screenHeight / _designScreenHeight;
  }

  // Basic size getters
  static double get width => _blockSizeHorizontal;
  static double get height => _blockSizeVertical;
  static double get safeWidth => _safeBlockHorizontal;
  static double get safeHeight => _safeBlockVertical;

  // Width percentage (regular and safe area)
  static double wp(double val) => val * _blockSizeHorizontal;
  static double swp(double val) => val * _safeBlockHorizontal;

  // Height percentage (regular and safe area)
  static double hp(double val) => val * _blockSizeVertical;
  static double shp(double val) => val * _safeBlockVertical;

  // Proportional scaling based on design screen size
  static double scaleWidth(double val) => val * _widthFactor;
  static double scaleHeight(double val) => val * _heightFactor;

  // Adaptive scaling that adjusts based on device size
  static double adaptiveSize(double val) {
    if (isDesktop) return val * 1.25;
    if (isTablet) return val * 1.0;
    return val * 0.85; // Mobile
  }

  // Font sizes with text scale factor included
  static double fontSize(double val) => val * _textScaleFactor;

  // Adaptive font sizes that adjust based on device
  static double adaptiveFontSize(double val) {
    double baseSize = val * _textScaleFactor;
    if (isDesktop) return baseSize * 1.2;
    if (isTablet) return baseSize * 1.1;
    return baseSize; // Mobile
  }

  // Common font sizes
  static double get fs10 => adaptiveFontSize(10);
  static double get fs12 => adaptiveFontSize(12);
  static double get fs14 => adaptiveFontSize(14);
  static double get fs16 => adaptiveFontSize(16);
  static double get fs18 => adaptiveFontSize(18);
  static double get fs20 => adaptiveFontSize(20);
  static double get fs22 => adaptiveFontSize(22);
  static double get fs24 => adaptiveFontSize(24);
  static double get fs26 => adaptiveFontSize(26);
  static double get fs28 => adaptiveFontSize(28);
  static double get fs30 => adaptiveFontSize(30);
  static double get fs32 => adaptiveFontSize(32);
  static double get fs34 => adaptiveFontSize(34);
  static double get fs36 => adaptiveFontSize(36);
  static double get fs38 => adaptiveFontSize(38);
  static double get fs40 => adaptiveFontSize(40);
  static double get fs42 => adaptiveFontSize(42);
  static double get fs44 => adaptiveFontSize(44);
  static double get fs46 => adaptiveFontSize(46);
  static double get fs48 => adaptiveFontSize(48);
  static double get fs50 => adaptiveFontSize(50);

  // Common paddings and margins
  static double get p4 => adaptiveSize(4);
  static double get p8 => adaptiveSize(8);
  static double get p10 => adaptiveSize(10);
  static double get p12 => adaptiveSize(12);
  static double get p16 => adaptiveSize(16);
  static double get p20 => adaptiveSize(20);
  static double get p24 => adaptiveSize(24);
  static double get p32 => adaptiveSize(32);

  // Common border radius
  static double get r4 => adaptiveSize(4);
  static double get r8 => adaptiveSize(8);
  static double get r12 => adaptiveSize(12);
  static double get r16 => adaptiveSize(16);
  static double get r18 => adaptiveSize(18);
  static double get r20 => adaptiveSize(20);
  static double get r24 => adaptiveSize(24);
  static double get r30 => adaptiveSize(30);

  static T deviceValue<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // Common SizedBoxes for spacing
  static Widget get s_5 => SizedBox(height: hp(.5));
  static Widget get s1 => SizedBox(height: hp(1));
  static Widget get s_15 => SizedBox(height: hp(1.5));
  static Widget get s2 => SizedBox(height: hp(2));
  static Widget get s4 => SizedBox(height: hp(4));
  static Widget get s8 => SizedBox(height: hp(8));
  static Widget get s12 => SizedBox(height: hp(12));
  static Widget get s16 => SizedBox(height: hp(16));
  static Widget get s20 => SizedBox(height: hp(20));

  static Widget get s_5w => SizedBox(width: wp(.5));
  static Widget get s1w => SizedBox(width: wp(1));
  static Widget get s_15w => SizedBox(width: wp(1.5));
  static Widget get s2w => SizedBox(width: wp(2));
  static Widget get s4w => SizedBox(width: wp(4));
  static Widget get s8w => SizedBox(width: wp(8));
  static Widget get s12w => SizedBox(width: wp(12));
  static Widget get s16w => SizedBox(width: wp(16));
  static Widget get s20w => SizedBox(width: wp(20));
}
