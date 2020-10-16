import 'package:WhatsAppClone/core/models/contact_entity.dart';
import 'package:WhatsAppClone/services/device/contacts_service.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ContactsServiceMock extends Mock implements ContactsService {}

void main() {
  final deviceContacts = <String>[
    'omer',
    'tal',
    'ohad',
    'yarden',
    'ofek',
    'asaf'
  ];
  final activeContacts = <String>['omer', 'tal'];
  final unactiveContactsLength = deviceContacts.length - activeContacts.length;
  final mockDeviceContacts =
      deviceContacts.map((e) => Contact(displayName: e)).toList();
  final mockActiveContacts = activeContacts
      .map((e) => ContactEntity(displayName: e, phoneNumber: '000-000-000'))
      .toList();
  group('Contacts service tests - ', () {
    test(
        '''when evoke getUnActiveContacts should return a list of type ContactEntity with all unactive contacts''',
        () async {
      final contactsService = ContactsServiceMock();
      when(contactsService.getContacts(orderByGivenName: false))
          .thenAnswer((realInvocation) => Future.value(mockDeviceContacts));
      final contactsHandler = ContactsHandler(contactsService);
      final unActiveContacts =
          await contactsHandler.getUnActiveContacts(mockActiveContacts);
      expect(unActiveContacts.length, unactiveContactsLength);
      for (final item in unActiveContacts) {
        print('${item.displayName} -> ${item.phoneNumber}');
      }
    });
  });
}
