import '../core/models/message.dart';

import '../core/models/contact_entity.dart';

abstract class IContactsRepository {
  Future<void> initalise();
  List<ContactEntity> get activeContacts;
  List<ContactEntity> get unActiveContacts;
  Future<bool> setActiveContacts();
  Future<bool> setUnActiveContacts();
  Future<bool> activateContact(ContactEntity contactEntity);
  Future<List<Message>> getMessages(ContactEntity contactEntity);
  Future<bool> insertMessage(Message message);
}
