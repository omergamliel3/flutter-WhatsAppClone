import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/status.dart';
import '../../../core/provider/main.dart';
import '../../../services/firebase/firestore_service.dart';
import '../../../services/local_storage/prefs_service.dart';
import '../../../services/locator.dart';

class StatusViewModel extends BaseViewModel {
  // services
  final _prefsService = locator<PrefsService>();
  final _firestoreService = locator<FirestoreService>();
  // status stream
  Stream<QuerySnapshot> _statusStream;
  Stream<QuerySnapshot> get statusStream => _statusStream;

  // username
  String _username;
  String get username => _username;

  /// call once after the model is construct
  void initalise() {
    _username = _prefsService.userName;
    // set status stream to firestore snapshots
    _statusStream = FirebaseFirestore.instance
        .collection('users_status')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// evoke status delete methods
  Future<void> handleDeleteStatus(Status status, BuildContext context) async {
    // get username from prefs service
    var username = _prefsService.userName;
    // delete status from firestore service
    var deleted = await _firestoreService.deleteStatus(status);
    // stops method if failed to delete status
    if (!deleted) return;
    // get user last status
    var updatedStatus = await _firestoreService.getUserStatus(username);
    // update user last status in main model
    context.read<MainModel>().updateUserStatus(updatedStatus);
  }

  // whatever the user allow to delete status
  bool allowDelete(String username) {
    var allowed = _prefsService.allowDelete(username);
    return allowed;
  }
}
