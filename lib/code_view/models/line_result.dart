import 'package:flutter/material.dart';

/// Helper class to track nesting levels across lines for bracket highlighting
class LineResult {
  /// The formatted text span with syntax highlighting
  final TextSpan span;

  /// Current nesting level for parentheses ()
  final int parenthesesLevel;

  /// Current nesting level for braces {}
  final int braceLevel;

  /// Current nesting level for brackets []
  final int bracketLevel;

  const LineResult({
    required this.span,
    required this.parenthesesLevel,
    required this.braceLevel,
    required this.bracketLevel,
  });

  /// Creates a copy of this LineResult with updated values
  LineResult copyWith({
    TextSpan? span,
    int? parenthesesLevel,
    int? braceLevel,
    int? bracketLevel,
  }) {
    return LineResult(
      span: span ?? this.span,
      parenthesesLevel: parenthesesLevel ?? this.parenthesesLevel,
      braceLevel: braceLevel ?? this.braceLevel,
      bracketLevel: bracketLevel ?? this.bracketLevel,
    );
  }

  @override
  String toString() {
    return 'LineResult(parenthesesLevel: $parenthesesLevel, braceLevel: $braceLevel, bracketLevel: $bracketLevel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LineResult &&
        other.parenthesesLevel == parenthesesLevel &&
        other.braceLevel == braceLevel &&
        other.bracketLevel == bracketLevel;
  }

  @override
  int get hashCode {
    return parenthesesLevel.hashCode ^
        braceLevel.hashCode ^
        bracketLevel.hashCode;
  }
}
