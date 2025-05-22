// File: lib/rename/app_name_changer.dart
import 'dart:io';

import 'package:path/path.dart' as path;

import 'utils/print_utils.dart';

class AppNameChanger {
  void changeAppName(String newAppName) {
    final currentDir = Directory.current;

    try {
      PrintUtils.printHint('🔄 Changing app name to: $newAppName');

      // Update pubspec.yaml name
      _updatePubspecAppName(currentDir, newAppName);
      PrintUtils.printHint('✓ Updated pubspec.yaml');

      // Update Android app name
      _updateAndroidAppName(currentDir, newAppName);
      PrintUtils.printHint('✓ Updated Android app name');

      // Update iOS app name
      _updateiOSAppName(currentDir, newAppName);
      PrintUtils.printHint('✓ Updated iOS app name');

      // Update web app name
      _updateWebAppName(currentDir, newAppName);
      PrintUtils.printHint('✓ Updated web app name');

      PrintUtils.printSuccess('✅ App name changed to: $newAppName');
      PrintUtils.printHint(
          'Run "flutter clean && flutter pub get" to apply changes');
    } catch (e) {
      PrintUtils.printError('Failed to change app name: $e');
    }
  }

  void _updatePubspecAppName(Directory projectDir, String newAppName) {
    final pubspecFile = File(path.join(projectDir.path, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) {
      throw Exception('pubspec.yaml not found');
    }

    String content = pubspecFile.readAsStringSync();

    // Convert app name to valid Dart package name
    final packageName = _sanitizePackageName(newAppName);

    // Update name field
    content = content.replaceFirst(
        RegExp(r'^name:\s*.*$', multiLine: true), 'name: $packageName');

    // Update description if it exists
    if (content.contains(RegExp(r'^description:\s*.*$', multiLine: true))) {
      content = content.replaceFirst(
          RegExp(r'^description:\s*.*$', multiLine: true),
          'description: $newAppName - A Flutter application.');
    }

    pubspecFile.writeAsStringSync(content);
  }

  String _sanitizePackageName(String appName) {
    return appName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
        .replaceAll(RegExp(r'^[0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  void _updateAndroidAppName(Directory projectDir, String newAppName) {
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
            RegExp(r'android:label="[^"]*"'), 'android:label="$newAppName"');
        manifestFile.writeAsStringSync(content);
      }
    }

    // Update strings.xml if exists
    final stringsFile = File(path.join(projectDir.path, 'android', 'app', 'src',
        'main', 'res', 'values', 'strings.xml'));

    if (stringsFile.existsSync()) {
      String content = stringsFile.readAsStringSync();
      content = content.replaceAll(
          RegExp(r'<string name="app_name">[^<]*</string>'),
          '<string name="app_name">$newAppName</string>');
      stringsFile.writeAsStringSync(content);
    } else {
      // Create strings.xml if it doesn't exist
      final valuesDir = Directory(path.join(
          projectDir.path, 'android', 'app', 'src', 'main', 'res', 'values'));

      if (!valuesDir.existsSync()) {
        valuesDir.createSync(recursive: true);
      }

      final stringsContent = '''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">$newAppName</string>
</resources>
''';

      stringsFile.writeAsStringSync(stringsContent);
    }

    // Update build.gradle for app name if needed
    final buildGradleFile =
        File(path.join(projectDir.path, 'android', 'app', 'build.gradle'));

    if (buildGradleFile.existsSync()) {
      String content = buildGradleFile.readAsStringSync();

      // Update resValue if it exists
      if (content.contains('resValue')) {
        content = content.replaceAll(
            RegExp(r'resValue "string", "app_name", "[^"]*"'),
            'resValue "string", "app_name", "$newAppName"');
        buildGradleFile.writeAsStringSync(content);
      }
    }
  }

  void _updateiOSAppName(Directory projectDir, String newAppName) {
    // Update Info.plist
    final infoPlistFile =
        File(path.join(projectDir.path, 'ios', 'Runner', 'Info.plist'));

    if (infoPlistFile.existsSync()) {
      String content = infoPlistFile.readAsStringSync();

      // Update CFBundleName
      content = content.replaceAll(
          RegExp(r'<key>CFBundleName</key>\s*<string>[^<]*</string>'),
          '<key>CFBundleName</key>\n\t<string>$newAppName</string>');

      // Update CFBundleDisplayName
      content = content.replaceAll(
          RegExp(r'<key>CFBundleDisplayName</key>\s*<string>[^<]*</string>'),
          '<key>CFBundleDisplayName</key>\n\t<string>$newAppName</string>');

      // Add CFBundleDisplayName if it doesn't exist
      if (!content.contains('CFBundleDisplayName')) {
        content = content.replaceFirst('</dict>',
            '\t<key>CFBundleDisplayName</key>\n\t<string>$newAppName</string>\n</dict>');
      }

      infoPlistFile.writeAsStringSync(content);
    }

    // Update InfoPlist.strings files for localization
    final localizationDirs = [
      path.join(projectDir.path, 'ios', 'Runner', 'Base.lproj'),
      path.join(projectDir.path, 'ios', 'Runner', 'en.lproj'),
    ];

    for (final locDir in localizationDirs) {
      final infoPlistStringsFile = File(path.join(locDir, 'InfoPlist.strings'));
      if (infoPlistStringsFile.existsSync()) {
        String content = infoPlistStringsFile.readAsStringSync();
        content = content.replaceAll(RegExp(r'CFBundleDisplayName = "[^"]*";'),
            'CFBundleDisplayName = "$newAppName";');
        content = content.replaceAll(RegExp(r'CFBundleName = "[^"]*";'),
            'CFBundleName = "$newAppName";');
        infoPlistStringsFile.writeAsStringSync(content);
      }
    }

    // Update project.pbxproj for product name
    final pbxprojFile = File(path.join(
        projectDir.path, 'ios', 'Runner.xcodeproj', 'project.pbxproj'));

    if (pbxprojFile.existsSync()) {
      String content = pbxprojFile.readAsStringSync();
      content = content.replaceAll(
          RegExp(r'PRODUCT_NAME = [^;]*;'), 'PRODUCT_NAME = "$newAppName";');
      pbxprojFile.writeAsStringSync(content);
    }
  }

  void _updateWebAppName(Directory projectDir, String newAppName) {
    // Update web/index.html
    final indexHtmlFile = File(path.join(projectDir.path, 'web', 'index.html'));

    if (indexHtmlFile.existsSync()) {
      String content = indexHtmlFile.readAsStringSync();

      // Update title
      content = content.replaceAll(
          RegExp(r'<title>[^<]*</title>'), '<title>$newAppName</title>');

      // Update meta name="apple-mobile-web-app-title"
      content = content.replaceAll(
          RegExp(r'<meta name="apple-mobile-web-app-title" content="[^"]*">'),
          '<meta name="apple-mobile-web-app-title" content="$newAppName">');

      indexHtmlFile.writeAsStringSync(content);
    }

    // Update web/manifest.json
    final manifestJsonFile =
        File(path.join(projectDir.path, 'web', 'manifest.json'));

    if (manifestJsonFile.existsSync()) {
      String content = manifestJsonFile.readAsStringSync();

      // Update name and short_name
      content = content.replaceAll(
          RegExp(r'"name":\s*"[^"]*"'), '"name": "$newAppName"');
      content = content.replaceAll(
          RegExp(r'"short_name":\s*"[^"]*"'), '"short_name": "$newAppName"');

      manifestJsonFile.writeAsStringSync(content);
    }
  }
}
