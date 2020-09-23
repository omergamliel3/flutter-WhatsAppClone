import 'package:stacked/stacked.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../../../services/locator.dart';
import '../../../repositories/contacts_repo/contacts_repository.dart';

import '../../../core/routes/navigation_service%20.dart';
import '../../../core/models/contact_entity.dart';

class SelectContactViewModel extends BaseViewModel {
  // get services, repos
  final _contactsRepo = locator<ContactsRepository>();
  final _navigator = locator<NavigationService>();

  // activate contact via contacts repository
  void activateContact(ContactEntity contactEntity) async {
    await _contactsRepo.activateContact(contactEntity);
    _navigator.pop();
  }

  // launch device phone call
  void launchCall(String number) {
    url_launcher.launch('tel:$number');
  }

  // un-active contacts getter
  List<ContactEntity> get unActiveContacts => _contactsRepo.unActiveContacts;
}
