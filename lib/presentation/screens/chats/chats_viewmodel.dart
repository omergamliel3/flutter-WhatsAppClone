import 'package:stacked/stacked.dart';

import '../../../services/locator.dart';
import '../../../repositories/contacts_repo/contacts_repository.dart';

import '../../../core/models/contact_entity.dart';
import '../../../core/routes/router.dart';

class ChatsViewModel extends ReactiveViewModel {
  // get services
  final _router = locator<Router>();
  final _contactRepo = locator<ContactsRepository>();

  // navigate private chat view via navigator service
  void navigatePrivateChatView(ContactEntity contactEntity) {
    _router.navigatePrivateChatSceen(contactEntity);
  }

  List<ContactEntity> get activeContacts => _contactRepo.activeContacts;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_contactRepo];
}
