import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/foundation.dart' as foundation;

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
  final _dialogService = locator<DialogService>();

  final BehaviorSubject<ViewState> _stateSubject =
      BehaviorSubject<ViewState>.seeded(ViewState.initial);

  Stream<ViewState> get viewState => _stateSubject.stream;

  void setState(ViewState state) {
    _stateSubject.add(state);
  }

  // return the latest connectivity status
  bool get connectivity => _connectivityService.connectivity;
  bool get isAuthenticated => _auth.isAuthenticated;

  // validate username via firestore service
  Future<bool> isUserValid(String username) async {
    return await _auth.validateUserName(username);
  }

  // submit phone auth
  Future submitPhoneAuth(String value) async {
    if (!connectivity) {
      _showErrorDialog('No internet connection', 'Please connect your device.');
      return;
    }
    setState(ViewState.busy);
    bool register;
    if (foundation.kDebugMode) {
      register = await _auth.mockRegisterUser();
    } else {
      register = await _auth.registerUser(value);
    }
    if (register) {
      setState(ViewState.username);
    } else {
      setState(ViewState.phone);
    }
  }

  // submit username auth
  void submitUsernameAuth(String value) async {
    if (!connectivity) {
      _showErrorDialog('No internet connection', 'Please connect your device.');
      return;
    }
    setState(ViewState.busy);
    var validate = await _auth.validateUserName(value);
    if (!validate) {
      _showErrorDialog('Username is taken', 'Please enter another username.');
      setState(ViewState.username);
    } else {
      var success = await _auth.addUserName(value);
      if (!success) {
        _showErrorDialog('Something went wrnog', 'Please try again.');
        setState(ViewState.username);
        return;
      }
      _userService.saveUserName(value);
      setState(ViewState.profilePic);
    }
  }

  // submit profile pic
  void submitProfilePic() async {
    if (!connectivity) {
      _showErrorDialog('No internet connection', 'Please connect your device.');
      return;
    }
    setState(ViewState.busy);
    await Future.delayed(Duration(seconds: 2));
    _router.navigateMainPage();
  }

  void _showErrorDialog(String title, String description) {
    _dialogService.showDialog(
      title: title,
      description: description,
      buttonTitle: 'OK',
    );
  }
}
