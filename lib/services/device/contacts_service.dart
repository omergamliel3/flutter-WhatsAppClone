import 'package:contacts_service/contacts_service.dart';

abstract class ContactsHandler {
  // holds contacts data
  static List<Contact> _contactsData;

  /// init contacts handler service
  static Future<void> initContactsHandler() async {
    Iterable<Contact> contacts =
        await ContactsService.getContacts(orderByGivenName: false);
    _contactsData = contacts.toList();
  }

  // contactsData getter
  static List<Contact> get contactsData => List.from(_contactsData);
}
