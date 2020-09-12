import 'package:WhatsAppClone/core/models/contact_entity.dart';
import 'package:WhatsAppClone/services/local_storage/db_service.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsHandler {
  ContactsHandler._();

  /// FIRST, FETCH RAW [Contact] FROM CONTACTS SERVICE. CONVERT ITERABLE TO LIST OF [Contact]
  /// SECOND, FETCH [ContactEntity] FROM LOCAL SQLITE DB. (THOSE ENTITIES REPRESENTS ACTIVE CONTACTS)
  /// THIRD, IF THERE ARE ENTITES FROM DB, REMOVES THE MATCH [Contact] ELEMENTS FROM RAW [Contact] DATA
  /// FOURTH, RETURN [ContactEntity] LIST (CONSTRUCT FROM [Contact] RAW DATA) WHICH REPRESENTS UNACTIVE CONTACTS DATA.

  /// get un-active contacts
  static Future<List<ContactEntity>> getUnActiveContacts() async {
    // get raw contacts from contacts service plugin
    Iterable<Contact> contacts =
        await ContactsService.getContacts(orderByGivenName: false);
    List<Contact> contactsRawData = contacts.toList();
    // get active contact entities from local db
    List<ContactEntity> activeContacts = await DBservice.getContactEntites();
    // if there are entities
    if (activeContacts != null && activeContacts.isNotEmpty) {
      // extract entities displayName
      List<String> names = activeContacts.map((e) => e.displayName).toList();
      // remove active contacts from contacts raw data
      contactsRawData
          .removeWhere((contact) => names.contains(contact.displayName));
    }
    // return ContactEntity list which represents un active contacts data
    return contactsRawData
        .map((e) => ContactEntity(
            displayName: e.displayName, phoneNumber: e.phones.first.value))
        .toList();
  }
}
