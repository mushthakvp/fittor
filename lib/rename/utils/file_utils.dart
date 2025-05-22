// File: lib/rename/utils/file_utils.dart
import 'dart:io';

import 'package:path/path.dart' as path;

class FileUtils {
  /// Safely reads a file and returns its content, or null if file doesn't exist
  static String? readFileIfExists(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      try {
        return file.readAsStringSync();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Safely writes content to a file, creating directories if needed
  static bool writeFile(String filePath, String content) {
    try {
      final file = File(filePath);
      file.createSync(recursive: true);
      file.writeAsStringSync(content);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Creates a directory if it doesn't exist
  static bool createDirectory(String dirPath) {
    try {
      final directory = Directory(dirPath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes a file if it exists
  static bool deleteFile(String filePath) {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes a directory and all its contents
  static bool deleteDirectory(String dirPath) {
    try {
      final directory = Directory(dirPath);
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Moves a file from source to destination
  static bool moveFile(String sourcePath, String destinationPath) {
    try {
      final sourceFile = File(sourcePath);
      if (sourceFile.existsSync()) {
        // Create destination directory if it doesn't exist
        final destDir = Directory(path.dirname(destinationPath));
        destDir.createSync(recursive: true);

        // Copy and delete original
        sourceFile.copySync(destinationPath);
        sourceFile.deleteSync();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Copies a file from source to destination
  static bool copyFile(String sourcePath, String destinationPath) {
    try {
      final sourceFile = File(sourcePath);
      if (sourceFile.existsSync()) {
        // Create destination directory if it doesn't exist
        final destDir = Directory(path.dirname(destinationPath));
        destDir.createSync(recursive: true);

        sourceFile.copySync(destinationPath);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Checks if a file exists
  static bool fileExists(String filePath) {
    return File(filePath).existsSync();
  }

  /// Checks if a directory exists
  static bool directoryExists(String dirPath) {
    return Directory(dirPath).existsSync();
  }

  /// Gets all files in a directory with a specific extension
  static List<File> getFilesWithExtension(String dirPath, String extension) {
    final directory = Directory(dirPath);
    if (!directory.existsSync()) return [];

    return directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith(extension))
        .toList();
  }

  /// Replaces text in a file using regex
  static bool replaceInFile(
      String filePath, RegExp pattern, String replacement) {
    try {
      final file = File(filePath);
      if (!file.existsSync()) return false;

      String content = file.readAsStringSync();
      content = content.replaceAll(pattern, replacement);
      file.writeAsStringSync(content);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Replaces text in a file using simple string replacement
  static bool replaceInFileSimple(
      String filePath, String oldText, String newText) {
    try {
      final file = File(filePath);
      if (!file.existsSync()) return false;

      String content = file.readAsStringSync();
      content = content.replaceAll(oldText, newText);
      file.writeAsStringSync(content);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets the current working directory
  static String getCurrentDirectory() {
    return Directory.current.path;
  }

  /// Joins multiple path components
  static String joinPath(List<String> components) {
    return path.joinAll(components);
  }

  /// Gets the file name from a path
  static String getFileName(String filePath) {
    return path.basename(filePath);
  }

  /// Gets the directory name from a path
  static String getDirectoryName(String filePath) {
    return path.dirname(filePath);
  }

  /// Gets the file extension
  static String getFileExtension(String filePath) {
    return path.extension(filePath);
  }
}
