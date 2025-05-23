import 'package:flutter/material.dart';

/// Defines a customizable pattern within text, such as hashtags, URLs, or mentions.
///
/// Enables applying custom styles and interactions to matched patterns,
/// enhancing text interactivity. Utilize this class to highlight specific text
/// segments or to add clickable functionality, facilitating navigation or other actions.
@immutable
class FitAnnotation {
  const FitAnnotation({
    required this.regExp,
    required this.spanBuilder,
  });

  /// Regular expression pattern to match text
  final RegExp regExp;

  /// Builder function that creates a TextSpan for matched text
  final TextSpan Function({required String text, required TextStyle textStyle})
      spanBuilder;
}
