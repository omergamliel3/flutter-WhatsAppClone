import 'package:stacked/stacked.dart';

import '../../../services/locator.dart';
import '../../../core/routes/navigation_service%20.dart';
import '../../../repositories/contacts_repo/contacts_repository.dart';

import '../../../core/models/contact_entity.dart';

// class SelectContactViewModel extends ReactiveViewModel {
//   final _contactsRepo = locator<ContactsRepository>();
//   List<ContactEntity> get unActiveContacts => _contactsRepo.unActiveContacts;
//   @override
//   List<ReactiveServiceMixin> get reactiveServices => [_contactsRepo];
// }

class SelectContactViewModel extends BaseViewModel {
  // get services, repos
  final _contactsRepo = locator<ContactsRepository>();
  final _navigator = locator<NavigationService>();

  // activate contact via contacts repository
  void activateContact(ContactEntity contactEntity) async {
    await _contactsRepo.activateContact(contactEntity);
    _navigator.pop();
  }

  // un-active contacts getter
  List<ContactEntity> get unActiveContacts => _contactsRepo.unActiveContacts;
}
