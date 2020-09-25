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
  Future<void> setActiveContacts() async {
    _activeContacts.value = await dbService.getContactEntites();
  }

  @override
  Future<void> setUnActiveContacts() async {
    _unActiveContacts =
        await contactHandler.getUnActiveContacts(_activeContacts.value);
  }

  @override
  Future<void> activateContact(ContactEntity contactEntity) async {
    // create new contact in local db
    await dbService.insertContactEntity(contactEntity);
    // get active contacts from local db
    await setActiveContacts();
    // remove newly added contact from unActiveContacts
    _unActiveContacts
      ..removeWhere((contact) =>
          contact.displayName.toLowerCase() ==
          contactEntity.displayName.toLowerCase());
  }

  @override
  List<ContactEntity> get activeContacts => _activeContacts.value;

  @override
  List<ContactEntity> get unActiveContacts => _unActiveContacts;
}
