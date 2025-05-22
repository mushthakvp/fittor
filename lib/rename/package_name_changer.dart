// File: lib/rename/package_name_changer.dart
import 'dart:io';

import 'package:path/path.dart' as path;

import 'utils/print_utils.dart';

class PackageNameChanger {
  void changePackageName(String newPackageName) {
    final currentDir = Directory.current;

    try {
      PrintUtils.printHint('🔄 Changing package name to: $newPackageName');

      // Update pubspec.yaml
      _updatePubspecPackageName(currentDir, newPackageName);
      PrintUtils.printHint('✓ Updated pubspec.yaml');

      // Update Android package name
      _updateAndroidPackageName(currentDir, newPackageName);
      PrintUtils.printHint('✓ Updated Android configuration');

      // Update iOS bundle identifier
      _updateiOSBundleIdentifier(currentDir, newPackageName);
      PrintUtils.printHint('✓ Updated iOS configuration');

      // Update Dart files with package references
      _updateDartPackageReferences(currentDir, newPackageName);
      PrintUtils.printHint('✓ Updated Dart package references');

      PrintUtils.printSuccess('✅ Package name changed to: $newPackageName');
      PrintUtils.printHint(
          'Run "flutter clean && flutter pub get" to apply changes');
    } catch (e) {
      PrintUtils.printError('Failed to change package name: $e');
    }
  }

  void _updatePubspecPackageName(Directory projectDir, String newPackageName) {
    final pubspecFile = File(path.join(projectDir.path, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) {
      throw Exception('pubspec.yaml not found');
    }

    String content = pubspecFile.readAsStringSync();

    // Extract app name from package name (last part after last dot)
    final appName = newPackageName.split('.').last;

    // Update name field
    content = content.replaceFirst(
        RegExp(r'^name:\s*.*$', multiLine: true), 'name: $appName');

    pubspecFile.writeAsStringSync(content);
  }

  void _updateAndroidPackageName(Directory projectDir, String newPackageName) {
    // Update build.gradle
    final buildGradleFile =
        File(path.join(projectDir.path, 'android', 'app', 'build.gradle'));

    if (buildGradleFile.existsSync()) {
      String content = buildGradleFile.readAsStringSync();

      // First try with double quotes
      final doubleQuotePattern = RegExp(r'applicationId\s*"[^"]*"');
      if (doubleQuotePattern.hasMatch(content)) {
        content = content.replaceFirst(
            doubleQuotePattern, 'applicationId "$newPackageName"');
      } else {
        // Then try with single quotes
        final singleQuotePattern = RegExp(r"applicationId\s*'[^']*'");
        content = content.replaceFirst(
            singleQuotePattern, 'applicationId "$newPackageName"');
      }

      buildGradleFile.writeAsStringSync(content);
    }

    // Update AndroidManifest.xml files
    final manifestPaths = [
      path.join(projectDir.path, 'android', 'app', 'src', 'main',
          'AndroidManifest.xml'),
      path.join(projectDir.path, 'android', 'app', 'src', 'debug',
          'AndroidManifest.xml'),
      path.join(projectDir.path, 'android', 'app', 'src', 'profile',
          'AndroidManifest.xml'),
    ];

    for (final manifestPath in manifestPaths) {
      final manifestFile = File(manifestPath);
      if (manifestFile.existsSync()) {
        String content = manifestFile.readAsStringSync();
        content = content.replaceAll(
            RegExp(r'package="[^"]*"'), 'package="$newPackageName"');
        manifestFile.writeAsStringSync(content);
      }
    }

    // Update Kotlin/Java files if they exist
    _updateMainActivityPackage(projectDir, newPackageName);
  }

  void _updateMainActivityPackage(Directory projectDir, String newPackageName) {
    // final kotlinMainActivity = File(path.join(
    //     projectDir.path,
    //     'android',
    //     'app',
    //     'src',
    //     'main',
    //     'kotlin',
    //     newPackageName.split('.').join('/'),
    //     'MainActivity.kt'));

    // final javaMainActivity = File(path.join(
    //     projectDir.path,
    //     'android',
    //     'app',
    //     'src',
    //     'main',
    //     'java',
    //     newPackageName.split('.').join('/'),
    //     'MainActivity.java'));

    // Create new directory structure and move files
    final newKotlinDir = Directory(path.join(projectDir.path, 'android', 'app',
        'src', 'main', 'kotlin', newPackageName.split('.').join('/')));

    final newJavaDir = Directory(path.join(projectDir.path, 'android', 'app',
        'src', 'main', 'java', newPackageName.split('.').join('/')));

    // Check for existing MainActivity files and update package declaration
    final existingKotlinFiles = Directory(
        path.join(projectDir.path, 'android', 'app', 'src', 'main', 'kotlin'));

    final existingJavaFiles = Directory(
        path.join(projectDir.path, 'android', 'app', 'src', 'main', 'java'));

    if (existingKotlinFiles.existsSync()) {
      _updateAndMoveAndroidFiles(
          existingKotlinFiles, newKotlinDir, newPackageName, '.kt');
    }

    if (existingJavaFiles.existsSync()) {
      _updateAndMoveAndroidFiles(
          existingJavaFiles, newJavaDir, newPackageName, '.java');
    }
  }

  void _updateAndMoveAndroidFiles(Directory sourceDir, Directory targetDir,
      String newPackageName, String extension) {
    if (!sourceDir.existsSync()) return;

    sourceDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith(extension))
        .forEach((file) {
      String content = file.readAsStringSync();

      // Update package declaration
      content = content.replaceFirst(
          RegExp(r'^package\s+[^\s;]+', multiLine: true),
          'package $newPackageName');

      // Create target directory if it doesn't exist
      if (!targetDir.existsSync()) {
        targetDir.createSync(recursive: true);
      }

      // Write to new location
      final fileName = path.basename(file.path);
      final newFile = File(path.join(targetDir.path, fileName));
      newFile.writeAsStringSync(content);

      // Delete old file
      file.deleteSync();
    });

    // Clean up empty directories
    _cleanupEmptyDirectories(sourceDir);
  }

