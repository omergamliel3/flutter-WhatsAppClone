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

  Future<void> activeContact(ContactEntity contactEntity) async {
    // create new contact in local db
    await DBservice.insertContactEntity(contactEntity);
    // get active contacts from local db
    _activeChats = await DBservice.getContactEntites();
    // remove newly added contact from unActiveContacts
    _unActiveContacts.removeWhere((contact) =>
        contact.displayName.toLowerCase() ==
        contactEntity.displayName.toLowerCase());
    // notify model change
    notifyListeners();
  }

  Future<void> fetchUnActiveContacts() async {
    _unActiveContacts = await ContactsHandler.getUnActiveContacts();
  }

  // active chats data
  List<ContactEntity> _activeChats = [];
  List<ContactEntity> get activeChats => List.from(_activeChats);

  /// get active chats from local db
  Future<void> getActiveChats() async {
    _activeChats = await DBservice.getContactEntites();
    notifyListeners();
  }

  // user data
  String _userStatus;
  String get userStatus => _userStatus;

  void updateUserStatus(String status) {
    _userStatus = status;
    notifyListeners();
  }

  // theme data
  bool _isLight;
  bool get isLight => _isLight;

  /// init model data
  Future<void> initModel(BuildContext context) async {
    // get unactive chats
    _unActiveContacts = await ContactsHandler.getUnActiveContacts();
    // set active chats from local db storage
    _activeChats = await DBservice.getContactEntites();
    if (PrefsService.userName != null) {
      // set user status from prefs local storage
      _userStatus = await FirestoreService.getUserStatus(PrefsService.userName);
    }
    // set isLight attribute
    _isLight = Theme.of(context).brightness == Brightness.light;
  }
}
