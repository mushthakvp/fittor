import 'package:args/command_runner.dart';
import 'package:fittor/fittor.dart';

class RenameCommand extends Command {
  @override
  final name = 'change';

  @override
  final description = 'Changes app name or package name';

  RenameCommand() {
    addSubcommand(PackageCommand());
    addSubcommand(NameCommand());
  }

  @override
  void run() {
    print('Please specify what to change: package or name');
    print('Usage: fittor change package <package_name>');
    print('       fittor change name <app_name>');
  }
}

class PackageCommand extends Command {
  @override
  final name = 'package';

  @override
  final description = 'Changes the package name';

  @override
  void run() {
    if (argResults?.rest.isEmpty ?? true) {
      _printError('Package name is required');
      print('Usage: fittor change package <package_name>');
      print('Example: fittor change package com.example.myapp');
      return;
    }

    final newPackageName = argResults!.rest.first;

    if (!_isValidPackageName(newPackageName)) {
      _printError('Invalid package name format');
      print('Package name should follow format: com.example.appname');
      return;
    }

    final changer = PackageNameChanger();
    changer.changePackageName(newPackageName);
  }

  bool _isValidPackageName(String packageName) {
    final regex = RegExp(r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)*$');
    return regex.hasMatch(packageName);
  }

  void _printError(String message) => print('\x1B[31m$message\x1B[0m');
}

class NameCommand extends Command {
  @override
  final name = 'name';

  @override
  final description = 'Changes the app name';

  @override
  void run() {
    if (argResults?.rest.isEmpty ?? true) {
      _printError('App name is required');
      print('Usage: fittor change name <app_name>');
      print('Example: fittor change name "My Awesome App"');
      return;
    }

    final newAppName = argResults!.rest.join(' ');
    final changer = AppNameChanger();
    changer.changeAppName(newAppName);
  }

  void _printError(String message) => print('\x1B[31m$message\x1B[0m');
}
