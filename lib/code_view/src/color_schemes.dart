import 'package:flutter/material.dart';

/// Color schemes and palettes for syntax highlighting
class FittorColorScheme {
  const FittorColorScheme._();

  /// Enhanced rainbow gradient colors for brackets and special elements
  static const List<Color> rainbowColors = [
    Color(0xFFFF4081), // Hot Pink
    Color(0xFFFF5722), // Deep Orange
    Color(0xFFFFEB3B), // Bright Yellow
    Color(0xFF4CAF50), // Green
    Color(0xFF00BCD4), // Cyan
    Color(0xFF2196F3), // Blue
    Color(0xFF3F51B5), // Indigo
    Color(0xFF9C27B0), // Purple
    Color(0xFFE91E63), // Pink
    Color(0xFFFF9800), // Orange
    Color(0xFFCDDC39), // Lime
    Color(0xFF009688), // Teal
    Color(0xFF673AB7), // Deep Purple
    Color(0xFFFF6B6B), // Coral
    Color(0xFF4ECDC4), // Turquoise
  ];

  /// Vibrant color scheme for different syntax elements
  static const Color keywordColor = Color(0xFF569CD6); // Bright Blue
  static const Color classColor = Color(0xFF4EC9B0); // Teal
  static const Color stringColor = Color(0xFFD69E2E); // Golden Orange
  static const Color numberColor = Color(0xFFB5CEA8); // Light Green
  static const Color commentColor = Color(0xFF6A9955); // Forest Green
  static const Color functionColor = Color(0xFFDCDCAA); // Light Yellow
  static const Color variableColor = Color(0xFF9CDCFE); // Light Blue
  static const Color punctuationColor = Color(0xFFD4D4D4); // Light Gray
  static const Color annotationColor = Color(0xFFFFB347); // Orange
  static const Color operatorColor = Color(0xFFFF6B9D); // Pink
  static const Color importColor = Color(0xFF569CD6); // Blue
  static const Color constantColor = Color(0xFF4FC1FF); // Sky Blue
  static const Color typeColor = Color(0xFF4EC9B0); // Cyan

  /// Background gradient colors
  static const List<Color> backgroundGradient = [
    Color(0xFF2D2D30),
    Color(0xFF1E1E1E),
  ];

  /// Header gradient colors
  static const List<Color> headerGradient = [
    Color(0xFF404045),
    Color(0xFF353539),
  ];

  /// Code area gradient colors
  static const List<Color> codeAreaGradient = [
    Color(0xFF1E1E1E),
    Color(0xFF0F0F0F),
  ];

  /// Terminal dots colors
  static const Color redDot = Color(0xFFFF5F57);
  static const Color yellowDot = Color(0xFFFFBD2E);
  static const Color greenDot = Color(0xFF28CA42);

  /// Button gradient colors
  static const List<Color> copyButtonGradient = [Colors.blue, Colors.purple];
  static const List<Color> launchButtonGradient = [
    Colors.deepOrange,
    Colors.orange
  ];
  static const List<Color> successButtonGradient = [Colors.green, Colors.teal];

  /// Language tag gradient
  static const List<Color> languageTagGradient = [
    Color.fromARGB(255, 42, 41, 47),
    Color.fromARGB(255, 74, 131, 185)
  ];
}
