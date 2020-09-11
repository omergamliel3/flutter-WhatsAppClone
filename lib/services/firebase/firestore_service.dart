import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:WhatsAppClone/core/models/status.dart';

import 'package:WhatsAppClone/helpers/connectivity_helper.dart';

class FirestoreService {
  FirestoreService._();
  static const _kUsersStatusCollection = 'users_status';
  static const _kUserNamesCollection = 'user_names';

  /// add new user status to firestore db collection
  static Future<bool> uploadStatus(Status status) async {
    // checks for internet connectivity
    bool connectivity = await ConnectivityHelper.internetConnectivity();
    // return false if there is no connectivity
    if (!connectivity) {
      return false;
    }
    try {
      // add new status object to users_status db collection
      var docRef = await FirebaseFirestore.instance
          .collection(_kUsersStatusCollection)
          .add(status.toJsonMap());

      print('created new firestore recored with id: ${docRef.id}');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// delete status from firestore db [users_status] collection
  static Future<bool> deleteStatus(Status status) async {
    // checks for internet connectivity
    bool connectivity = await ConnectivityHelper.internetConnectivity();
    // return false if there is no connectivity
    if (!connectivity) {
      return false;
    }
    try {
      await FirebaseFirestore.instance
          .collection(_kUsersStatusCollection)
          .doc(status.id)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// get the most recent user status, if there is one
  /// return null if there is no status
  static Future<String> getUserStatus(String username) async {
    // checks for internet connectivity
    bool connectivity = await ConnectivityHelper.internetConnectivity();
    // return null if there is no connectivity
    if (!connectivity) {
      return null;
    }
    try {
      // get all user status, order by timestamp (descending)
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
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
    catch (e) {
      print(e);
      return null;
    }
  }

  /// add new username to firestore db [user_names] collection
  static Future<bool> addUserName(String username) async {
    // checks for internet connectivity
    bool connectivity = await ConnectivityHelper.internetConnectivity();
    // return false if there is no connectivity
    if (!connectivity) {
      return false;
    }
    try {
      // add new username object to user_names db collection
      var docRef = await FirebaseFirestore.instance
          .collection(_kUserNamesCollection)
          .add({'username': username});

      print('created new firestore recored with id: ${docRef.id}');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// compare [username] argument with [user_names] collection
  /// returns [true] if do not exists in collection, [false] if exists
  static Future<bool> validateUserName(String username) async {
    // checks for internet connectivity
    bool connectivity = await ConnectivityHelper.internetConnectivity();
    // return false if there is no connectivity
    if (!connectivity) {
      return false;
    }
    try {
      // get query db collection
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection(_kUserNamesCollection)
          .get();
      // get query docs
      List<QueryDocumentSnapshot> usernames = query.docs;
      // username flag
      bool flag = false;
      // iterate usernames query docs list
      usernames.forEach((element) {
        String elementName = element.data()['username'];
        if (elementName.toLowerCase() == username.toLowerCase()) {
          flag = true;
          return;
        }
      });
      // username is taken, not valid.
      if (flag) {
        return false;
      }
      // username is not taken, valid.
      return true;
    }
    // return false if catch error
    catch (e) {
      print(e);
      return false;
    }
  }
}
