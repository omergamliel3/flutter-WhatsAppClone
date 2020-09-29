import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';
import '../../services/auth/auth_service.dart';
import '../cloud_storage/cloud_database.dart';
import '../locator.dart';
import '../../core/models/status.dart';

class UserService with ReactiveServiceMixin {
  // static variables

  final _kUserNameKey = 'username';
  final auth = locator<AuthService>();
  final database = locator<CloudDatabase>();

  // storage ref
  SharedPreferences _sharedPreferences;
  final RxValue<String> _userStatus = RxValue<String>(initial: null);

  /// initialise service
  Future<void> initUserService() async {
    // create prefs instance
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.clear();
    // only set user status if authenticated
    if (auth.isAuthenticated) {
      await getUserStatus();
    }
    // set reactive values
    listenToReactiveValues([_userStatus]);
  }

  /// save username in prefs
  void saveUserName(String username) {
    if (username == null || username.isEmpty) return;
    _sharedPreferences.setString(_kUserNameKey, username.trim());
  }

  /// get the most recent user status, if there is one
  /// return null if there is no status
  Future<void> getUserStatus() async {
    _userStatus.value = await database.getUserStatus(userName);
  }

  /// add new user status to firestore db collection
  Future<bool> uploadStatus(Status status) async {
    var success = await database.uploadStatus(status);
    if (success) {
      _userStatus.value = status.content;
      return true;
    }
    return false;
  }

  /// delete status from firestore db users_status collection
  Future<bool> deleteStatus(Status status) async {
    return await database.deleteStatus(status);
  }

  /// return [true/false] if [name argument] is the current username (validation)
  bool allowDelete(String name) {
    return name.trim().toLowerCase() == userName.trim().toLowerCase();
  }

  /// status stream getter
  Stream<QuerySnapshot> get statusStream => database.statusStream();

  /// user status getter
  String get userStatus => _userStatus.value;

  /// username getter
  String get userName => _sharedPreferences.getString(_kUserNameKey);
}
