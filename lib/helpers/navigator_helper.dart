import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/shared/constants.dart';

abstract class NavigatorHelper {
  /// navigate main page
  static void navigateMainPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/main_page');
  }

  /// navigate login page
  static void navigateLoginPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login_page');
  }

  /// navigate contact screen
  static void navigateContactScreen(
      BuildContext context, ContactMode contactMode) {
    Navigator.pushNamed(context, '/contact_screen',
        arguments: {'mode': contactMode});
  }
}
