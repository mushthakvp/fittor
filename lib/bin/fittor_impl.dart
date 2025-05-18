import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;

import 'string/app_urls.dart';
import 'string/main_dart_template.dart';

void main(List<String> arguments) {
  final runner = CommandRunner('fittor', 'Fittor project structure generator')
    ..addCommand(CreateCommand());

  try {
    runner.run(arguments);
  } catch (e) {
    print('Error: $e');
    runner.printUsage();
  }
}

class CreateCommand extends Command {
  @override
  final name = 'create';

  @override
  final description = 'Creates the standard Fittor project structure';

  @override
  void run() {
    createFittorStructure(Directory.current);
  }
}

void createFittorStructure(Directory baseDir) {
  // Create main.dart if it doesn't exist
  final mainFile = File(path.join(baseDir.path, 'lib', 'main.dart'));
  if (!mainFile.existsSync()) {
    mainFile.createSync(recursive: true);
    mainFile.writeAsStringSync(_mainDartTemplate());
  } else {
    mainFile.delete();
    mainFile.createSync(recursive: true);
    mainFile.writeAsStringSync(_mainDartTemplate());
  }

  // Create FitBindings

  _createFile(baseDir, 'fit_bindings.dart', _bindingTemplate());

  // Create core folder structure
  _createDirectory(baseDir, 'core/network');
  _createFile(baseDir, 'core/network/api_client.dart', _apiClientTemplate());
  _createFile(baseDir, 'core/network/fit_urls.dart', _apiUrlTemplate());

  _createDirectory(baseDir, 'core/util');
  _createFile(baseDir, 'core/util/fit_colors.dart', _fitColorsTemplate());
  _createFile(baseDir, 'core/util/storage.dart', _fitStorageTemplate());

  _createDirectory(baseDir, 'core/routes');
  _createFile(baseDir, 'core/routes/app_routes.dart', _appRoutesTemplate());

  // Create data folder structure
  _createDirectory(baseDir, 'data/model');
  _createFile(baseDir, 'data/model/fit_model.dart', _sampleModelTemplate());

  _createDirectory(baseDir, 'data/repo');
  _createFile(
    baseDir,
    'data/repo/fitter_sample_repo.dart',
    _sampleRepositoryTemplate(),
  );

  _createDirectory(baseDir, 'data/source');
  _createFile(
    baseDir,
    'data/source/fitter_sample_source.dart',
    _sampleDataSourceTemplate(),
  );

  // Create presentation folder structure
  _createDirectory(baseDir, 'presentation/screen');
  _createFile(
    baseDir,
    'presentation/screen/fitter_view.dart',
    _sampleScreenTemplate(),
  );

  _createDirectory(baseDir, 'presentation/controller');
  _createFile(
    baseDir,
    'presentation/controller/sample_controller.dart',
    _sampleControllerTemplate(),
  );

  _createDirectory(baseDir, 'presentation/widget');

  print('\n🎉 Fittor project structure created successfully!');
  print('\nConnect me on Email: mail.musthak@gmail.com');
  print('\nFollow me on Instagram: @musth4k');
  print('\nFollow me on Github: @mushthakvp');
  print('\nThank you for using Fittor! 🚀 & We are using Clean architecture');
  print('\nRecommended next steps:');
  print('\n1. Run "flutter pub get" to install dependencies');
}

void _createDirectory(Directory baseDir, String relativePath) {
  final directory = Directory(path.join(baseDir.path, relativePath));
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
    print('  Created directory: $relativePath');
  }
}

void _createFile(Directory baseDir, String relativePath, String content) {
  final file = File(path.join(baseDir.path, relativePath));
  if (!file.existsSync()) {
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  } else {
    print('File already exists, skipping: $relativePath');
  }
}

String _mainDartTemplate() {
  return mainDartTemplate;
}

String _bindingTemplate() {
  return fitBinding;
}

String _apiClientTemplate() {
  return apiClient;
}

String _apiUrlTemplate() {
  return appUrls;
}

String _fitColorsTemplate() {
  return fitColor;
}

String _fitStorageTemplate() {
  return fittorStorage;
}

String _appRoutesTemplate() {
  return appRoutes;
}

String _sampleModelTemplate() {
  return sampleModel;
}

String _sampleRepositoryTemplate() {
  return fittorSampleRepo;
}

String _sampleDataSourceTemplate() {
  return sampleDataSource;
}

String _sampleScreenTemplate() {
  return sampleHomeScreen;
}

String _sampleControllerTemplate() {
  return sampleController;
}
