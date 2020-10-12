import 'package:WhatsAppClone/core/models/contact_entity.dart';
import 'package:WhatsAppClone/presentation/shared/select_contact_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../test_helper.dart';

void main() {
  // construct mocked services
  RouterServiceMock router;
  ContactsRepositoryMock contactsRepo;
  AnalyticsServiceMock analytics;
  DialogServiceMock dialogService;
  // dummy contact entity data
  ContactEntity entity;
  setUp(() {
    router = getAndRegisterRouterServiceMock();
    contactsRepo = getAndRegisterContactsRepositoryMock();
    analytics = getAndRegisterAnalyticsServiceMock();
    dialogService = getAndRegisterDialogServiceMock();
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
      when(contactsRepo.activateContact(entity))
          .thenAnswer((realInvocation) => Future.value(true));

      // construct model
      var model = SelectContactViewModel();
      await model.activateContact(entity);
      verifyInOrder([
        contactsRepo.activateContact(entity),
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
      var model = SelectContactViewModel();
      await model.activateContact(entity);
      verify(contactsRepo.activateContact(entity));
      verify(dialogService.showDialog(
          title: 'Something went wrong',
          description: 'failed to create new chat, please try again.'));
      verifyNever(router.pop());
      verifyNever(analytics.logCreateNewContactEvent());
    });
  });
}
