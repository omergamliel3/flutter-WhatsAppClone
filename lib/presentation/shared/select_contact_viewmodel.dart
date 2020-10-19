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

  // the corrent contact mode
  ContactMode mode;

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

  Future sendImage(String imagePath, ContactEntity contactEntity) async {
    ContactEntity contact = contactEntity;
    // active contact entity if un-active
    if (_contactsRepo.unActiveContacts.contains(contactEntity)) {
      await activateContact(contactEntity);
      contact = _contactsRepo.activeContacts.last;
    }
    // construct new message with type image
    final message = Message(
        foreignID: contact.id,
        fromUser: true,
        messageType: MessageType.image,
        text: imagePath,
        timestamp: DateTime.now());
    // insert message
    final result = await _contactsRepo.insertMessage(message);
    if (result) {
      _contactsRepo.setActiveContacts();

      _navigator.clearTillFirstAndShow(privateChatRoute,
          arguments: contact.toJsonMap());
    } else {
      _dialogService.showDialog(
          title: 'Failed to send image', description: 'Please try again');
    }
  }

  // returns a list of contacts according to the [mode]
  List<ContactEntity> getViewContacts() {
    if (mode == ContactMode.chat) {
      // nly unactive contacts
      return _contactsRepo.unActiveContacts;
    }
    // all contacts
    return _contactsRepo.activeContacts.reversed.toList() +
        _contactsRepo.unActiveContacts;
  }

  // navigate to search view
  void navigateSearch(String imagePath) {
    _navigator.navigateToView(SearchView(
      mode: mode,
      contacts: getViewContacts(),
      imagePath: imagePath,
    ));
  }

  // launch device phone call
  void launchCall(String number) {
    url_launcher.launch('tel:$number');
  }

  void searchAction({String number, ContactEntity contact, String imagePath}) {
    if (mode == ContactMode.calls) {
      launchCall(number);
    } else if (mode == ContactMode.chat) {
      activateContact(contact);
    } else if (mode == ContactMode.setImage) {
      sendImage(imagePath, contact);
    }
  }
}
