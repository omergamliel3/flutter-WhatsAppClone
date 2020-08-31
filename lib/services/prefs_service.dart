import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefsService {
  static final _kAuthKeyName = 'authenticate';
  static final _kUserNameKey = 'username';
  static SharedPreferences _sharedPreferences;

  /// init shared preferences instance
  static Future<void> initPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    //_sharedPreferences.clear();
  }

  /// save authentication state in prefs
  static void saveAuthentication({bool auth = false}) {
    _sharedPreferences.setBool(_kAuthKeyName, auth);
  }

  /// is authenticate getter
  static bool get isAuthenticated =>
      _sharedPreferences.getBool(_kAuthKeyName) ?? false;

  /// save username in prefs
  static void saveUserName({String username}) {
    if (username == null || username.isEmpty) return;
    _sharedPreferences.setString(_kUserNameKey, username.trim());
  }

  /// username getter
  static String get userName => _sharedPreferences.getString(_kUserNameKey);
}
