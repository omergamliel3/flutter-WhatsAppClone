import 'package:stacked/stacked.dart';
//import 'package:stacked_services/stacked_services.dart';

import '../../../services/auth/auth_service.dart';
import '../../../services/auth/user_service.dart';
import '../../../services/locator.dart';
import '../../../services/network/connectivity.dart';
import '../../../core/routes/router.dart';

enum ViewState { initial, busy, phone, username, profilePic }

class LoginViewModel extends BaseViewModel {
  // get services
  final _router = locator<Router>();
  final _auth = locator<AuthService>();
  final _userService = locator<UserService>();
  final _connectivityService = locator<ConnectivityService>();

  //final _dialogService = locator<DialogService>();

  var _state = ViewState.initial;
  ViewState get state => _state;

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  // return the latest connectivity status
  bool get connectivity => _connectivityService.connectivity;
  bool get isAuthenticated => _auth.isAuthenticated;

  // validate username via firestore service
  Future<bool> isUserValid(String username) async {
    return await _auth.validateUserName(username);
  }

  // save username in local, cloud storage
  Future<void> saveUsername(String username) async {
    // save username in cloud firestore
    var success = await _auth.addUserName(username);
    if (!success) {
      return;
    }
    // save username localy
    _userService.saveUserName(username);
    // delay to show loading indicator
    await Future.delayed(Duration(seconds: 1));
    // navigate main page
    navigateMainPage();
  }

  // navigate main page via navigator service
  void navigateMainPage() {
    _router.navigateMainPage();
  }

  void submitPhoneAuth() {
    _setState(ViewState.busy);
    // DO SOME STUFF
    _setState(ViewState.username);
  }

  void submitUsernameAuth() {
    _setState(ViewState.busy);
    // DO SOME STUFF
    _setState(ViewState.profilePic);
  }

  void submitProfilePic() {
    _setState(ViewState.busy);
    // DO SOME STUFF
    navigateMainPage();
  }
}
