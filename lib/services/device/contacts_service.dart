import 'package:WhatsAppClone/core/models/chat.dart';
import 'package:WhatsAppClone/services/local_storage/db_service.dart';
import 'package:contacts_service/contacts_service.dart';

abstract class ContactsHandler {
  /// init contacts handler service
  static Future getUnActiveContacts() async {
    Iterable<Contact> contacts =
        await ContactsService.getContacts(orderByGivenName: false);
    List<Contact> contactsData = contacts.toList();
    // get active chats data from local db
    List<Chat> activeChats = await DBservice.getChats();
    if (activeChats == null || activeChats.isEmpty) {
      return null;
    }
    // extract active chats data names
    List<String> names = activeChats.map((e) => e.name).toList();
    // remove active chats from contacts data
    contactsData.removeWhere((contact) => names.contains(contact.displayName));
    return contactsData;
  }
}
