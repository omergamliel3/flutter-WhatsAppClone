import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';

import 'contacts_repository_interface.dart';

import '../../services/device/contacts_service.dart';
import '../../services/local_storage/local_database.dart';
import '../../services/locator.dart';
import '../../core/models/contact_entity.dart';

class ContactsRepository
    with ReactiveServiceMixin
    implements IContactsRepository {
  // services
  final contactHandler = locator<ContactsHandler>();
  final dbService = locator<LocalDatabase>();
  // contacts data
  List<ContactEntity> _unActiveContacts;
  // active chats data
  final RxValue<List<ContactEntity>> _activeContacts =
      RxValue<List<ContactEntity>>();

  @override
  Future<void> initalise() async {
    listenToReactiveValues([_activeContacts]);
    await setActiveContacts();
    await setUnActiveContacts();
  }

  @override
  Future<bool> setActiveContacts() async {
    try {
      _activeContacts.value = await dbService.getContactEntites();
      return true;
    } on Exception catch (_) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> setUnActiveContacts() async {
    try {
      _unActiveContacts =
          await contactHandler.getUnActiveContacts(_activeContacts.value);
      return true;
    } on Exception catch (_) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> activateContact(ContactEntity contactEntity) async {
    try {
      // create new contact in local db
      var inserted = await dbService.insertContactEntity(contactEntity);
      if (inserted) {
        // get active contacts from local db
        var success = await setActiveContacts();
        if (success) {
          // remove newly added contact from unActiveContacts
          _unActiveContacts
            ..removeWhere((contact) =>
                contact.displayName.toLowerCase() ==
                contactEntity.displayName.toLowerCase());
          return true;
        }
      }
      return false;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  List<ContactEntity> get activeContacts => _activeContacts.value;

  @override
  List<ContactEntity> get unActiveContacts => _unActiveContacts;
}
