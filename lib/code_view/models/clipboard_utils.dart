import 'package:flutter/services.dart';

/// Utility class for clipboard operations
class ClipboardUtils {
  const ClipboardUtils._();

  /// Copies text to clipboard
  ///
  /// Returns true if successful, false otherwise
  static Future<bool> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } catch (e) {
      // Log error or handle it as needed
      return false;
    }
  }

  /// Gets text from clipboard
  ///
  /// Returns the clipboard text or null if unavailable
  static Future<String?> getFromClipboard() async {
    try {
      final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      return data?.text;
    } catch (e) {
      // Log error or handle it as needed
      return null;
    }
  }

  /// Checks if clipboard has text
  ///
  /// Returns true if clipboard contains text, false otherwise
  static Future<bool> hasText() async {
    try {
      final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      return data?.text?.isNotEmpty ?? false;
    } catch (e) {
      return false;
    }
  }
}
