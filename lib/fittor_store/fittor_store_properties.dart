import 'fittor_store.dart';

/// A class that provides property-based access to FittorStore
/// This allows you to use FittorStore like:
/// FittorStoreProperties.id = "123"; // Setter
/// print(FittorStoreProperties.id); // Getter
class FittorStoreProperties {
  // User ID
  static String get id => FittorStore.getString("id") ?? '';
  static set id(String value) => FittorStore.setString("id", value);

  // User name
  static String get name => FittorStore.getString("name") ?? '';
  static set name(String value) => FittorStore.setString("name", value);

  // User email
  static String get email => FittorStore.getString("email") ?? '';
  static set email(String value) => FittorStore.setString("email", value);

  // Auth token
  static String get token => FittorStore.getString("token") ?? '';
  static set token(String value) => FittorStore.setString("token", value);

  // Is user logged in
  static bool get isLoggedIn => FittorStore.getBool("isLoggedIn") ?? false;
  static set isLoggedIn(bool value) => FittorStore.setBool("isLoggedIn", value);

  // Last login time
  static DateTime? get lastLogin => FittorStore.getDateTime("lastLogin");
  static set lastLogin(DateTime? value) {
    if (value != null) {
      FittorStore.setDateTime("lastLogin", value);
    } else {
      FittorStore.remove("lastLogin");
    }
  }

  // User settings
  static Map<String, dynamic>? get settings => FittorStore.getJson("settings");
  static set settings(Map<String, dynamic>? value) {
    if (value != null) {
      FittorStore.setJson("settings", value);
    } else {
      FittorStore.remove("settings");
    }
  }

  // Theme mode (0 = system, 1 = light, 2 = dark)
  static int get themeMode => FittorStore.getInt("themeMode") ?? 0;
  static set themeMode(int value) => FittorStore.setInt("themeMode", value);

  // App language
  static String get language => FittorStore.getString("language") ?? 'en';
  static set language(String value) => FittorStore.setString("language", value);

  // First run flag
  static bool get isFirstRun => FittorStore.getBool("isFirstRun") ?? true;
  static set isFirstRun(bool value) => FittorStore.setBool("isFirstRun", value);

  // Clear all user data (for logout)
  static Future<void> clearUserData() async {
    await FittorStore.remove("id");
    await FittorStore.remove("name");
    await FittorStore.remove("email");
    await FittorStore.remove("token");
    await FittorStore.setBool("isLoggedIn", false);
    await FittorStore.remove("lastLogin");
    await FittorStore.remove("settings");
  }
}
