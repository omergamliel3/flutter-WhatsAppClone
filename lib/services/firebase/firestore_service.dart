import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/models/status.dart';

class FirestoreService {
  final _kUsersStatusCollection = 'users_status';
  final _kUserNamesCollection = 'user_names';

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
  Future<String> getUserStatus(String username) async {
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
        if (doc.data()['username'].toLowerCase() == username.toLowerCase()) {
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
  Future<bool> addUserName(String username) async {
    try {
      // add new username object to user_names db collection
      var docRef = await FirebaseFirestore.instance
          .collection(_kUserNamesCollection)
          .add({'username': username});

      print('created new firestore recored with id: ${docRef.id}');
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  /// compare username argument with user_names collection
  /// returns true if do not exists in collection, false if exists
  Future<bool> validateUserName(String username) async {
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
        if (name.toLowerCase() == username.toLowerCase()) {
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
