import 'package:WhatsAppClone/core/models/contact_entity.dart';
import 'package:WhatsAppClone/services/device/contacts_service.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ContactsServiceMock extends Mock implements ContactsService {}

void main() {
  var deviceContacts = <String>[
    'omer',
    'tal',
    'ohad',
    'yarden',
    'ofek',
    'asaf'
  ];
  var activeContacts = <String>['omer', 'tal'];
  var unactiveContactsLength = deviceContacts.length - activeContacts.length;
  var mockDeviceContacts =
      deviceContacts.map((e) => Contact(displayName: e)).toList();
  var mockActiveContacts = activeContacts
      .map((e) => ContactEntity(displayName: e, phoneNumber: '000-000-000'))
      .toList();
  group('Contacts service tests - ', () {
    test(
        '''when evoke getUnActiveContacts should return a list of type ContactEntity with all unactive contacts''',
        () async {
      var contactsService = ContactsServiceMock();
      when(contactsService.getContacts(orderByGivenName: false))
          .thenAnswer((realInvocation) => Future.value(mockDeviceContacts));
      var contactsHandler = ContactsHandler(contactsService);
      var unActiveContacts =
          await contactsHandler.getUnActiveContacts(mockActiveContacts);
      expect(unActiveContacts.length, unactiveContactsLength);
      for (var item in unActiveContacts) {
        print('${item.displayName} -> ${item.phoneNumber}');
      }
    });
  });
}
