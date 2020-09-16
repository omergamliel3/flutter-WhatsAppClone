import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/models/contact_entity.dart';

import 'package:WhatsAppClone/core/shared/constants.dart';

import 'package:WhatsAppClone/pages/main/main_page.dart';
import 'package:WhatsAppClone/pages/screens/shared/select_contact_screen.dart';
import 'package:WhatsAppClone/pages/screens/chats/private_chat_page.dart';
import 'package:WhatsAppClone/pages/screens/login/login_page.dart';
import 'package:WhatsAppClone/pages/screens/loading/loading_page.dart';

class Routes {
  Routes._();

  // static variables
  static const String splash = '/';
  static const String login = '/login';
  static const String main = '/main';
  static const String privateChat = '/privateChat';
  static const String contacts = '/contatcs';

  // top level app routes settings
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(builder: (context) {
          return MainPage();
        });
        break;
      case splash:
        return MaterialPageRoute(builder: (context) {
          return LoadingPage();
        });
        break;
      case login:
        return MaterialPageRoute(builder: (context) {
          return LoginPage();
        });
        break;
      case contacts:
        // pass mode argument
        Map<String, dynamic> arguments = settings.arguments;
        return MaterialPageRoute(builder: (context) {
          return SelectContactScreen(arguments['mode']);
        });
        break;
      case privateChat:
        // pass contact entity argument
        Map<String, dynamic> arguments = settings.arguments;
        return MaterialPageRoute(builder: (context) {
          return PrivateChatPage(ContactEntity.fromJsonMap(arguments));
        });
        break;
      default:
        return MaterialPageRoute(builder: (context) {
          return MainPage();
        });
    }
  }

  /// navigate main page
  static void navigateMainPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, main);
  }

  /// navigate login page
  static void navigateLoginPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  /// navigate contact screen
  static void navigateContactScreen(
      BuildContext context, ContactMode contactMode) {
    Navigator.pushNamed(context, contacts, arguments: {'mode': contactMode});
  }

  /// navigate private chat screen
  static void navigatePrivateChatSceen(
      BuildContext context, ContactEntity contactEntity) {
    Navigator.pushNamed(context, privateChat,
        arguments: contactEntity.toJsonMap());
  }
}
