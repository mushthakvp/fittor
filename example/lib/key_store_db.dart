import 'package:fittor/fittor.dart';

class Store {
  static const String _dbName = 'store.db';
  static const String _tableName = 'store';

  static String get dbName => FittorStore.getString(_dbName) ?? "";
  static set dbName(String value) => FittorStore.setString(_dbName, value);

  static String get tableName => FittorStore.getString(_tableName) ?? "";
  static set tableName(String value) =>
      FittorStore.setString(_tableName, value);
}
