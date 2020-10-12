import 'package:WhatsAppClone/presentation/private_chats/private_chat_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../data/repositories/test_data.dart';
import '../../test_helper.dart';

void main() {
  ContactsRepositoryMock contactsRepo;
  DialogFlowAPIMock dialogFlow;
  AnalyticsServiceMock analytics;
  setUp(() {
    contactsRepo = getAndRegisterContactsRepositoryMock();
    dialogFlow = getAndRegisterDialogFlowAPIMock();
    analytics = getAndRegisterAnalyticsServiceMock();
  });
  group('private chats viewmodel tests -', () {
    test('''when call setActiveContacts should pass to contact repository''',
        () async {
      var model = PrivateChatViewModel();
      await model.setActiveContacts();
      verify(contactsRepo.setActiveContacts());
    });

    test('when call getMessages should pass to contacts repository', () async {
      var model = PrivateChatViewModel();
      when(contactsRepo.getMessages(contactEntity))
          .thenAnswer((realInvocation) => Future.value([message]));
      var resultMsgs = await model.getMessages(contactEntity);
      expect(resultMsgs, equals([message]));
      verify(contactsRepo.getMessages(contactEntity));
    });

    test(
        '''when call insertMessage should pass to contacts repository. If inserted should evoke logMsgEvent, setActiveContacts and return true, else should return false''',
        () async {
      var model = PrivateChatViewModel();
      when(contactsRepo.insertMessage(message))
          .thenAnswer((realInvocation) => Future.value(true));
      var result = await model.insertMessage(message);
      expect(result, equals(true));
      verifyInOrder([
        contactsRepo.insertMessage(message),
        analytics.logMsgEvent(message.text.length),
        contactsRepo.setActiveContacts()
      ]);
    });

    test(
        '''when call insertMessage should pass to contacts repository. If inserted should evoke logMsgEvent, setActiveContacts and return true, else should return false''',
        () async {
      var model = PrivateChatViewModel();
      when(contactsRepo.insertMessage(message))
          .thenAnswer((realInvocation) => Future.value(false));
      var result = await model.insertMessage(message);
      expect(result, equals(false));
      verify(contactsRepo.insertMessage(message));
      verifyNoMoreInteractions(contactsRepo);
      verifyNever(analytics.logMsgEvent(message.text.length));
    });

    test('when call msgResponse should pass to dialogFlow', () async {
      var model = PrivateChatViewModel();
      var query = 'hello';
      var response = 'how are you?';
      when(dialogFlow.response(query))
          .thenAnswer((realInvocation) => Future.value(response));
      var result = await model.msgResponse(query);
      expect(result, equals(response));
      verify(dialogFlow.response(query));
    });
  });
}
