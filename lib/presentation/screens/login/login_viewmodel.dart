import 'dart:async';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../../../services/auth/auth_service.dart';
import '../../../services/auth/user_service.dart';
import '../../../locator.dart';
import '../../../core/network/network_info.dart';
import '../../../core/routes/router.dart';

enum ViewState { initial, busy, phone, username, profilePic }

class LoginViewModel extends BaseViewModel {
  // get services
  final _router = locator<Router>();
  final _auth = locator<AuthService>();
  final _userService = locator<UserService>();
  final _connectivityService = locator<NetworkInfo>();
  final _dialogService = locator<DialogService>();

  // state stream
  final BehaviorSubject<ViewState> _stateSubject =
      BehaviorSubject<ViewState>.seeded(ViewState.initial);

  // image file data
  PickedFile _profileImage;
  Uint8List _profileImageUnit8List;

  // auth data
  String _username;

  void setState(ViewState state) {
    _stateSubject.add(state);
  }

  // validate username via firestore service
  Future<bool> isUserValid(String username) async {
    return await _auth.validateUserName(username);
  }

  // submit phone auth
  Future<void> submitPhoneAuth(String value) async {
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
  Future<void> submitUsernameAuth(String value) async {
    if (!connectivity) {
      _showErrorDialog('No internet connection', 'Please connect your device.');
      return;
    }
    setState(ViewState.busy);
    var validate = await _auth.validateUserName(value);
    if (!validate) {
      _showErrorDialog('Username is taken', 'Please enter another username.');
      setState(ViewState.username);
      return;
    }
    _username = value;
    setState(ViewState.profilePic);
  }

  // submit profile pic
  Future<void> submitProfilePic({PickedFile profileImage}) async {
    if (_profileImage == null && profileImage == null) {
      _showErrorDialog(
          'Profile image empty', 'Please pick image from gallery or camera');
      return;
    }
    setState(ViewState.busy);
    // call submit form after finish auth view states
    await submitAuth();
  }

  // submit user authentication
  Future<void> submitAuth() async {
    var success = await _auth.addUser(_username, _profileImage);
    if (!success) {
      _showErrorDialog('Something went wrnog', 'Please try again.');
      setState(ViewState.profilePic);
      return;
    }
    _userService.saveUserName(_username);
    _router.navigateMainPage();
  }

  // get image from device
  Future<void> getImage(ImageSource source) async {
    var image = await ImagePicker().getImage(source: source);
    if (image == null) {
      return;
    }
    _profileImage = image;
    _profileImageUnit8List = await image.readAsBytes();
    notifyListeners();
  }

  // show error dialog with a given title and description
  void _showErrorDialog(String title, String description) {
    _dialogService.showDialog(
      title: title,
      description: description,
      buttonTitle: 'OK',
    );
  }

  // view state stream getter
  Stream<ViewState> get viewState => _stateSubject.stream;

  // return the latest connectivity status
  bool get connectivity => _connectivityService.connectivity;

  // auth state
  bool get isAuthenticated => _auth.isAuthenticated;

  // image data in unit8list
  Uint8List get image => _profileImageUnit8List;
}
