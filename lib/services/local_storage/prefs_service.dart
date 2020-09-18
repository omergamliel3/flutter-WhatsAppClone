import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  // static variables
  final _kAuthKeyName = 'authenticate';
  final _kUserNameKey = 'username';
  final _kUserStatusNameKey = 'user_status';
  SharedPreferences _sharedPreferences;

  /// init shared preferences instance
  Future<void> initPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    //_sharedPreferences.clear();
  }

  /// save authentication state in prefs
  void saveAuthentication({bool auth = false}) {
    _sharedPreferences.setBool(_kAuthKeyName, auth);
  }

  /// is authenticate getter
  bool get isAuthenticated =>
      _sharedPreferences.getBool(_kAuthKeyName) ?? false;

  /// save username in prefs
  void saveUserName({String username}) {
    if (username == null || username.isEmpty) return;
    _sharedPreferences.setString(_kUserNameKey, username.trim());
  }

  /// return [true/false] if [name argument] is the current username (validation)
  bool allowDelete(String name) {
    return name.trim().toLowerCase() == userName.trim().toLowerCase();
  }

  /// username getter
  String get userName => _sharedPreferences.getString(_kUserNameKey);

  /// save user status in prefs
  void saveUserStatus({String status}) {
    if (status == null || status.isEmpty) return;
    _sharedPreferences.setString(_kUserStatusNameKey, status.trim());
  }

  /// user status getter
  String get userStatus => _sharedPreferences.getString(_kUserStatusNameKey);
}
