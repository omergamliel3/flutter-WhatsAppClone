import 'package:WhatsAppClone/core/models/contact_entity.dart';
import 'package:WhatsAppClone/core/routes/routing_constants.dart';
import 'package:WhatsAppClone/presentation/index.dart';
import 'package:WhatsAppClone/presentation/shared/select_contact_viewmodel.dart';
import 'package:WhatsAppClone/services/index.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../data/repositories/test_data.dart';
import '../../test_helper.dart';

void main() {
  // construct mocked services
  Router router;
  ContactsRepository contactsRepo;
  AnalyticsService analytics;
  DialogService dialogService;
  NavigationService navigator;

  // dummy contact entity data
  ContactEntity entity;
  setUp(() {
    router = getAndRegisterRouterServiceMock();
    contactsRepo = getAndRegisterContactsRepositoryMock();
    analytics = getAndRegisterAnalyticsServiceMock();
    dialogService = getAndRegisterDialogServiceMock();
    navigator = getAndRegisterNavigationServiceMock();
    entity = ContactEntity(
        displayName: 'omer',
        phoneNumber: '00000',
        id: 0,
        lastMsg: '',
        lastMsgTime: DateTime.now());
  });
  group('SelectContactViewModel Test - ', () {
    /// [activateContact method test (activate success)]
    test('activate contact with success', () async {
      // mock activate contact to return true (success)
      when(contactsRepo.activateContact(contactEntity))
          .thenAnswer((realInvocation) => Future.value(true));

      // construct model
      final model = SelectContactViewModel();
      await model.activateContact(contactEntity);
      verifyInOrder([
        contactsRepo.activateContact(contactEntity),
        analytics.logCreateNewContactEvent(),
        router.pop()
      ]);
    });

    /// [activateContact method test (activate failed)]
    test('activate contact with failure', () async {
      // mock activate contact to return false (exception)
      when(contactsRepo.activateContact(entity))
          .thenAnswer((realInvocation) => Future.value(false));

      // construct model
      final model = SelectContactViewModel();
      await model.activateContact(entity);
      verify(contactsRepo.activateContact(entity));
      verify(dialogService.showDialog(
          title: 'Something went wrong',
          description: 'failed to create new chat, please try again.'));
      verifyNever(router.pop());
      verifyNever(analytics.logCreateNewContactEvent());
    });

    /// [getViewContacts method test]
    test(
        '''when call getViewContacts should return List of type ContactEntity according to the Contacts mode argument''',
        () {
      // construct tested viewmodel
      final model = SelectContactViewModel();
      // mock repo
      when(contactsRepo.activeContacts)
          .thenAnswer((realInvocation) => [contactEntity]);
      when(contactsRepo.unActiveContacts)
          .thenAnswer((realInvocation) => localDatabaseContactsEntites);
      // evoke tested method
      List<ContactEntity> contacts = model.getViewContacts(ContactMode.chat);
      expect(contacts, equals(localDatabaseContactsEntites));

      contacts = model.getViewContacts(ContactMode.calls);
      expect(contacts, equals([contactEntity] + localDatabaseContactsEntites));

      contacts = model.getViewContacts(ContactMode.setImage);
      expect(contacts, equals([contactEntity] + localDatabaseContactsEntites));
    });

    /// [sendImage method test (contact is active and success inserted)]
    test('''
         when call sendImage(), should evoke activateContact() if contactEntity argument is not active, then construct new Mesasge instance and evoke insertMessage(). If inserted, evoke setActiveContacts, and navigate to privateChatRoute. Else, show failed Dialog''',
        () async {
      // construct tested model
      final model = SelectContactViewModel();
      // mock unActiveContacts from contacts repo
      when(contactsRepo.unActiveContacts)
          .thenAnswer((realInvocation) => localDatabaseContactsEntites);
      when(contactsRepo.insertMessage(any)).thenAnswer((realInvocation) =>
          Future.value(true)); // evoke and await tested method
      await model.sendImage('path', contactEntity);
      verifyNever(contactsRepo.activateContact(contactEntity));
      verifyInOrder([
        contactsRepo.setActiveContacts(),
        navigator.clearTillFirstAndShow(privateChatRoute,
            arguments: contactEntity.toJsonMap())
      ]);
    });

    /// [sendImage method test (contact is un active and inserted failure)]
    test('''
         when call sendImage(), should evoke activateContact() if contactEntity argument is not active, then construct new Mesasge instance and evoke insertMessage(). If inserted, evoke setActiveContacts, and navigate to privateChatRoute. Else, show failed Dialog''',
        () async {
      // construct tested model
      final model = SelectContactViewModel();
      // mock unActiveContacts from contacts repo
      when(contactsRepo.unActiveContacts)
          .thenAnswer((realInvocation) => [contactEntity]);
      when(contactsRepo.activateContact(contactEntity))
          .thenAnswer((realInvocation) => Future.value(true));
      when(contactsRepo.insertMessage(any)).thenAnswer((realInvocation) =>
          Future.value(false)); // evoke and await tested method
      await model.sendImage('path', contactEntity);
      verifyInOrder([
        contactsRepo.activateContact(contactEntity),
        dialogService.showDialog(
            title: 'Failed to send image', description: 'Please try again')
      ]);
    });
  });
}
