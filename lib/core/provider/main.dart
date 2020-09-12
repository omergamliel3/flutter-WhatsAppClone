import 'package:flutter/material.dart';

import 'package:WhatsAppClone/services/firebase/firestore_service.dart';

import 'package:WhatsAppClone/services/device/contacts_service.dart';

import 'package:WhatsAppClone/core/models/contact_entity.dart';

import 'package:WhatsAppClone/services/local_storage/db_service.dart';
import 'package:WhatsAppClone/services/local_storage/prefs_service.dart';

class MainModel extends ChangeNotifier {
  // contacts data
  List<ContactEntity> _unActiveContacts;
  List<ContactEntity> get unActiveContacts => List.from(_unActiveContacts);

  // active chats data
  List<ContactEntity> _activeContacts = [];
  List<ContactEntity> get activeContacts => List.from(_activeContacts);

  /// get active contacts entities from local db
  Future<void> getActiveContacts() async {
    _activeContacts = await DBservice.getContactEntites();
    notifyListeners();
  }

  // activate contact entity
  Future<void> activeContact(ContactEntity contactEntity) async {
    // create new contact in local db
    await DBservice.insertContactEntity(contactEntity);
    // get active contacts from local db
    _activeContacts = await DBservice.getContactEntites();
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

  // theme data
  bool _isLight;
  bool get isLight => _isLight;

  /// init model data
  Future<void> initModel(BuildContext context) async {
    // get active contacts entities
    _activeContacts = await DBservice.getContactEntites();
    // get unactive contacts entities
    _unActiveContacts =
        await ContactsHandler.getUnActiveContacts(_activeContacts);
    if (PrefsService.userName != null) {
      // set user status from prefs local storage
      _userStatus = await FirestoreService.getUserStatus(PrefsService.userName);
    }
    // set isLight attribute
    _isLight = Theme.of(context).brightness == Brightness.light;
  }
}
