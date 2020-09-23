import '../../core/models/contact_entity.dart';

abstract class IContactsRepository {
  Future<void> initalise();
  List<ContactEntity> get activeContacts;
  List<ContactEntity> get unActiveContacts;
  Future<void> setActiveContacts();
  Future<void> setUnActiveContacts();
  Future<void> activateContact(ContactEntity contactEntity);
}
