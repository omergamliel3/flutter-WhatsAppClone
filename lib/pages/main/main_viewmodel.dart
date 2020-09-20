import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import '../../core/shared/constants.dart';

import '../../core/widgets/ui_elements/status_modal_bottom_sheet.dart';

import '../../helpers/navigator_helper.dart';

class MainViewModel extends BaseViewModel {
  void handlePressedFAB(BuildContext context, int index) {
    if (index == 1) {
      // navigate contact screen on CHAT MODE
      Routes.navigateContactScreen(context, ContactMode.chat);
    } else if (index == 2) {
      // show status modal bottom sheet
      showStatusModalBottomSheet(context);
    } else {
      // navigate contact screen on CALLS MODE
      Routes.navigateContactScreen(context, ContactMode.calls);
    }
  }
}
