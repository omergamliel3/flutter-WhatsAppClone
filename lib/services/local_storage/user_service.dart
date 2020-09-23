import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';

import '../../core/models/status.dart';

class UserService with ReactiveServiceMixin {
  // static variables
  final _kAuthKeyName = 'authenticate';
  final _kUserNameKey = 'username';
  final _kUserStatusNameKey = 'user_status';
  final _kUsersStatusCollection = 'users_status';
  final _kUserNamesCollection = 'user_names';
  // storage ref
  SharedPreferences _sharedPreferences;
  RxValue<String> _userStatus;

  /// init shared preferences instance
  Future<void> initPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _userStatus.value = await getUserStatus();
    listenToReactiveValues([_userStatus]);
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

  /// add new user status to firestore db collection
  Future<bool> uploadStatus(Status status) async {
    try {
      // add new status object to users_status db collection
      var docRef = await FirebaseFirestore.instance
          .collection(_kUsersStatusCollection)
          .add(status.toJsonMap());

      print('created new firestore recored with id: ${docRef.id}');
      return true;
    } on FirebaseException catch (e) {
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
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
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
        return null;
      }
      // iterate docs from query
      for (var doc in querySnapshot.docs) {
        // only compare doc with the same username as user
        if (doc.data()['username'].toLowerCase() == userName.toLowerCase()) {
          // return the first matched doc data
          return querySnapshot.docs.first.data()['status'] as String;
        }
      }
      // did not find any user status, return null
      return null;
    }
    // return null if error has occurred
    on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  /// add new username to firestore db user_names collection
  Future<bool> addUserName() async {
    try {
      // add new username object to user_names db collection
      var docRef = await FirebaseFirestore.instance
          .collection(_kUserNamesCollection)
          .add({'username': userName});

      print('created new firestore recored with id: ${docRef.id}');
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  /// compare username argument with user_names collection
  /// returns true if do not exists in collection, false if exists
  Future<bool> validateUserName() async {
    try {
      // get query db collection
      var query = await FirebaseFirestore.instance
          .collection(_kUserNamesCollection)
          .get();
      // get query docs
      var usernames = query.docs;
      // username flag
      var flag = false;
      // iterate usernames query docs list
      for (var user in usernames) {
        var name = user.data()['username'] as String;
        if (name.toLowerCase() == userName.toLowerCase()) {
          flag = true;
          break;
        }
      }

      // username is taken, not valid.
      if (flag) {
        return false;
      }
      // username is not taken, valid.
      return true;
    }
    // return false if catch error
    on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }
}
