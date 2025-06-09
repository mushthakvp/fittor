import 'package:flutter/material.dart';
import '../models/line_result.dart';
import 'color_schemes.dart';

/// Syntax highlighter for various programming languages
class SyntaxHighlighter {
  const SyntaxHighlighter._();

  /// Enhanced regex pattern for tokenizing code
  static final RegExp _tokenRegex = RegExp(
    r'''(@\w+)|(\b(?:abstract|as|assert|async|await|break|case|catch|class|const|continue|default|deferred|do|dynamic|else|enum|export|extends|external|factory|false|final|finally|for|Function|get|hide|if|implements|import|in|interface|is|library|mixin|new|null|on|operator|part|rethrow|return|set|show|static|super|switch|sync|this|throw|true|try|typedef|var|void|while|with|yield)\b)|(\b(?:String|int|double|bool|List|Map|Set|Iterable|Future|Stream|Widget|State|StatefulWidget|StatelessWidget|BuildContext|Container|Text|Icon|Row|Column|Padding|EdgeInsets|BoxDecoration|BorderRadius|Color|Colors|TextStyle|MaterialApp|Scaffold|AppBar|FloatingActionButton|Navigator|Route|PageRoute|MaterialPageRoute|AnimationController|Animation|Tween|Duration|Curve|Curves)\b)|(\b\d+(?:\.\d+)?(?:[eE][+-]?\d+)?\b)|(\b0x[A-Fa-f0-9]+\b)|(\/\/.*$)|(\/\*[\s\S]*?\*\/)|(["\'](?:[^"'\\]|\\.)*["\'])|(=>|==|!=|<=|>=|&&|\|\||[+\-*/%<>=!&|^~])|([(){}[\]])|([;,.])|(\b[A-Z]\w*)|(\b[a-z]\w*\()|(\b[a-z_]\w*)|(\s+)|(.)''',
    multiLine: true,
  );

  /// Builds syntax highlighted text with vibrant colors
  static TextSpan buildSyntaxHighlightedText(String code) {
    final lines = code.split('\n');
    final List<TextSpan> spans = [];

    // Track bracket nesting levels globally across all lines
    int parenthesesLevel = 0;
    int braceLevel = 0;
    int bracketLevel = 0;

    for (int i = 0; i < lines.length; i++) {
      // Add line number
      spans.add(
        TextSpan(
          text: '${(i + 1).toString().padLeft(2)}  ',
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      // Add separator
      spans.add(
        TextSpan(
          text: '    ',
          style: TextStyle(
            color: Colors.cyan.shade400,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      // Add syntax highlighted line
      final lineSpan = _highlightLine(
        lines[i],
        parenthesesLevel,
        braceLevel,
        bracketLevel,
      );
      spans.add(lineSpan.span);

      // Update global nesting levels
      parenthesesLevel = lineSpan.parenthesesLevel;
      braceLevel = lineSpan.braceLevel;
      bracketLevel = lineSpan.bracketLevel;

      // Add newline except for last line
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }

  /// Highlights a single line with syntax coloring
  static LineResult _highlightLine(
    String line,
    int initialParenthesesLevel,
    int initialBraceLevel,
    int initialBracketLevel,
  ) {
    final List<TextSpan> spans = [];

    int parenthesesLevel = initialParenthesesLevel;
    int braceLevel = initialBraceLevel;
    int bracketLevel = initialBracketLevel;

    final matches = _tokenRegex.allMatches(line);
    int lastEnd = 0;

    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: line.substring(lastEnd, match.start),
            style: const TextStyle(color: Colors.white),
          ),
        );
      }

      final String token = match.group(0) ?? '';
      final TokenStyle style = _getTokenStyle(
        token,
        match,
        parenthesesLevel,
        braceLevel,
        bracketLevel,
      );

      // Update nesting levels for brackets
      if (match.group(10) != null) {
        switch (token) {
          case '(':
            parenthesesLevel++;
            break;
          case ')':
            parenthesesLevel =
                (parenthesesLevel - 1).clamp(0, double.infinity).toInt();
            break;
          case '{':
            braceLevel++;
            break;
          case '}':
            braceLevel = (braceLevel - 1).clamp(0, double.infinity).toInt();
            break;
          case '[':
            bracketLevel++;
            break;
          case ']':
            bracketLevel = (bracketLevel - 1).clamp(0, double.infinity).toInt();
            break;
        }
      }

      spans.add(
        TextSpan(
          text: token,
          style: TextStyle(
            color: style.color,
            fontWeight: style.isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );

      lastEnd = match.end;
    }

    if (lastEnd < line.length) {
      spans.add(
        TextSpan(
          text: line.substring(lastEnd),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return LineResult(
      span: TextSpan(children: spans),
      parenthesesLevel: parenthesesLevel,
      braceLevel: braceLevel,
      bracketLevel: bracketLevel,
    );
  }

  /// Gets the appropriate style for a token
  static TokenStyle _getTokenStyle(
    String token,
    RegExpMatch match,
    int parenthesesLevel,
    int braceLevel,
    int bracketLevel,
  ) {
    Color color = Colors.white;
    bool isBold = false;

    if (match.group(1) != null) {
      // Annotations (@override, @deprecated, etc.)
      color = FittorColorScheme.annotationColor;
      isBold = true;
    } else if (match.group(2) != null) {
      // Keywords (class, extends, if, else, etc.)
      color = FittorColorScheme.keywordColor;
      isBold = true;
    } else if (match.group(3) != null) {
      // Types and built-in classes
      color = FittorColorScheme.typeColor;
      isBold = true;
    } else if (match.group(4) != null || match.group(5) != null) {
      // Numbers and hex colors
      color = FittorColorScheme.numberColor;
    } else if (match.group(6) != null || match.group(7) != null) {
      // Comments
      color = FittorColorScheme.commentColor;
    } else if (match.group(8) != null) {
      // Strings
      color = FittorColorScheme.stringColor;
    } else if (match.group(9) != null) {
      // Operators (=>, ==, !=, +, -, etc.)
      color = FittorColorScheme.operatorColor;
      isBold = true;
    } else if (match.group(10) != null) {
      // Brackets and braces with rainbow colors
      switch (token) {
        case '(':
        case ')':
          color = FittorColorScheme.rainbowColors[
              parenthesesLevel % FittorColorScheme.rainbowColors.length];
          break;
        case '{':
        case '}':
          color = FittorColorScheme.rainbowColors[
              braceLevel % FittorColorScheme.rainbowColors.length];
          break;
        case '[':
        case ']':
          color = FittorColorScheme.rainbowColors[
              bracketLevel % FittorColorScheme.rainbowColors.length];
          break;
      }
      isBold = true;
    } else if (match.group(11) != null) {
      // Punctuation (semicolons, commas, dots)
      color = FittorColorScheme.punctuationColor;
    } else if (match.group(12) != null) {
      // Class names (starting with uppercase)
      color = FittorColorScheme.classColor;
      isBold = true;
    } else if (match.group(13) != null) {
      // Function calls (identifier followed by parenthesis)
      color = FittorColorScheme.functionColor;
      isBold = true;
    } else if (match.group(14) != null) {
      // Variables and other identifiers
      color = FittorColorScheme.variableColor;
    } else if (match.group(15) != null) {
      // Whitespace - preserve as is
      color = Colors.transparent;
    }

    return TokenStyle(color: color, isBold: isBold);
  }
}

/// Style information for a syntax token
class TokenStyle {
  final Color color;
  final bool isBold;

  const TokenStyle({
    required this.color,
    this.isBold = false,
  });
}
