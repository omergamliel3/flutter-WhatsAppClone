import 'package:stacked/stacked.dart';

import '../../../services/locator.dart';
import '../../../services/api/dialogflow.dart';
import '../../../services/local_storage/db_service.dart';
import '../../../repositories/contacts_repo/contacts_repository.dart';

import '../../../core/models/message.dart';
import '../../../core/models/contact_entity.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

class PrivateChatViewModel extends BaseViewModel {
  // get services
  final dbService = locator<DBservice>();
  final dialogflowAPI = locator<DialogFlowAPI>();
  final contactsRepo = locator<ContactsRepository>();

  // launch call via url launcher
  void launchCall(String number) {
    url_launcher.launch('tel:$number');
  }

  // set active contacts via contacts repository
  Future<void> setActiveContacts() async {
    await contactsRepo.setActiveContacts();
  }

  // get chat messages data according to contact entity via local db service
  Future<List<Message>> getMessages(ContactEntity contactEntity) {
    return dbService.getMessages(contactEntity);
  }

  // insert new message to local db service
  Future<bool> insertMessage(Message message) {
    return dbService.insertMessage(message);
  }

  // get message response via dialog flow api
  Future<String> msgResponse(String query) async {
    return await dialogflowAPI.response(query);
  }
}
