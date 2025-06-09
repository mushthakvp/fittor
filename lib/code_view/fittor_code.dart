/// A beautiful, colorful code viewer widget for Flutter with syntax highlighting
/// and copy/launch functionality.
///
/// Features:
/// - Vibrant syntax highlighting with rainbow bracket colors
/// - Copy to clipboard functionality
/// - Optional launch button with callback support
/// - Web-safe implementation (no dart:io or dart:html dependencies)
/// - Support for multiple programming languages
/// - Terminal-style UI with gradient backgrounds
///
/// Example usage:
/// ```dart
/// FittorCode(
///   code: 'print("Hello, World!");',
///   language: 'dart',
///   launch: true,
///   onLaunch: () {
///     // Your custom launch logic here
///   },
/// )
/// ```
library fittor_code;

export 'src/code_view_widget.dart';
export 'models/line_result.dart';
