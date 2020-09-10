import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/models/chat.dart';

import 'package:WhatsAppClone/core/shared/constants.dart';

import 'package:WhatsAppClone/pages/main/main_page.dart';
import 'package:WhatsAppClone/pages/screens/shared/select_contact_screen.dart';
import 'package:WhatsAppClone/pages/screens/chats/private_chat_page.dart';

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

  /// navigate private chat screen
  static void navigatePrivateChatSceen(BuildContext context, Chat chat) {
    Navigator.pushNamed(context, '/private_chat_screen',
        arguments: chat.toJsonMap());
  }

  // handle named routes
  static Route<dynamic> onGenerateRoute(
      RouteSettings settings, BuildContext context) {
    Map<String, dynamic> arguments = settings.arguments;
    if (settings.name == '/contact_screen') {
      return MaterialPageRoute(builder: (context) {
        return SelectContactScreen(arguments['mode']);
      });
    } else if (settings.name.split('/')[1] == 'private_chat_screen') {
      return MaterialPageRoute(builder: (context) {
        return PrivateChatPage(Chat.fromJsonMap(arguments));
      });
    }
    return MaterialPageRoute(builder: (context) {
      return MainPage();
    });
  }
}
