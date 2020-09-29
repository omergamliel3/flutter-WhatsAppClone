import 'package:stacked/stacked.dart';

import '../../services/locator.dart';

import '../../core/shared/constants.dart';

import '../../core/routes/router.dart';

class MainViewModel extends BaseViewModel {
  final router = locator<Router>();
  void handlePressedFAB(int index, Function showStatusModal) {
    if (index == 1) {
      // navigate contact screen on CHAT MODE
      router.navigateContactScreen(ContactMode.chat);
    } else if (index == 2) {
      showStatusModal();
    } else {
      // navigate contact screen on CALLS MODE
      router.navigateContactScreen(ContactMode.calls);
    }
  }
}
