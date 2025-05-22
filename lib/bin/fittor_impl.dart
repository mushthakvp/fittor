import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fittor/fittor.dart';
import 'package:path/path.dart' as path;

import 'string/app_urls.dart';
import 'string/main_dart_template.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner('fittor', 'Fittor project structure generator')
    ..addCommand(CreateCommand())
    ..addCommand(RenameCommand());

  if (arguments.isEmpty ||
      arguments.contains('-h') ||
      arguments.contains('--help')) {
    _printHelp(runner);
    return;
  }

  try {
    await runner.run(arguments);
  } on UsageException catch (e) {
    _printError('Error: ${e.message}');
    print(e.usage);
    final input = arguments.isNotEmpty ? arguments.first : '';
    final suggestion = _suggestCommand(input, runner.commands.keys.toList());
    if (suggestion != null) {
      _printHint('Did you mean: "$suggestion"?');
    }
    _printHelp(runner);
    exit(64);
  } catch (e) {
    _printError('Unexpected error: $e');
    exit(1);
  }
}

void _printHelp(CommandRunner runner) {
  _printTitle('Available Commands:');
  runner.commands.forEach((name, cmd) {
    print('  \x1B[32m$name\x1B[0m\t\t${cmd.description}');
  });
  print('\nUsage: \x1B[34mfittor create app\x1B[0m');
}

void _printTitle(String message) => print('\n\x1B[1m$message\x1B[0m');
void _printError(String message) => print('\x1B[31m$message\x1B[0m');
void _printHint(String message) => print('\x1B[33m$message\x1B[0m');

String? _suggestCommand(String input, List<String> validCommands) {
  if (input.isEmpty) return null;

  String? closest;
  int minDistance = 3;

  for (final command in validCommands) {
    final distance = _levenshtein(input, command);
    if (distance < minDistance) {
      minDistance = distance;
      closest = command;
    }
  }

  return (minDistance <= 2) ? closest : null;
}

int _levenshtein(String s1, String s2) {
  final m = s1.length;
  final n = s2.length;
  final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));

  for (var i = 0; i <= m; i++) {
    dp[i][0] = i;
  }
  for (var j = 0; j <= n; j++) {
    dp[0][j] = j;
  }

  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      if (s1[i - 1] == s2[j - 1]) {
        dp[i][j] = dp[i - 1][j - 1];
      } else {
        dp[i][j] = 1 +
            [
              dp[i - 1][j],
              dp[i][j - 1],
              dp[i - 1][j - 1],
            ].reduce((a, b) => a < b ? a : b);
      }
    }
  }

  return dp[m][n];
}

class CreateCommand extends Command {
  @override
  final name = 'create';

  @override
  final description = 'Creates the standard Fittor project structure';

  CreateCommand() {
    addSubcommand(AppCommand());
  }

  @override
  void run() {
    print('Please specify a subcommand: app');
    print('Usage: fittor create app');
  }
}

class AppCommand extends Command {
  @override
  final name = 'app';

  @override
  final description = 'Creates a new Fittor application';

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

  // I want to Delete Test Folder

  final testDir = Directory(path.join(baseDir.path, 'test'));
  if (testDir.existsSync()) {
    testDir.deleteSync(recursive: true);
  }

  final fittorDir = Directory(path.join(baseDir.path, 'lib'));
  // Create FitBindings

  _createFile(fittorDir, 'fit_bindings.dart', _bindingTemplate());

  // Create core folder structure
  _createDirectory(fittorDir, 'core/network');
  _createFile(fittorDir, 'core/network/api_client.dart', _apiClientTemplate());
  _createFile(fittorDir, 'core/network/fit_urls.dart', _apiUrlTemplate());

  _createDirectory(fittorDir, 'core/util');
  _createFile(fittorDir, 'core/util/fit_colors.dart', _fitColorsTemplate());
  _createFile(fittorDir, 'core/util/storage.dart', _fitStorageTemplate());

  _createDirectory(fittorDir, 'core/routes');
  _createFile(fittorDir, 'core/routes/app_routes.dart', _appRoutesTemplate());

  // Create data folder structure
  _createDirectory(fittorDir, 'data/model');
  _createFile(fittorDir, 'data/model/fit_model.dart', _sampleModelTemplate());

  _createDirectory(fittorDir, 'data/repo');
  _createFile(
    fittorDir,
    'data/repo/fitter_sample_repo.dart',
    _sampleRepositoryTemplate(),
  );

  _createDirectory(fittorDir, 'data/source');
  _createFile(
    fittorDir,
    'data/source/fitter_sample_source.dart',
    _sampleDataSourceTemplate(),
  );

  // Create presentation folder structure
  _createDirectory(fittorDir, 'presentation/screen');
  _createFile(
    fittorDir,
    'presentation/screen/fitter_view.dart',
    _sampleScreenTemplate(),
  );
  _createFile(
    fittorDir,
    'presentation/screen/sample_router.dart',
    _sampleRouterView(),
  );

  _createDirectory(fittorDir, 'presentation/controller');
  _createFile(
    fittorDir,
    'presentation/controller/sample_controller.dart',
    _sampleControllerTemplate(),
  );

  _createDirectory(fittorDir, 'presentation/widget');

  _printTitle('\n🎉 Fittor project structure created successfully!\n');
  _printHint('Connect me on Email: mail.musthak@gmail.com');
  _printHint('Connect me on LinkedIn: https://www.linkedin.com/in/musthak/');
  _printHint('Connect me on Instagram: https://www.instagram.com/musth4k/');
  _printHint('Connect me on GitHub: https://github.com/mushthakvp \n\n');
}

String _sampleRouterView() {
  return sampleRouterTemplate;
}

void _createDirectory(Directory baseDir, String relativePath) {
  final directory = Directory(path.join(baseDir.path, relativePath));
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
}

void _createFile(Directory baseDir, String relativePath, String content) {
  final file = File(path.join(baseDir.path, relativePath));
  if (!file.existsSync()) {
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  } else {
    _printHint('To overwrite, delete the file and run the command again.');
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
