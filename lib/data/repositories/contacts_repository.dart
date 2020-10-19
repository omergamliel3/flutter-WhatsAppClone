import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';

import '../datasources/local_database.dart';
import '../../services/device/contacts_service.dart';

import '../../core/models/contact_entity.dart';
import '../../core/models/message.dart';

class ContactsRepository with ReactiveServiceMixin {
  // constructor
  ContactsRepository(
      {@required this.localDatabase, @required this.contactHandler});
  // data classes
  final LocalDatabase localDatabase;
  final ContactsHandler contactHandler;

  // holds un active contacts
  List<ContactEntity> _unActiveContacts;
  // holds active contacts (chats)
  final RxValue<List<ContactEntity>> _activeContacts =
      RxValue<List<ContactEntity>>();

  Future<void> initalise() async {
    listenToReactiveValues([_activeContacts]);
    await localDatabase.initDb();
    await setActiveContacts();
    await setUnActiveContacts();
  }

  Future<bool> setActiveContacts() async {
    try {
      _activeContacts.value = await localDatabase.getContactEntites();
      return true;
    } on Exception catch (_) {
      return Future.value(false);
    }
  }

  Future<bool> setUnActiveContacts() async {
    try {
      _unActiveContacts =
          await contactHandler.getUnActiveContacts(_activeContacts.value);
      return true;
    } on Exception catch (_) {
      return Future.value(false);
    }
  }

  Future<bool> activateContact(ContactEntity contactEntity) async {
    try {
      // create new contact in local db
      final inserted = await localDatabase.insertContactEntity(contactEntity);
      if (inserted) {
        // get active contacts from local db
        final success = await setActiveContacts();
        if (success) {
          // remove newly added contact from unActiveContacts
          _unActiveContacts.removeWhere((contact) =>
              contact.displayName?.toLowerCase() ==
              contactEntity.displayName.toLowerCase());
          return true;
        }
      }
      return false;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<List<Message>> getMessages(ContactEntity contactEntity) async {
    return localDatabase.getMessages(contactEntity);
  }

  Future<bool> insertMessage(Message message) async {
    return localDatabase.insertMessage(message);
  }

  List<ContactEntity> get activeContacts => _activeContacts.value;

  List<ContactEntity> get unActiveContacts => _unActiveContacts;
}
