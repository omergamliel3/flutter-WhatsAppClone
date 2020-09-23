import 'package:stacked/stacked.dart';

import '../../../services/locator.dart';
import '../../../repositories/contacts_repo/contacts_repository.dart';

import '../../../core/models/contact_entity.dart';
import '../../../core/routes/navigation_service%20.dart';

class ChatsViewModel extends ReactiveViewModel {
  // get services
  final _navigator = locator<NavigationService>();
  final _contactRepo = locator<ContactsRepository>();

  // navigate private chat view via navigator service
  void navigatePrivateChatView(ContactEntity contactEntity) {
    _navigator.navigatePrivateChatSceen(contactEntity);
  }

  List<ContactEntity> get activeContacts => _contactRepo.activeContacts;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_contactRepo];
}
