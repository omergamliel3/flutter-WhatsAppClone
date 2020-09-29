import 'package:flutter/material.dart';

import 'package:stacked_services/stacked_services.dart';
import '../../services/locator.dart';

import '../models/contact_entity.dart';
import '../shared/constants.dart';
import 'routing_constants.dart';
import 'undefined_route.dart';

import '../../views/main/main_view.dart';
import '../../views/screens/shared/select_contact_view.dart';
import '../../views/screens/chats/private_chat_view.dart';
import '../../views/screens/login/login_view.dart';
import '../../views/screens/loading/loading_view.dart';

class Router {
  final navigator = locator<NavigationService>();

  // top level app routes settings
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainRoute:
        return MaterialPageRoute(builder: (context) {
          return MainPage();
        });
        break;
      case splashRoute:
        return MaterialPageRoute(builder: (context) {
          return LoadingPage();
        });
        break;
      case loginRoute:
        return MaterialPageRoute(builder: (context) {
          return LoginPage();
        });
        break;
      case contactsRoute:
        // pass mode argument
        Map<String, dynamic> arguments = settings.arguments;
        return MaterialPageRoute(builder: (context) {
          return SelectContactScreen(arguments['mode']);
        });
        break;
      case privateChatRoute:
        // pass contact entity argument
        Map<String, dynamic> arguments = settings.arguments;
        return MaterialPageRoute(builder: (context) {
          return PrivateChatPage(ContactEntity.fromJsonMap(arguments));
        });
        break;
      default:
        return MaterialPageRoute(builder: (context) {
          return UndefinedRouteView();
        });
    }
  }

  /// navigate main page
  Future<dynamic> navigateMainPage() {
    return navigator.replaceWith(mainRoute);
  }

  /// navigate login page
  Future<dynamic> navigateLoginPage() {
    return navigator.replaceWith(loginRoute);
  }

  /// navigate contact screen
  Future<dynamic> navigateContactScreen(ContactMode contactMode) {
    return navigator
        .navigateTo(contactsRoute, arguments: {'mode': contactMode});
  }

  /// navigate private chat screen
  Future<dynamic> navigatePrivateChatSceen(ContactEntity contactEntity) {
    return navigator.navigateTo(privateChatRoute,
        arguments: contactEntity.toJsonMap());
  }

  void pop() {
    navigator.back();
  }
}
