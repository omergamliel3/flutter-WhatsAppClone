import 'package:flutter_dialogflow/dialogflow_v2.dart';

class DialogFlowAPI {
  Future<String> response(String query) async {
    try {
      var authGoogle =
          await AuthGoogle(fileJson: "private/credentials.json").build();
      var dialogflow =
          Dialogflow(authGoogle: authGoogle, language: Language.english);
      var response = await dialogflow.detectIntent(query);
      return response.getMessage();
    } on Exception catch (_) {
      return null;
    }
  }
}
