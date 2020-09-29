import 'package:stacked/stacked.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../../../services/locator.dart';
import '../../../services/firebase/analytics_service.dart';
import '../../../repositories/contacts_repo/contacts_repository.dart';

import '../../../core/routes/router.dart';
import '../../../core/models/contact_entity.dart';

class SelectContactViewModel extends BaseViewModel {
  // get services, repos
  final _contactsRepo = locator<ContactsRepository>();
  final _router = locator<Router>();
  final _analytics = locator<AnalyticsService>();

  // activate contact via contacts repository
  Future<void> activateContact(ContactEntity contactEntity) async {
    final activate = await _contactsRepo.activateContact(contactEntity);
    if (activate) {
      _analytics.logCreateNewContactEvent();
      _router.pop();
    } else {
      // TODO: SHOW FALIED TO CREATE CONTACT DIALOG
    }
  }

  // launch device phone call
  void launchCall(String number) {
    url_launcher.launch('tel:$number');
  }

  // un-active contacts getter
  List<ContactEntity> get unActiveContacts => _contactsRepo.unActiveContacts;
}
