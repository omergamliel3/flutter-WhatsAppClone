import 'package:WhatsAppClone/core/routes/router.dart';
import 'package:WhatsAppClone/presentation/chats/chats_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../data/repositories/test_data.dart';
import '../../test_helper.dart';

void main() {
  ContactsRepositoryMock repository;
  Router router;
  setUp(() {
    repository = getAndRegisterContactsRepositoryMock();
    router = getAndRegisterRouterServiceMock();
  });
  group('camera viewmodel tests -', () {
    test('when get activeContacts should pass to ContactsRepository', () {
      when(repository.activeContacts)
          .thenAnswer((realInvocation) => localDatabaseContactsEntites);
      var model = ChatsViewModel();
      var activeContacts = model.activeContacts;
      expect(activeContacts, equals(localDatabaseContactsEntites));
      verify(repository.activeContacts);

      var reactiveService = model.reactiveServices;
      expect(reactiveService, equals([repository]));
    });
    test('when call navigatePrivateChatView should pass to router', () {
      var model = ChatsViewModel();
      model.navigatePrivateChatView(contactEntity);
      verify(router.navigatePrivateChatSceen(contactEntity));
    });
  });
}
