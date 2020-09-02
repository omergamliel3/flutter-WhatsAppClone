import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:WhatsAppClone/core/models/status.dart';

import 'package:WhatsAppClone/services/local_storage/prefs_service.dart';

import 'package:WhatsAppClone/helpers/connectivity_helper.dart';

abstract class FirestoreService {
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
          .collection('users_status')
          .add(status.toJsonMap());
      // save user status localy
      PrefsService.saveUserStatus(status: status.content);
      print('created new firestore recored with id: ${docRef.id}');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
