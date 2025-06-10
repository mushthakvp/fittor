import 'package:flutter/material.dart';
import '../models/clipboard_utils.dart';
import 'color_schemes.dart';
import 'syntax_highlighter.dart';

class FittorCode extends StatefulWidget {
  final String code;
  final String? title;
  final String language;
  final bool? launch;
  final String? url;
  final VoidCallback? onLaunch;

  const FittorCode({
    super.key,
    required this.code,
    this.title,
    this.language = 'dart',
    this.launch,
    this.url,
    this.onLaunch,
  }) : assert(
          launch != true || onLaunch != null,
          'When launch is true, onLaunch callback must be provided',
        );

  @override
  State<FittorCode> createState() => _FittorCodeState();
}

class _FittorCodeState extends State<FittorCode> {
  bool _isActionCompleted = false;

  Future<void> _copyToClipboard() async {
    await ClipboardUtils.copyToClipboard(widget.code);
    setState(() => _isActionCompleted = true);
    _resetActionState();
  }

  Future<void> _launchAction() async {
    try {
      setState(() => _isActionCompleted = true);

      if (widget.onLaunch != null) {
        widget.onLaunch!();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No launch callback provided'),
              backgroundColor: Color.fromARGB(255, 244, 67, 54),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Launch failed: $e'),
            backgroundColor: const Color.fromARGB(255, 244, 67, 54),
          ),
        );
      }
    } finally {
      _resetActionState();
    }
  }

  void _resetActionState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isActionCompleted = false;
        });
      }
    });
  }

  void _showLaunchInstructions() {
    if (widget.url == null || widget.url!.isEmpty) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2D2D30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text('Launch URL', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'URL to open:',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromARGB(77, 33, 150, 243),
                  ),
                ),
                child: SelectableText(
                  widget.url!,
                  style: const TextStyle(
                      color: Colors.blue, fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Copy the URL above and paste it in your browser.',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await ClipboardUtils.copyToClipboard(widget.url!);
                _handleMounted();
              },
              child: const Text('Copy URL'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _handleMounted() {
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL copied to clipboard!'),
          backgroundColor: Color.fromARGB(255, 76, 175, 80),
        ),
      );
    }
  }

  void handleActionButtonTap() {
    if (widget.launch == true) {
      _launchAction();
    } else {
      _copyToClipboard();
    }
  }

  String get _buttonText => widget.launch == true
      ? (_isActionCompleted ? 'Launched!' : 'Launch')
      : (_isActionCompleted ? 'Copied!' : 'Copy');

  IconData get _buttonIcon => widget.launch == true
      ? (_isActionCompleted ? Icons.check_rounded : Icons.launch_rounded)
      : (_isActionCompleted ? Icons.check_rounded : Icons.copy_rounded);

  List<Color> get _buttonColors {
    if (_isActionCompleted) return FittorColorScheme.successButtonGradient;
    return widget.launch == true
        ? FittorColorScheme.launchButtonGradient
        : FittorColorScheme.copyButtonGradient;
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Card(
        elevation: 8,
        shadowColor: const Color.fromARGB(77, 156, 39, 176),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: FittorColorScheme.backgroundGradient,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
              buildCodeArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: FittorColorScheme.headerGradient),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(51, 0, 0, 0),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          buildTerminalDots(),
          const SizedBox(width: 16),
          buildLanguageTag(),
          const Spacer(),
          buildActionButton(),
        ],
      ),
    );
  }

  Widget buildTerminalDots() {
    return Row(
      children: [
        buildDot(FittorColorScheme.redDot),
        const SizedBox(width: 8),
        buildDot(FittorColorScheme.yellowDot),
        const SizedBox(width: 8),
        buildDot(FittorColorScheme.greenDot),
      ],
    );
  }

  Widget buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withAlpha((color.a / 2).round()),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget buildLanguageTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(colors: FittorColorScheme.languageTagGradient),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        widget.language.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget buildActionButton() {
    return GestureDetector(
      onTap: handleActionButtonTap,
      onLongPress: widget.url != null ? _showLaunchInstructions : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: _buttonColors),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: _buttonColors.first.withAlpha(77),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_buttonIcon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              _buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCodeArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: FittorColorScheme.codeAreaGradient,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText.rich(
          SyntaxHighlighter.buildSyntaxHighlightedText(widget.code),
          style: const TextStyle(
            fontFamily: 'Fira Code',
            letterSpacing: 0.5,
            fontSize: 14,
            height: 1.5,
            shadows: [
              Shadow(
                color: Color.fromARGB(64, 0, 0, 0),
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
