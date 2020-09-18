import 'package:flutter_dialogflow/dialogflow_v2.dart';

class DialogFlowAPI {
  DialogFlowAPI._();

  static Future<String> response(String query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "private/credentials.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    String msgResponse =
        response.getMessage() ?? response.getListMessage()[0].title;
    return msgResponse;
  }
}
