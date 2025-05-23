import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

/// Utility class for TextSpan operations
class TextSpanUtils {
  TextSpanUtils._();

  /// Checks if an InlineSpan is a valid TextSpan structure
  static bool isTextSpan(InlineSpan span) {
    if (span is! TextSpan) {
      return false;
    }

    final children = span.children;
    if (children == null || children.isEmpty) {
      return true;
    }

    return children.every(isTextSpan);
  }

  /// Merges multiple regex patterns from annotations
  static RegExp? mergeRegexPatterns(List<FitAnnotation>? annotations) {
    if (annotations == null || annotations.isEmpty) {
      return null;
    } else if (annotations.length == 1) {
      return annotations[0].regExp;
    }

    final nonCapturingGroupPattern = RegExp(r'\((?!\?:)');

    return RegExp(
      annotations
          .map(
            (a) =>
                '(${a.regExp.pattern.replaceAll(nonCapturingGroupPattern, '(?:')})',
          )
          .join('|'),
    );
  }
}

/// Result class for text span trimming operations
@immutable
class TextSpanTrimResult {
  const TextSpanTrimResult({
    required this.textSpan,
    required this.spanEndIndex,
    required this.didTrim,
  });

  final TextSpan textSpan;
  final int spanEndIndex;
  final bool didTrim;
}
