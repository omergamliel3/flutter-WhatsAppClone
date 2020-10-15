import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../../data/repositories/contacts_repository.dart';

import '../../locator.dart';
import '../../services/firebase/analytics_service.dart';

import '../../core/routes/router.dart';
import '../../core/models/contact_entity.dart';
import '../../core/models/message.dart';
import '../../core/routes/routing_constants.dart';

import '../index.dart';

class SelectContactViewModel extends BaseViewModel {
  // get services, repos
  final _contactsRepo = locator<ContactsRepository>();
  final _router = locator<Router>();
  final _analytics = locator<AnalyticsService>();
  final _dialogService = locator<DialogService>();
  final _navigator = locator<NavigationService>();

  // activate contact via contacts repository
  Future<void> activateContact(ContactEntity contactEntity) async {
    final activate = await _contactsRepo.activateContact(contactEntity);
    if (activate) {
      _analytics.logCreateNewContactEvent();
      _router.pop();
    } else {
      _dialogService.showDialog(
          title: 'Something went wrong',
          description: 'failed to create new chat, please try again.');
    }
  }

  // launch device phone call
  void launchCall(String number) {
    url_launcher.launch('tel:$number');
  }

  void sendImage(String imagePath, ContactEntity contactEntity) async {
    print('sendImage: $imagePath');
    // active contact entity if un-active
    if (_contactsRepo.unActiveContacts.contains(contactEntity)) {
      await activateContact(contactEntity);
    }
    // construct new message with type image
    final message = Message(
        foreignID: contactEntity.id,
        fromUser: true,
        messageType: MessageType.image,
        text: imagePath,
        timestamp: DateTime.now());
    // insert message
    var result = await _contactsRepo.insertMessage(message);
    if (result) {
      _contactsRepo.setActiveContacts();
      _navigator.clearTillFirstAndShow(privateChatRoute,
          arguments: contactEntity.toJsonMap());
    } else {
      _dialogService.showDialog(
          title: 'Failed to send image', description: 'Please try again');
    }
  }

  List<ContactEntity> getViewContacts(ContactMode mode) {
    if (mode == ContactMode.chat) {
      return _contactsRepo.unActiveContacts;
    }
    return _contactsRepo.activeContacts + _contactsRepo.unActiveContacts;
  }
}
