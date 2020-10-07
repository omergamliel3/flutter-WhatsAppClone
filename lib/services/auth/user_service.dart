import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';
import '../../services/auth/auth_service.dart';
import '../../data/cloud_storage/cloud_database.dart';
import '../locator.dart';
import '../../core/models/status.dart';
import 'package:meta/meta.dart';

class UserService with ReactiveServiceMixin {
  UserService({@required this.cloudDatabase, @required this.sharedPreferences});

  final _kUserNameKey = 'username';
  final auth = locator<AuthService>();
  final CloudDatabase cloudDatabase;

  // storage ref
  final SharedPreferences sharedPreferences;
  final RxValue<String> _userStatus = RxValue<String>(initial: null);

  /// initialise service
  Future<void> initUserService() async {
    // only set user status if authenticated
    if (auth.isAuthenticated) {
      await getUserStatus();
    }
    // set reactive values
    listenToReactiveValues([_userStatus]);
  }

  /// save username in prefs
  Future<bool> saveUserName(String username) async {
    if (username == null || username.isEmpty) return false;
    return await sharedPreferences.setString(_kUserNameKey, username.trim());
  }

  /// get the most recent user status, if there is one
  /// return null if there is no status
  Future<void> getUserStatus() async {
    _userStatus.value = await cloudDatabase.getUserStatus(userName);
  }

  /// add new user status to firestore db collection
  Future<bool> uploadStatus(Status status) async {
    var success = await cloudDatabase.uploadStatus(status);
    if (success) {
      _userStatus.value = status.content;
      return true;
    }
    return false;
  }

  /// delete status from firestore db users_status collection
  Future<bool> deleteStatus(Status status) async {
    return await cloudDatabase.deleteStatus(status);
  }

  /// returns profile picture download url
  Future<String> getProfilePicURL() async {
    return await cloudDatabase.getProfilePicURL(userName);
  }

  /// return [true/false] if [name argument] is the current username (validation)
  bool allowDelete(String name) {
    return name.trim().toLowerCase() == userName.trim().toLowerCase();
  }

  /// status stream getter
  Stream<QuerySnapshot> get statusStream => cloudDatabase.statusStream();

  /// user status getter
  String get userStatus => _userStatus.value;

  /// username getter
  String get userName => sharedPreferences.getString(_kUserNameKey);
}
