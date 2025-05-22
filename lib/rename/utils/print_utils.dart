class PrintUtils {
  static void printTitle(String message) => print('\n\x1B[1m$message\x1B[0m');
  static void printError(String message) => print('\x1B[31m$message\x1B[0m');
  static void printHint(String message) => print('\x1B[33m$message\x1B[0m');
  static void printSuccess(String message) => print('\x1B[32m$message\x1B[0m');
  static void printInfo(String message) => print('\x1B[34m$message\x1B[0m');
  static void printWarning(String message) => print('\x1B[35m$message\x1B[0m');
}
