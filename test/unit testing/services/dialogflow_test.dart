import 'package:WhatsAppClone/services/api/dialogflow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DialogFlowAPIMock extends Mock implements DialogFlowAPI {}

void main() {
  group('dialogflow api tests - ', () {
    test('when call response should return a text message', () async {
      var dialogflow = DialogFlowAPIMock();
      var query = 'hello!';
      var msg = 'Hi, how are you?';
      when(dialogflow.response(query))
          .thenAnswer((realInvocation) => Future.value(msg));
      var response = await dialogflow.response(query);
      expect(response, msg);
    });

    test(
        'when call reponse should raise exception and return null text message',
        () async {
      var dialogflow = DialogFlowAPIMock();
      var query = 'hello!';
      when(dialogflow.response(query))
          .thenAnswer((realInvocation) => Future.value(null));
      var response = await dialogflow.response(query);
      expect(response, null);
    });
  });
}
