import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefsService {
  static final _kAuthKeyName = 'authenticate';
  static SharedPreferences _sharedPreferences;

  /// init shared preferences instance
  static Future<void> initPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// save authentication state in prefs
  static void saveAuthentication({bool auth = false}) {
    _sharedPreferences.setBool(_kAuthKeyName, auth);
  }

  /// returns whatever the user is autheticated
  static bool isAuthenticated() {
    bool authenticated = _sharedPreferences.getBool(_kAuthKeyName);
    if (authenticated == null) {
      return false;
    }
    return authenticated;
  }
}
