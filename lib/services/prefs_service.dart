import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefsService {
  static SharedPreferences _sharedPreferences;

  /// init shared preferences instance
  static Future<void> initPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
  }

  /// save phone num in prefs
  static void savePhoneNum(String phoneNum) {
    if (phoneNum == null || phoneNum.isEmpty) return;
    _sharedPreferences.setString('PhoneNum', phoneNum);
  }

  static bool isPhoneNumSaved() {
    String phoneNum = _sharedPreferences.getString('PhoneNum');
    if (phoneNum == null || phoneNum.isEmpty) {
      return false;
    }
    return true;
  }
}
