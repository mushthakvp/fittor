import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that displays Dart code with vibrant syntax highlighting.
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

  /// Enhanced rainbow gradient colors for brackets and special elements
  static const List<Color> _rainbowColors = [
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
  static const Color _keywordColor = Color(0xFF569CD6); // Bright Blue
  static const Color _classColor = Color(0xFF4EC9B0); // Teal
  static const Color _stringColor = Color(0xFFD69E2E); // Golden Orange
  static const Color _numberColor = Color(0xFFB5CEA8); // Light Green
  static const Color _commentColor = Color(0xFF6A9955); // Forest Green
  static const Color _functionColor = Color(0xFFDCDCAA); // Light Yellow
  static const Color _variableColor = Color(0xFF9CDCFE); // Light Blue
  static const Color _punctuationColor = Color(0xFFD4D4D4); // Light Gray
  static const Color _annotationColor = Color(0xFFFFB347); // Orange
  static const Color _operatorColor = Color(0xFFFF6B9D); // Pink
  static const Color _importColor = Color(0xFF569CD6); // Blue
  static const Color _constantColor = Color(0xFF4FC1FF); // Sky Blue
  static const Color _typeColor = Color(0xFF4EC9B0); // Cyan

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

  /// Renders the enhanced colorful code view with syntax highlighting.
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.purple.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2D2D30),
              Color(0xFF1E1E1E),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.purple.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced terminal-style header with gradient
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF404045),
                    Color(0xFF353539),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Enhanced terminal dots with glow effect
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5F57),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF5F57).withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFBD2E),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFBD2E).withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF28CA42),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF28CA42).withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.language.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _copyToClipboard,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: _isCopied
                            ? const LinearGradient(
                                colors: [Colors.green, Colors.teal])
                            : const LinearGradient(
                                colors: [Colors.blue, Colors.purple]),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: (_isCopied ? Colors.green : Colors.blue)
                                .withOpacity(0.3),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isCopied
                                ? Icons.check_rounded
                                : Icons.copy_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isCopied ? 'Copied!' : 'Copy',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Enhanced code content with vibrant syntax highlighting
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1E1E1E),
                    Color(0xFF0F0F0F),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SelectableText.rich(
                  _buildEnhancedSyntaxHighlightedText(widget.code),
                  style: const TextStyle(
                    fontFamily: 'Fira Code',
                    letterSpacing: 0.5,
                    fontSize: 14,
                    height: 1.5,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds enhanced syntax highlighted text with vibrant colors and more rules
  TextSpan _buildEnhancedSyntaxHighlightedText(String code) {
    final lines = code.split('\n');
    final List<TextSpan> spans = [];

    // Track bracket nesting levels globally across all lines
    int parenthesesLevel = 0;
    int braceLevel = 0;
    int bracketLevel = 0;

    for (int i = 0; i < lines.length; i++) {
      // Add enhanced line number with gradient background
      spans.add(
        TextSpan(
          text: '${(i + 1).toString().padLeft(2)}  ',
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
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
            color: Colors.cyan.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      // Add enhanced syntax highlighted line
      final lineSpan = _highlightEnhancedLine(
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

  /// Enhanced line highlighting with more colorful syntax rules
  _LineResult _highlightEnhancedLine(
    String line,
    int initialParenthesesLevel,
    int initialBraceLevel,
    int initialBracketLevel,
  ) {
    final List<TextSpan> spans = [];

    int parenthesesLevel = initialParenthesesLevel;
    int braceLevel = initialBraceLevel;
    int bracketLevel = initialBracketLevel;

    // Enhanced regex with more token types
    final RegExp tokenRegex = RegExp(
      r'''(@\w+)|(\b(?:abstract|as|assert|async|await|break|case|catch|class|const|continue|default|deferred|do|dynamic|else|enum|export|extends|external|factory|false|final|finally|for|Function|get|hide|if|implements|import|in|interface|is|library|mixin|new|null|on|operator|part|rethrow|return|set|show|static|super|switch|sync|this|throw|true|try|typedef|var|void|while|with|yield)\b)|(\b(?:String|int|double|bool|List|Map|Set|Iterable|Future|Stream|Widget|State|StatefulWidget|StatelessWidget|BuildContext|Container|Text|Icon|Row|Column|Padding|EdgeInsets|BoxDecoration|BorderRadius|Color|Colors|TextStyle|MaterialApp|Scaffold|AppBar|FloatingActionButton|Navigator|Route|PageRoute|MaterialPageRoute|AnimationController|Animation|Tween|Duration|Curve|Curves)\b)|(\b\d+(?:\.\d+)?(?:[eE][+-]?\d+)?\b)|(\b0x[A-Fa-f0-9]+\b)|(\/\/.*$)|(\/\*[\s\S]*?\*\/)|(["\'](?:[^"'\\]|\\.)*["\'])|(=>|==|!=|<=|>=|&&|\|\||[+\-*/%<>=!&|^~])|([(){}[\]])|([;,.])|(\b[A-Z]\w*)|(\b[a-z]\w*\()|(\b[a-z_]\w*)|(\s+)|(.)''',
      multiLine: true,
    );

    final matches = tokenRegex.allMatches(line);
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
      Color color = Colors.white;
      bool isBold = false;
      bool hasGlow = false;

      if (match.group(1) != null) {
        // Annotations (@override, @deprecated, etc.)
        color = _annotationColor;
        isBold = true;
        hasGlow = true;
      } else if (match.group(2) != null) {
        // Keywords (class, extends, if, else, etc.)
        color = _keywordColor;
        isBold = true;
        hasGlow = true;
      } else if (match.group(3) != null) {
        // Types and built-in classes
        color = _typeColor;
        isBold = true;
      } else if (match.group(4) != null || match.group(5) != null) {
        // Numbers and hex colors
        color = _numberColor;
        hasGlow = true;
      } else if (match.group(6) != null || match.group(7) != null) {
        // Comments
        color = _commentColor;
      } else if (match.group(8) != null) {
        // Strings
        color = _stringColor;
        hasGlow = true;
      } else if (match.group(9) != null) {
        // Operators (=>, ==, !=, +, -, etc.)
        color = _operatorColor;
        isBold = true;
        hasGlow = true;
      } else if (match.group(10) != null) {
        // Brackets and braces with rainbow colors
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
        }
        isBold = true;
        hasGlow = true;
      } else if (match.group(11) != null) {
        // Punctuation (semicolons, commas, dots)
        color = _punctuationColor;
      } else if (match.group(12) != null) {
        // Class names (starting with uppercase)
        color = _classColor;
        isBold = true;
      } else if (match.group(13) != null) {
        // Function calls (identifier followed by parenthesis)
        color = _functionColor;
        isBold = true;
      } else if (match.group(14) != null) {
        // Variables and other identifiers
        color = _variableColor;
      } else if (match.group(15) != null) {
        // Whitespace - preserve as is
        color = Colors.transparent;
      }

      // Create text span with enhanced styling
      spans.add(
        TextSpan(
          text: token,
          style: TextStyle(
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
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
