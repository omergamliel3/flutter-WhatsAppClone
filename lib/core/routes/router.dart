import 'package:flutter/material.dart';

import 'package:stacked_services/stacked_services.dart';
import '../../locator.dart';

import '../models/contact_entity.dart';
import 'routing_constants.dart';
import 'undefined_route.dart';

import '../../presentation/index.dart';

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
          return SelectContactScreen(arguments['mode'], arguments['path']);
        });
        break;
      case privateChatRoute:
        // pass contact entity argument
        Map<String, dynamic> arguments = settings.arguments;
        return MaterialPageRoute(builder: (context) {
          return PrivateChatPage(ContactEntity.fromJsonMap(arguments));
        });
        break;
      case displayPictureRoute:
        Map<String, dynamic> arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return DisplayPictureView(
              imagePath: arguments['path'],
            );
          },
        );
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
  Future<dynamic> navigateContactScreen(ContactMode contactMode,
      [String imagePath]) {
    return navigator.navigateTo(contactsRoute,
        arguments: {'mode': contactMode, 'path': imagePath});
  }

  /// navigate private chat screen
  Future<dynamic> navigatePrivateChatSceen(ContactEntity contactEntity) {
    return navigator.navigateTo(privateChatRoute,
        arguments: contactEntity.toJsonMap());
  }

  Future<dynamic> navigateDisplayPicture(String path) {
    return navigator.navigateTo(displayPictureRoute, arguments: {'path': path});
  }

  void pop() {
    navigator.back();
  }
}
