import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

void main(List<String> arguments) {
  final parser = ArgParser()..addCommand('create');

  try {
    final results = parser.parse(arguments);

    if (results.command?.name == 'create') {
      createFittorStructure(Directory.current);
    } else {
      printUsage();
    }
  } catch (e) {
    debugPrint('Error: $e');
    printUsage();
  }
}

void printUsage() {
  debugPrint('Usage:');
  debugPrint('  flutter fittor create .');
  debugPrint(
    '      Creates the standard Fittor project structure in the current directory',
  );
}

void createFittorStructure(Directory baseDir) {
  debugPrint('🚀 Creating Fittor project structure...');

  // Create main.dart if it doesn't exist
  final mainFile = File(path.join(baseDir.path, 'lib', 'main.dart'));
  if (!mainFile.existsSync()) {
    mainFile.createSync(recursive: true);
    mainFile.writeAsStringSync(_mainDartTemplate());
    debugPrint('✅ Created lib/main.dart');
  } else {
    debugPrint('ℹ️ lib/main.dart already exists, skipping...');
  }

  // Create fittor directory structure
  final fittorDir = Directory(path.join(baseDir.path, 'lib', 'fittor'));

  // Create core folder structure
  _createDirectory(fittorDir, 'core/network');
  _createDirectory(fittorDir, 'core/util');
  _createDirectory(fittorDir, 'core/routes');
  debugPrint('✅ Created core folder structure');

  // Create data folder structure
  _createDirectory(fittorDir, 'data/model');
  _createDirectory(fittorDir, 'data/repo');
  _createDirectory(fittorDir, 'data/source');
  debugPrint('✅ Created data folder structure');

  // Create presentation folder structure
  _createDirectory(fittorDir, 'presentation/screen');
  _createDirectory(fittorDir, 'presentation/controller');
  debugPrint('✅ Created presentation folder structure');

  // Create index files for each main folder
  _createIndexFile(fittorDir, 'core');
  _createIndexFile(fittorDir, 'data');
  _createIndexFile(fittorDir, 'presentation');
  debugPrint('✅ Created index.dart files');

  // Create main index file for fittor directory
  final mainIndexFile = File(path.join(fittorDir.path, 'index.dart'));
  if (!mainIndexFile.existsSync()) {
    mainIndexFile.createSync(recursive: true);
    mainIndexFile.writeAsStringSync('''library fittor;

export 'core/index.dart';
export 'data/index.dart';
export 'presentation/index.dart';
''');
  }

  debugPrint('\n🎉 Fittor project structure created successfully!');
  debugPrint('\nRecommended next steps:');
  debugPrint('  1. Update your lib/main.dart file to use Fittor components');
  debugPrint('  2. Create your app routes in lib/fittor/core/routes');
  debugPrint('  3. Define your data models in lib/fittor/data/model');
}

void _createDirectory(Directory baseDir, String relativePath) {
  final directory = Directory(path.join(baseDir.path, relativePath));
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
}

void _createIndexFile(Directory baseDir, String folderName) {
  final indexFile = File(path.join(baseDir.path, folderName, 'index.dart'));
  if (!indexFile.existsSync()) {
    indexFile.createSync(recursive: true);
    indexFile.writeAsStringSync('''library fittor.$folderName;

''');
  }
}

String _mainDartTemplate() {
  return '''
import 'package:flutter/material.dart';
import 'fittor/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fittor App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fittor App'),
      ),
      body: Center(
        child: const Text('Welcome to Fittor!'),
      ),
    );
  }
}
''';
}