  void _cleanupEmptyDirectories(Directory dir) {
    if (!dir.existsSync()) return;

    try {
      final contents = dir.listSync();
      if (contents.isEmpty) {
        dir.deleteSync();
        // Recursively clean parent if it becomes empty
        final parent = dir.parent;
        if (parent.path != dir.path) {
          _cleanupEmptyDirectories(parent);
        }
      } else {
        // Check subdirectories
        for (final item in contents.whereType<Directory>()) {
          _cleanupEmptyDirectories(item);
        }
      }
    } catch (e) {
      // Ignore errors during cleanup
    }
  }

  void _updateiOSBundleIdentifier(Directory projectDir, String newPackageName) {
    // Update Info.plist
    final infoPlistFile =
        File(path.join(projectDir.path, 'ios', 'Runner', 'Info.plist'));

    if (infoPlistFile.existsSync()) {
      String content = infoPlistFile.readAsStringSync();
      content = content.replaceAll(
          RegExp(r'<key>CFBundleIdentifier</key>\s*<string>[^<]*</string>'),
          '<key>CFBundleIdentifier</key>\n\t<string>$newPackageName</string>');
      infoPlistFile.writeAsStringSync(content);
    }

    // Update project.pbxproj
    final pbxprojFile = File(path.join(
        projectDir.path, 'ios', 'Runner.xcodeproj', 'project.pbxproj'));

    if (pbxprojFile.existsSync()) {
      String content = pbxprojFile.readAsStringSync();
      content = content.replaceAll(
          RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = [^;]*;'),
          'PRODUCT_BUNDLE_IDENTIFIER = $newPackageName;');
      pbxprojFile.writeAsStringSync(content);
    }

    // Update ExportOptions.plist if it exists
    final exportOptionsFile =
        File(path.join(projectDir.path, 'ios', 'ExportOptions.plist'));

    if (exportOptionsFile.existsSync()) {
      String content = exportOptionsFile.readAsStringSync();
      // Fixed: More specific regex for ExportOptions.plist
      content = content.replaceAll(
          RegExp(r'<key>teamID</key>\s*<string>[^<]*</string>'),
          '<key>teamID</key>\n\t\t<string>YOUR_TEAM_ID</string>');
      exportOptionsFile.writeAsStringSync(content);
    }
  }

  void _updateDartPackageReferences(
      Directory projectDir, String newPackageName) {
    final libDir = Directory(path.join(projectDir.path, 'lib'));
    if (!libDir.existsSync()) return;

    final appName = newPackageName.split('.').last;

    libDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .forEach((file) {
      String content = file.readAsStringSync();

      // Get current package name from pubspec to replace
      final currentPackageName = _getCurrentPackageName(projectDir);

      if (currentPackageName != null) {
        // Update import statements
        content = content.replaceAll("import 'package:$currentPackageName/",
            "import 'package:$appName/");

        // Update export statements
        content = content.replaceAll("export 'package:$currentPackageName/",
            "export 'package:$appName/");
      }

      file.writeAsStringSync(content);
    });
  }

  String? _getCurrentPackageName(Directory projectDir) {
    final pubspecFile = File(path.join(projectDir.path, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) return null;

    final content = pubspecFile.readAsStringSync();
    final match = RegExp(r'^name:\s*(.+)', multiLine: true).firstMatch(content);
    return match?.group(1)?.trim();
  }
}
