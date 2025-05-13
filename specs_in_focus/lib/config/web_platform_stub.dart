/// This class serves as a stub implementation of the Platform class for web platforms
/// since dart:io is not available in web contexts
class Platform {
  /// Always returns false on web
  static bool get isAndroid => false;

  /// Always returns false on web
  static bool get isIOS => false;

  /// Always returns false on web
  static bool get isMacOS => false;

  /// Always returns false on web
  static bool get isWindows => false;

  /// Always returns false on web
  static bool get isLinux => false;

  /// Always returns false on web
  static bool get isFuchsia => false;

  /// Returns 'web' on web platforms
  static String get operatingSystem => 'web';
}
