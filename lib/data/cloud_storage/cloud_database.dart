import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/models/status.dart';

class CloudDatabase {
  final _kUsersStatusCollection = 'users_status';
  final _kUserNamesCollection = 'user_names';

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
          // set user status to reactive value
          return querySnapshot.docs.first.data()['status'] as String;
        }
      }
      // did not find any user status, return null
      return null;
    }
    // return null if error has occurred
    on Exception catch (e) {
      print(e);
      return null;
    }
  }

  /// validate new username with user names collection via cloud db
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
    on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// add new username to firestore db user_names collection
  Future<bool> addUser(String username, PickedFile file) async {
    try {
      // save picked image file in firebase storage
      String url;
      var ref = FirebaseStorage.instance.ref();
      var storageSnap =
          await ref.child("image/img").putFile(File(file.path)).onComplete;
      if (storageSnap.error == null) {
        // get download url
        url = await storageSnap.ref.getDownloadURL() as String;
      }
      // add new username object to user_names db collection
      var docRef = await FirebaseFirestore.instance
          .collection(_kUserNamesCollection)
          .add({'username': username, 'profileUrl': url});

      print('created new firestore recored with id: ${docRef.id}');
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
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

  /// returns status stream
  Stream<QuerySnapshot> statusStream() {
    return FirebaseFirestore.instance
        .collection('users_status')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// returns profile picture download url
  Future<String> getProfilePicURL(String username) async {
    try {
      // get current user from firestore
      var querySnapshot = await FirebaseFirestore.instance
          .collection(_kUserNamesCollection)
          .where('username', isEqualTo: username)
          .get();
      // if snapshot is empty return null
      if (querySnapshot.docs.isEmpty) {
        return null;
      }
      // get profileUrl field from first query docs
      var downloadUrl = querySnapshot.docs.first.get('profileUrl') as String;
      return downloadUrl;
    } on Exception catch (_) {
      return null;
    }
  }
}
