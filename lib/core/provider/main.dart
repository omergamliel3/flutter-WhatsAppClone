import 'package:flutter/material.dart';

import '../../services/locator.dart';

import '../../services/device/contacts_service.dart';
import '../../services/firebase/firestore_service.dart';
import '../../services/local_storage/db_service.dart';
import '../../services/local_storage/prefs_service.dart';

import '../models/contact_entity.dart';

class MainModel extends ChangeNotifier {
  // services
  final prefsService = locator<PrefsService>();
  final dbService = locator<DBservice>();
  final firestoreService = locator<FirestoreService>();
  final contactHandler = locator<ContactsHandler>();

  // contacts data
  List<ContactEntity> _unActiveContacts;
  List<ContactEntity> get unActiveContacts => List.from(_unActiveContacts);

  // active chats data
  List<ContactEntity> _activeContacts = [];
  List<ContactEntity> get activeContacts => List.from(_activeContacts);

  /// get active contacts entities from local db
  Future<void> getActiveContacts() async {
    _activeContacts = await dbService.getContactEntites();
    notifyListeners();
  }

  // activate contact entity
  Future<void> activeContact(ContactEntity contactEntity) async {
    // create new contact in local db
    await dbService.insertContactEntity(contactEntity);
    // get active contacts from local db
    _activeContacts = await dbService.getContactEntites();
    // remove newly added contact from unActiveContacts
    _unActiveContacts.removeWhere((contact) =>
        contact.displayName.toLowerCase() ==
        contactEntity.displayName.toLowerCase());
    // notify model change
    notifyListeners();
  }

  // user data
  String _userStatus;
  String get userStatus => _userStatus;

  // update user status
  void updateUserStatus(String status) {
    _userStatus = status;
    notifyListeners();
  }

  /// init model data
  Future<void> initModel() async {
    // get active contacts entities
    _activeContacts = await dbService.getContactEntites();
    // get unactive contacts entities
    _unActiveContacts =
        await contactHandler.getUnActiveContacts(_activeContacts);
    if (prefsService.userName != null) {
      // set user status from prefs local storage
      _userStatus = await firestoreService.getUserStatus(prefsService.userName);
    }
  }
}
