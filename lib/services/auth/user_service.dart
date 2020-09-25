import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';

import '../../core/models/status.dart';

class UserService with ReactiveServiceMixin {
  // static variables

  final _kUserNameKey = 'username';
  final _kUsersStatusCollection = 'users_status';

  // storage ref
  SharedPreferences _sharedPreferences;
  final RxValue<String> _userStatus = RxValue<String>(initial: '');

  /// initialise service
  Future<void> initUserService() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _userStatus.value = await getUserStatus();
    listenToReactiveValues([_userStatus]);
  }

  /// save username in prefs
  void saveUserName(String username) {
    if (username == null || username.isEmpty) return;
    _sharedPreferences.setString(_kUserNameKey, username.trim());
  }

  /// get the most recent user status, if there is one
  /// return null if there is no status
  Future<String> getUserStatus() async {
    try {
      // get all user status, order by timestamp (descending)
      var querySnapshot = await FirebaseFirestore.instance
          .collection(_kUsersStatusCollection)
          .orderBy('timestamp', descending: true)
          .get();
      // if snapshot is empty return null
      if (querySnapshot.docs.isEmpty) {
        _userStatus.value = null;
        return null;
      }
      // iterate docs from query
      for (var doc in querySnapshot.docs) {
        // only compare doc with the same username as user
        if (doc.data()['username'].toLowerCase() == userName.toLowerCase()) {
          // set user status to reactive value
          _userStatus.value = querySnapshot.docs.first.data()['status'];
          return querySnapshot.docs.first.data()['status'] as String;
        }
      }
      // did not find any user status, return null
      _userStatus.value = null;
      return null;
    }
    // return null if error has occurred
    on Exception catch (e) {
      print(e);
      _userStatus.value = null;
      return null;
    }
  }

  /// add new user status to firestore db collection
  Future<bool> uploadStatus(Status status) async {
    try {
      // add new status object to users_status db collection
      var docRef = await FirebaseFirestore.instance
          .collection(_kUsersStatusCollection)
          .add(status.toJsonMap());

      print('created new firestore recored with id: ${docRef.id}');
      // update reactive user status value
      _userStatus.value = status.content;
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// delete status from firestore db users_status collection
  Future<bool> deleteStatus(Status status) async {
    try {
      await FirebaseFirestore.instance
          .collection(_kUsersStatusCollection)
          .doc(status.id)
          .delete();
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// return [true/false] if [name argument] is the current username (validation)
  bool allowDelete(String name) {
    return name.trim().toLowerCase() == userName.trim().toLowerCase();
  }

  /// status stream getter
  Stream<QuerySnapshot> get statusStream => FirebaseFirestore.instance
      .collection('users_status')
      .orderBy('timestamp', descending: true)
      .snapshots();

  /// user status getter
  String get userStatus => _userStatus.value;

  /// username getter
  String get userName => _sharedPreferences.getString(_kUserNameKey);
}
