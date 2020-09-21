import 'package:stacked/stacked.dart';

import '../../../core/models/contact_entity.dart';
import '../../../core/routes/navigation_service%20.dart';
import '../../../services/locator.dart';

class ChatsViewModel extends BaseViewModel {
  // get services
  final navigator = locator<NavigationService>();

  // navigate private chat view via navigator service
  void navigatePrivateChatView(ContactEntity contactEntity) {
    navigator.navigatePrivateChatSceen(contactEntity);
  }
}
