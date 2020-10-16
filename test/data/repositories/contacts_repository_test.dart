import 'package:WhatsAppClone/data/datasources/local_database.dart';
import 'package:WhatsAppClone/data/repositories/contacts_repository.dart';
import 'package:WhatsAppClone/services/device/contacts_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'test_data.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

class ContactsHandlerMock extends Mock implements ContactsHandler {}

void main() {
  LocalDatabaseMock localDatabase;
  ContactsHandlerMock contactsHandler;
  ContactsRepository repository;
  setUp(() {
    // construct mocked data sources
    localDatabase = LocalDatabaseMock();
    contactsHandler = ContactsHandlerMock();
    // mock returned data from data sources
    when(localDatabase.getContactEntites()).thenAnswer(
        (realInvocation) => Future.value(localDatabaseContactsEntites));
    when(contactsHandler.getUnActiveContacts(any))
        .thenAnswer((realInvocation) => Future.value(contactsHandlerEntites));
    // construct tested repository
    repository = ContactsRepository(
        localDatabase: localDatabase, contactHandler: contactsHandler);
  });
  group('contacts repository tests -', () {
    test(
        '''when call initalise should call asyncInitDB, set _activeContacts and _unActiveContacts (contacts entities data holders)''',
        () async {
      // evoke initialise tested method
      await repository.initalise();
      verify(localDatabase.initDb());
      final activeContacts = repository.activeContacts;
      final unActiveContacts = repository.unActiveContacts;
      expect(activeContacts, equals(localDatabaseContactsEntites));
      expect(unActiveContacts, equals(contactsHandlerEntites));
    });

    test(
        '''when call setActiveContacts should set _activeContacts value to localDatabase getContactEntites data. If throws exception should return false''',
        () async {
      await repository.setActiveContacts();
      verify(localDatabase.getContactEntites());
      expect(repository.activeContacts, equals(localDatabaseContactsEntites));

      when(localDatabase.getContactEntites()).thenThrow(Exception());
      final result = await repository.setActiveContacts();
      expect(result, equals(false));
    });

    test(
        '''when call setUnActiveContacts should set _unActiveContacts value to contactHandler getUnActiveContacts data. If throws exception should return false''',
        () async {
      await repository.setUnActiveContacts();
      verify(contactsHandler.getUnActiveContacts(any));
      expect(repository.unActiveContacts, equals(contactsHandlerEntites));

      when(contactsHandler.getUnActiveContacts(any)).thenThrow(Exception());
      final result = await repository.setUnActiveContacts();
      expect(result, equals(false));
    });

    test(
        '''when activateContact should insert contactEntity argument to localDatabase, call setActiveContacts, and remove contactEntity from _unActiveContacts. If catches any exceptions return false''',
        () async {
      when(localDatabase.insertContactEntity(contactEntity))
          .thenAnswer((realInvocation) => Future.value(true));
      // first initialise repo
      await repository.initalise();
      // add menualy contactEntity for test purpose
      repository.unActiveContacts.add(contactEntity);
      expect(repository.unActiveContacts.contains(contactEntity), equals(true));
      final activate = await repository.activateContact(contactEntity);
      expect(activate, equals(true));
      expect(
          repository.unActiveContacts.contains(contactEntity), equals(false));
      verifyInOrder([
        localDatabase.insertContactEntity(contactEntity),
        localDatabase.getContactEntites()
      ]);
    });

    test('when call getMessages should pass to localDatabase', () async {
      when(localDatabase.getMessages(contactEntity))
          .thenAnswer((realInvocation) => Future.value([message]));
      final messages = await repository.getMessages(contactEntity);
      expect(messages, equals([message]));
      verify(localDatabase.getMessages(contactEntity));
    });

    test('when call insertMessage should pass to localDatabase', () async {
      when(localDatabase.insertMessage(message))
          .thenAnswer((realInvocation) => Future.value(true));
      final inserted = await repository.insertMessage(message);
      expect(inserted, equals(true));
      verify(localDatabase.insertMessage(message));
    });
  });
}
