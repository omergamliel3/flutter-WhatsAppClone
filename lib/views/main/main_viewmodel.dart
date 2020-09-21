import 'package:stacked/stacked.dart';

import '../../services/locator.dart';

import '../../core/shared/constants.dart';

import '../../core/routes/navigation_service .dart';

class MainViewModel extends BaseViewModel {
  final navigator = locator<NavigationService>();
  void handlePressedFAB(int index, Function showStatusModal) {
    if (index == 1) {
      // navigate contact screen on CHAT MODE
      navigator.navigateContactScreen(ContactMode.chat);
    } else if (index == 2) {
      showStatusModal();
    } else {
      // navigate contact screen on CALLS MODE
      navigator.navigateContactScreen(ContactMode.calls);
    }
  }
}
