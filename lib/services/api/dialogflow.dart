import 'package:flutter_dialogflow/dialogflow_v2.dart';

class DialogFlowAPI {
  Future<String> response(String query) async {
    try {
      final authGoogle =
          await AuthGoogle(fileJson: "private/credentials.json").build();
      final dialogflow =
          Dialogflow(authGoogle: authGoogle, language: Language.english);
      final response = await dialogflow.detectIntent(query);
      return response.getMessage();
    } on Exception catch (_) {
      return null;
    }
  }
}
