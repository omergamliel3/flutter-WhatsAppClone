import 'package:WhatsAppClone/core/models/message.dart';
import 'package:WhatsAppClone/core/routes/routing_constants.dart';
import 'package:WhatsAppClone/presentation/shared/mode.dart';
import 'package:stacked/stacked.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:rxdart/rxdart.dart';

import '../../locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:WhatsAppClone/services/index.dart';

import 'package:WhatsAppClone/core/models/contact_entity.dart';

class SearchViewModel extends BaseViewModel {
  // get services, repos
  final _contactsRepo = locator<ContactsRepository>();
  final _analytics = locator<AnalyticsService>();
  final _dialogService = locator<DialogService>();
  final _navigator = locator<NavigationService>();

  // Holds the contacts entites data
  List<ContactEntity> contacts;

  // Suggestions stream controller
  final _suggestionsStream = BehaviorSubject<List<ContactEntity>>.seeded([]);
  // Expose the stream to view
  Stream<List<ContactEntity>> get suggestions => _suggestionsStream.stream;

  // Search suggestions from [contacts] with a given value
  void searchSuggestions(String value) {
    // Ff value is null or empty just add an empty event to the steam
    if (value == null || value.isEmpty) {
      _suggestionsStream.add(null);
      return;
    }
    // Trim and convert to lowercase to compare strings safely
    final validVal = value.toLowerCase().trim();
    final newSuggestions = <ContactEntity>[];
    // Iterate contacts list to find suggestions
    for (final contact in contacts) {
      // Trim and convert to lowecase to compare string safely
      final name = contact.displayName.toLowerCase().trim();
      // Condition
      if (name.startsWith(validVal)) {
        newSuggestions.add(contact);
      }
    }
    // After done iterating all contacts, add new suggestions event to the stream
    _suggestionsStream.add(newSuggestions);
  }

  // handle dynamic actions
  void performAction(
      {ContactMode mode, ContactEntity contactEntity, String imagePath}) {
    if (mode == ContactMode.calls) {
      launchCall(contactEntity.phoneNumber);
    } else if (mode == ContactMode.chat) {
      activateContact(contactEntity);
    } else if (mode == ContactMode.setImage) {
      sendImage(imagePath, contactEntity);
    }
  }

  // activate contact via contacts repository
  Future<void> activateContact(ContactEntity contactEntity) async {
    if (contactEntity == null) return;
    final activate = await _contactsRepo.activateContact(contactEntity);
    if (activate) {
      _analytics.logCreateNewContactEvent();
      _navigator.popRepeated(2);
    } else {
      _dialogService.showDialog(
          title: 'Something went wrong',
          description: 'failed to create new chat, please try again.');
    }
  }

  // handle send image to contact
  Future sendImage(String imagePath, ContactEntity contactEntity) async {
    if (contactEntity == null || imagePath == null) return;
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

  // launch device phone call
  Future<void> launchCall(String number) async {
    if (number == null) return;
    url_launcher.launch('tel:$number');
  }
}
