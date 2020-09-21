import 'package:stacked/stacked.dart';

import '../../../services/firebase/auth_service.dart';
import '../../../services/firebase/firestore_service.dart';
import '../../../services/local_storage/prefs_service.dart';
import '../../../services/locator.dart';
import '../../../services/network/connectivity.dart';
import '../../../core/routes/navigation_service%20.dart';

class LoginViewModel extends BaseViewModel {
  // get services
  final prefsService = locator<PrefsService>();
  final authService = locator<AuthService>();
  final firestoreService = locator<FirestoreService>();
  final connectivityService = locator<ConnectivityService>();
  final navigator = locator<NavigationService>();

  // return the latest connectivity status
  bool get connectivity => connectivityService.connectivity;
  bool get isAuthenticated => prefsService.isAuthenticated;

  // validate username via firestore service
  Future<bool> isUserValid(String username) async {
    return await firestoreService.validateUserName(username);
  }

  // add username via firestore service
  Future<void> addUsername(String username) async {
    return await firestoreService.addUserName(username);
  }

  // save username localy via prefs service
  void saveUsername(String username) {
    prefsService.saveUserName(username: username);
  }

  // navigate main page via navigator service
  void navigateMainPage() {
    navigator.navigateMainPage();
  }
}
