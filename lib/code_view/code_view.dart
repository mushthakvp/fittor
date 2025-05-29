import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that displays Dart code with syntax highlighting.
class FittorCode extends StatefulWidget {
  final String code;
  final String? title;
  final String language;

  const FittorCode({
    super.key,
    required this.code,
    this.title,
    this.language = 'dart',
  });

  @override
  State<FittorCode> createState() => _FittorCodeState();
}

class _FittorCodeState extends State<FittorCode> {
  bool _isCopied = false;

  /// Returns a rainbow gradient background for the code view.
  static const List<Color> _rainbowColors = [
    Color(0xFFFF6B6B), // Red
    Color(0xFFFFB347), // Orange
    Color(0xFFFFEB3B), // Yellow
    Color(0xFF4CAF50), // Green
    Color(0xFF2196F3), // Blue
    Color(0xFF3F51B5), // Indigo
    Color(0xFF9C27B0), // Purple
    Color(0xFF673AB7), // Deep Purple
    Color(0xFF795548), // Brown
    Color(0xFF9E9E9E), // Grey
    Color(0xFF9C27B0), // Pink
    Color(0xFF009688), // Teal
    Color(0xFF607D8B), // Cyan
  ];

  /// Copies the code to the clipboard.
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.code));
    setState(() {
      _isCopied = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  /// Renders the code view with syntax highlighting.
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2D2D30),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Terminal-style header with colored dots
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF404045),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  // Terminal dots
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5F57),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFBD2E),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF28CA42),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (widget.title != null)
                    Text(
                      widget.language,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _copyToClipboard,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isCopied
                                ? Icons.check_rounded
                                : Icons.copy_rounded,
                            size: 14,
                            color: _isCopied
                                ? const Color(0xFF28CA42)
                                : Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isCopied ? 'Copied!' : 'Copy',
                            style: TextStyle(
                              color: _isCopied
                                  ? const Color(0xFF28CA42)
                                  : Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Code content with syntax highlighting
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SelectableText.rich(
                  _buildSyntaxHighlightedText(widget.code),
                  style: const TextStyle(
                    letterSpacing: 1,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a syntax highlighted text span for the given line of code.
  TextSpan _buildSyntaxHighlightedText(String code) {
    final lines = code.split('\n');
    final List<TextSpan> spans = [];

    // Track bracket nesting levels globally across all lines
    int parenthesesLevel = 0;
    int braceLevel = 0;
    int bracketLevel = 0;

    /// Builds a syntax highlighted text span for the given line of code.
    for (int i = 0; i < lines.length; i++) {
      // Add line number
      spans.add(
        TextSpan(
          text: '${(i + 1).toString().padLeft(2)}     ',
          style: const TextStyle(color: Color(0xFF6A6A6A), fontSize: 12),
        ),
      );

      // Add syntax highlighted line with global nesting levels
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

  // Helper class to return both TextSpan and updated nesting levels
  _LineResult _highlightLine(
    String line,
    int initialParenthesesLevel,
    int initialBraceLevel,
    int initialBracketLevel,
  ) {
    final List<TextSpan> spans = [];

    // Use the passed nesting levels
    int parenthesesLevel = initialParenthesesLevel;
    int braceLevel = initialBraceLevel;
    int bracketLevel = initialBracketLevel;

    /// Highlight the line using a regular expression
    final RegExp tokenRegex = RegExp(
      r'''(\b(?:class|extends|final|const|override|return|if|else|void|String|bool|int|double|Widget|State|BuildContext|Container|EdgeInsets|BoxDecoration|BorderRadius|Color|Colors|TextStyle|Text|Icon|Icons|Row|Column|Padding|Margin|SizedBox|GestureDetector|StatefulWidget|StatelessWidget|@override|import|package|library|part|export|show|hide|as|super|this|new|null|true|false|var|dynamic)\b)|(\b\d+(?:\.\d+)?\b)|(\b0x[A-Fa-f0-9]+\b)|(\/\/.*$)|(\/\*[\s\S]*?\*\/)|(["\'](?:[^"'\\]|\\.)*["\'])|([(){}[\]])|([;,.])|(\w+)|([ \t]+)|(.)''',
      multiLine: true,
    );

    final matches = tokenRegex.allMatches(line);
    int lastEnd = 0;

    /// Highlight the line using a regular expression
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
      Color color = Colors.white;

      if (match.group(1) != null) {
        // Keywords
        color = const Color(0xFF569CD6); // Blue
      } else if (match.group(2) != null || match.group(3) != null) {
        // Numbers and hex colors
        color = const Color(0xFFB5CEA8); // Light green
      } else if (match.group(4) != null || match.group(5) != null) {
        // Comments
        color = const Color(0xFF6A9955); // Green
      } else if (match.group(6) != null) {
        // Strings
        color = const Color(0xFFD69E2E); // Orange/Yellow
      } else if (match.group(7) != null) {
        // Brackets and braces - Rainbow colors based on nesting level
        switch (token) {
          case '(':
            color = _rainbowColors[parenthesesLevel % _rainbowColors.length];
            parenthesesLevel++;
            break;
          case ')':
            parenthesesLevel =
                (parenthesesLevel - 1).clamp(0, double.infinity).toInt();
            color = _rainbowColors[parenthesesLevel % _rainbowColors.length];
            break;
          case '{':
            color = _rainbowColors[braceLevel % _rainbowColors.length];
            braceLevel++;
            break;
          case '}':
            braceLevel = (braceLevel - 1).clamp(0, double.infinity).toInt();
            color = _rainbowColors[braceLevel % _rainbowColors.length];
            break;
          case '[':
            color = _rainbowColors[bracketLevel % _rainbowColors.length];
            bracketLevel++;
            break;
          case ']':
            bracketLevel = (bracketLevel - 1).clamp(0, double.infinity).toInt();
            color = _rainbowColors[bracketLevel % _rainbowColors.length];
            break;
          default:
            color = const Color(0xFFD4D4D4); // Light gray for other brackets
        }
      } else if (match.group(8) != null) {
        // Other punctuation (semicolons, commas, dots)
        color = const Color(0xFFD4D4D4); // Light gray
      } else if (match.group(9) != null) {
        // Identifiers (method names, variables)
        if (token.contains(RegExp(r'^[A-Z]'))) {
          color = const Color(0xFF4EC9B0); // Teal for classes
        } else {
          color = const Color(0xFF9CDCFE); // Light blue for variables/methods
        }
      }

      spans.add(TextSpan(text: token, style: TextStyle(color: color)));

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

    return _LineResult(
      span: TextSpan(children: spans),
      parenthesesLevel: parenthesesLevel,
      braceLevel: braceLevel,
      bracketLevel: bracketLevel,
    );
  }
}

// Helper class to track nesting levels across lines
class _LineResult {
  final TextSpan span;
  final int parenthesesLevel;
  final int braceLevel;
  final int bracketLevel;

  _LineResult({
    required this.span,
    required this.parenthesesLevel,
    required this.braceLevel,
    required this.bracketLevel,
  });
}
