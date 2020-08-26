import 'package:contacts_service/contacts_service.dart';

abstract class ContactsHandler {
  // holds contacts data
  static List<Contact> contactsData;
  static final int length = 3;

  /// init contacts handler service
  static Future<void> initContactsHandler() async {
    Iterable<Contact> contacts =
        await ContactsService.getContacts(orderByGivenName: false);
    contactsData = contacts.toList();
  }
}
