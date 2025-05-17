import 'package:flutter/material.dart';

import 'fittor_store.dart';

/// A mixin that provides easy access to FittorStore in StatefulWidget classes
mixin FittorStoreMixin<T extends StatefulWidget> on State<T> {
  /// Get a value from the store
  T? getValue(String key, {T? defaultValue}) {
    return FittorStore.getValue<T>(key, defaultValue: defaultValue);
  }

  /// Set a value in the store
  Future<bool> setValue(String key, T value) {
    return FittorStore.setValue<T>(key, value);
  }

  /// Get a string from the store
  String? getString(String key) {
    return FittorStore.getString(key);
  }

  /// Set a string in the store
  Future<bool> setString(String key, String value) {
    return FittorStore.setString(key, value);
  }

  /// Get a boolean from the store
  bool? getBool(String key) {
    return FittorStore.getBool(key);
  }

  /// Set a boolean in the store
  Future<bool> setBool(String key, bool value) {
    return FittorStore.setBool(key, value);
  }

  /// Get an integer from the store
  int? getInt(String key) {
    return FittorStore.getInt(key);
  }

  /// Set an integer in the store
  Future<bool> setInt(String key, int value) {
    return FittorStore.setInt(key, value);
  }

  /// Get a double from the store
  double? getDouble(String key) {
    return FittorStore.getDouble(key);
  }

  /// Set a double in the store
  Future<bool> setDouble(String key, double value) {
    return FittorStore.setDouble(key, value);
  }

  /// Get a string list from the store
  List<String>? getStringList(String key) {
    return FittorStore.getStringList(key);
  }

  /// Set a string list in the store
  Future<bool> setStringList(String key, List<String> value) {
    return FittorStore.setStringList(key, value);
  }

  /// Get a DateTime from the store
  DateTime? getDateTime(String key) {
    return FittorStore.getDateTime(key);
  }

  /// Set a DateTime in the store
  Future<bool> setDateTime(String key, DateTime value) {
    return FittorStore.setDateTime(key, value);
  }

  /// Get a JSON object from the store
  Map<String, dynamic>? getJson(String key) {
    return FittorStore.getJson(key);
  }

  /// Set a JSON object in the store
  Future<bool> setJson(String key, Map<String, dynamic> value) {
    return FittorStore.setJson(key, value);
  }

  /// Remove a value from the store
  Future<bool> remove(String key) {
    return FittorStore.remove(key);
  }
}
