import 'package:stacked/stacked.dart';

import '../../../services/auth/auth_service.dart';
import '../../../services/auth/user_service.dart';
import '../../../services/locator.dart';
import '../../../services/network/connectivity.dart';
import '../../../core/routes/navigation_service%20.dart';

class LoginViewModel extends BaseViewModel {
  // get services
  final userService = locator<UserService>();
  final connectivityService = locator<ConnectivityService>();
  final navigator = locator<NavigationService>();
  final auth = locator<AuthService>();

  // return the latest connectivity status
  bool get connectivity => connectivityService.connectivity;
  bool get isAuthenticated => auth.isAuthenticated;

  // validate username via firestore service
  Future<bool> isUserValid(String username) async {
    return await auth.validateUserName(username);
  }

  // save username in local, cloud storage
  Future<void> saveUsername(String username) async {
    // save username in cloud firestore
    var success = await auth.addUserName(username);
    if (!success) {
      // TODO: IMPLEMENT DIALOG SERVICE
      return;
    }
    // save username localy
    userService.saveUserName(username);
    // delay to show loading indicator
    await Future.delayed(Duration(seconds: 1));
    // navigate main page
    navigateMainPage();
  }

  // navigate main page via navigator service
  void navigateMainPage() {
    navigator.navigateMainPage();
  }
}
