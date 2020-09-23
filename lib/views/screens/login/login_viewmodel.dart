import 'package:stacked/stacked.dart';

import '../../../services/auth/auth_service.dart';
import '../../../services/auth/user_service.dart';
import '../../../services/locator.dart';
import '../../../services/network/connectivity.dart';
import '../../../core/routes/navigation_service%20.dart';

class LoginViewModel extends BaseViewModel {
  // get services
  final user = locator<UserService>();
  final authService = locator<AuthService>();
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

  // add username via firestore service
  Future<void> addUsername(String username) async {
    return await auth.addUserName(username);
  }

  // save username localy via prefs service
  void saveUsername(String username) {
    user.saveUserName(username);
  }

  // navigate main page via navigator service
  void navigateMainPage() {
    navigator.navigateMainPage();
  }
}
