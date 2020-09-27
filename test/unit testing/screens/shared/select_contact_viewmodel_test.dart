import 'package:WhatsAppClone/core/models/contact_entity.dart';
import 'package:WhatsAppClone/core/routes/navigation_service%20.dart';
import 'package:WhatsAppClone/repositories/contacts_repo/contacts_repository.dart';
import 'package:WhatsAppClone/services/local_storage/local_database.dart';
import 'package:WhatsAppClone/services/locator.dart';
import 'package:WhatsAppClone/views/screens/shared/select_contact_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class ContactsRepositoryMock extends Mock implements ContactsRepository {}

class NavigationServiceMock extends Mock implements NavigationService {}

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  group('SelectContactViewModel Test - ', () {
    // construct mocked services
    final navigator = NavigationServiceMock();
    final contactsRepo = ContactsRepositoryMock();
    // register mocked services via locator
    locator.registerSingleton<NavigationService>(navigator);
    locator.registerSingleton<ContactsRepository>(contactsRepo);
    // dummy contact entity data
    var entity = ContactEntity(
        displayName: 'omer',
        phoneNumber: '00000',
        id: 0,
        lastMsg: '',
        lastMsgTime: DateTime.now());

    /// [activateContact method test (activate success)]
    test('activate contact with success', () async {
      // mock activate contact to return true (success)
      when(contactsRepo.activateContact(entity))
          .thenAnswer((realInvocation) => Future.value(true));

      // construct model
      var model = SelectContactViewModel();
      await model.activateContact(entity);
      verify(contactsRepo.activateContact(entity));
      verify(navigator.pop());
    });

    /// [activateContact method test (activate failed)]
    test('activate contact with failure', () async {
      // mock activate contact to return false (exception)
      when(contactsRepo.activateContact(entity))
          .thenAnswer((realInvocation) => Future.value(false));

      // construct model
      var model = SelectContactViewModel();
      await model.activateContact(entity);
      verify(contactsRepo.activateContact(entity));
      verifyNever(navigator.pop());
    });
  });
}
