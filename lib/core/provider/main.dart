import 'package:flutter/material.dart';

import 'package:WhatsAppClone/services/firebase/firestore_service.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:WhatsAppClone/services/device/contacts_service.dart';

import 'package:WhatsAppClone/core/models/chat.dart';

import 'package:WhatsAppClone/services/local_storage/db_service.dart';
import 'package:WhatsAppClone/services/local_storage/prefs_service.dart';

class MainModel extends ChangeNotifier {
  // contacts data
  List<Contact> _unActiveContacts;
  List<Contact> get unActiveContacts => List.from(_unActiveContacts);

  void activeContact(String name) {
    _unActiveContacts.removeWhere(
        (contact) => contact.displayName.toLowerCase() == name.toLowerCase());
  }

  // active chats data
  List<Chat> _activeChats = [];
  List<Chat> get activeChats => List.from(_activeChats);

  /// get active chats from local db
  Future<void> getActiveChats() async {
    _activeChats = await DBservice.getChats();
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
    _activeChats = await DBservice.getChats();
    if (PrefsService.userName != null) {
      // set user status from prefs local storage
      _userStatus = await FirestoreService.getUserStatus(PrefsService.userName);
    }
    // set isLight attribute
    _isLight = Theme.of(context).brightness == Brightness.light;
  }
}
