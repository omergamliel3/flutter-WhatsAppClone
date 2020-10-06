import 'dart:async';

import 'package:WhatsAppClone/presentation/screens/login/login_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

import '../../test_helper.dart';

void main() {
  // construct mocked services
  UserServiceMock userService;
  AuthServiceMock auth;
  ConnectivityServiceMock connectivity;
  RouterServiceMock router;
  DialogServiceMock dialogService;

  setUp(() {
    userService = getAndRegisterUserServiceMock();
    auth = getAndRegisterAuthServiceMock();
    connectivity = getAndRegisterConnectivityServiceMock();
    router = getAndRegisterRouterServiceMock();
    dialogService = getAndRegisterDialogServiceMock();
  });

  group('LoginViewModel Test -', () {
    group('viewState tests:', () {
      /// [viewState getter initial value test]
      test('when get viewState should return ViewState.initial', () async {
        // construct login viewmodel
        var model = LoginViewModel();
        var state = await model.viewState.first;
        expect(state, ViewState.initial);
      });

      /// [update viewState (setState) test]
      test('when setState should add viewState value to viewState stream',
          () async {
        // construct login viewmodel
        var model = LoginViewModel();
        var stream = model.viewState;
        expect(stream, emits(ViewState.initial));
        model.setState(ViewState.phone);
        expect(stream, emits(ViewState.phone));
        model.setState(ViewState.busy);
        expect(stream, emits(ViewState.busy));
        model.setState(ViewState.username);
        expect(stream, emits(ViewState.username));
      });
    });

    group('connectivity tests:', () {
      /// [connectivity getter test (connection)]
      test(
          '''when get connectivity should return the device connectivity state (connected)''',
          () {
        // construct login viewmodel
        var model = LoginViewModel();
        // mock authentication state to true
        when(connectivity.connectivity).thenAnswer((realInvocation) => true);
        // get auth state from model
        var connectivityState = model.connectivity;
        // verify service call
        verify(connectivity.connectivity);
        // expected value
        expect(connectivityState, true);
      });

      /// [connectivity getter test (no connection)]
      test(
          '''when get connectivity should return the device connectivity state (not connected)''',
          () {
        // construct login viewmodel
        var model = LoginViewModel();
        // mock authentication state to true
        when(connectivity.connectivity).thenAnswer((realInvocation) => false);
        // get auth state from model
        var connectivityState = model.connectivity;
        // verify service call
        verify(connectivity.connectivity);
        // expected value
        expect(connectivityState, false);
      });
    });

    group('isUserValid tests:', () {
      /// [isUserValid method test (valid username)]
      test(
          '''when called isUserValid should return true (the username isn't used)''',
          () async {
        // construct login viewmodel
        var model = LoginViewModel();
        // mock validateUserName method to return true
        when(auth.validateUserName('omergamliel'))
            .thenAnswer((realInvocation) => Future.value(true));
        var valid = await model.isUserValid('omergamliel');
        // verify auth service call
        verify(auth.validateUserName('omergamliel'));
        // expected value
        expect(valid, true);
      });

      /// [isUserValid method test (Invalid username)]
      test("when called isUserValid should return false (the username is used)",
          () async {
        // construct login viewmodel
        var model = LoginViewModel();
        // mock validateUserName method to return false
        when(auth.validateUserName('omergamliel'))
            .thenAnswer((realInvocation) => Future.value(false));
        var valid = await model.isUserValid('omergamliel');
        // verify auth service call
        verify(auth.validateUserName('omergamliel'));
        // expected value
        expect(valid, false);
      });
    });

    group('authentication tests:', () {
      /// [isAuthenticated getter test (logged-in)]
      test('when get isAuthenticated should return the auth state (Logged-In)',
          () async {
        // construct login viewmodel
        var model = LoginViewModel();
        // mock authentication state to true
        when(auth.isAuthenticated).thenAnswer((realInvocation) => true);
        // get auth state from model
        var authState = model.isAuthenticated;
        // verify service call
        verify(auth.isAuthenticated);
        // expected value
        expect(authState, true);
      });

      /// [isAuthenticated getter test (not-logged)]
      test('when get isAuthenticated should return the auth state (Not-logged)',
          () async {
        // construct login viewmodel
        var model = LoginViewModel();
        // mock authentication state to false
        when(auth.isAuthenticated).thenAnswer((realInvocation) => false);
        // get auth state from model
        var authState = model.isAuthenticated;
        // verify service call
        verify(auth.isAuthenticated);
        // expected value
        expect(authState, false);
      });
    });

    group('submitPhoneAuth tests:', () {
      /// [submitPhoneAuth test (no connection)]
      test('''when submitPhoneAuth (no connectivity) should show dialog''',
          () async {
        // construct login viewmodel
        var model = LoginViewModel();
        model.viewState.listen(print);
        //mock connectivity to true
        when(connectivity.connectivity).thenAnswer((realInvocation) => false);
        await model.submitPhoneAuth('0587675744');
        expect(model.viewState, emits(ViewState.initial));
        verify(dialogService.showDialog(
            title: 'No internet connection',
            description: 'Please connect your device.',
            buttonTitle: 'OK'));
        verifyNever(auth.mockRegisterUser());
      });

      /// [submitPhoneAuth test (connection, register)]
      test(
          '''when submitPhoneAuth (connectivity) should update viewState to busy and call registerUser (auth service), then should update viewState to username''',
          () async {
        // construct login viewmodel
        var model = LoginViewModel();
        model.viewState.listen(print);
        // mock connectivity to true
        when(connectivity.connectivity).thenAnswer((realInvocation) => true);
        // mock auth registe to true
        when(auth.mockRegisterUser())
            .thenAnswer((realInvocation) => Future.value(true));
        await model.submitPhoneAuth('0587675744');
        expect(model.viewState, emits(ViewState.username));
        verify(auth.mockRegisterUser());
      });

      /// [submitPhoneAuth test (connection, failed to register)]
      test(
          '''when submitPhoneAuth (connectivity) should update viewState to busy and call registerUser (auth service) with failure, then should update viewState back to phone''',
          () async {
        // construct login viewmodel
        var model = LoginViewModel();
        model.viewState.listen(print);
        // mock connectivity to true
        when(connectivity.connectivity).thenAnswer((realInvocation) => true);
        // mock auth registe to true
        when(auth.mockRegisterUser())
            .thenAnswer((realInvocation) => Future.value(false));
        await model.submitPhoneAuth('0587675744');
        expect(model.viewState, emits(ViewState.phone));
        verify(auth.mockRegisterUser());
      });
    });

    group('submitUsernameAuth tests:', () {
      /// [submitUsernameAuth test (no connection)]
      test('when submitUsernameAuth (no connectivity) should show dialog ',
          () async {
        var username = 'omergamliel';
        // construct login viewmodel
        var model = LoginViewModel();
        model.setState(ViewState.username);
        model.viewState.listen(print);
        when(connectivity.connectivity).thenAnswer((realInvocation) => false);
        await model.submitUsernameAuth(username);
        expect(model.viewState, emits(ViewState.username));
        verify(dialogService.showDialog(
            title: 'No internet connection',
            description: 'Please connect your device.',
            buttonTitle: 'OK'));
        verifyNever(auth.validateUserName(username));
        // when(auth.validateUserName('omergamliel'))
        //     .thenAnswer((realInvocation) => Future.value(true));
      });

      /// [submitUsernameAuth test (connection, invalid username)]
      test(
          '''when submitUsernameAuth (connectivity) should update view state to busy, failed to validate username, then update viewState to username''',
          () async {
        var username = 'omergamliel';
        // construct login viewmodel
        var model = LoginViewModel();
        // set ViewState to username
        model.setState(ViewState.username);
        // listen to viewState events
        model.viewState.listen(print);
        // mock connectivity to true
        when(connectivity.connectivity).thenAnswer((realInvocation) => true);
        // mock validateUserName to false (invalid)
        when(auth.validateUserName(username))
            .thenAnswer((realInvocation) => Future.value(false));
        // call submitUsernameAuth
        await model.submitUsernameAuth(username);
        // expect ViewState username
        expect(model.viewState, emits(ViewState.username));
        // verify showDialog been called from dialogService
        verify(dialogService.showDialog(
            title: 'Username is taken',
            description: 'Please enter another username.',
            buttonTitle: 'OK'));
        // should never call addUserName
        verifyNever(auth.addUser(username, PickedFile('')));
      });

      /// [submitUsernameAuth test]
      /// [connection, valid username, success addUserName]
      test(
          '''when submitUsernameAuth (connectivity) should update view state to busy, success validate username, success to addUserName, then saveUserName and update viewState to profile pic''',
          () async {
        var username = 'omergamliel';
        // construct login viewmodel
        var model = LoginViewModel();
        // set ViewState to username
        model.setState(ViewState.username);
        // listen to viewState events
        model.viewState.listen(print);
        // mock connectivity to true
        when(connectivity.connectivity).thenAnswer((realInvocation) => true);
        // mock validateUserName to true (valid)
        when(auth.validateUserName(username))
            .thenAnswer((realInvocation) => Future.value(true));
        // call submitUsernameAuth
        await model.submitUsernameAuth(username);
        // expect ViewState profilePic
        expect(model.viewState, emits(ViewState.profilePic));
        // verify validateUserName call
        verify(auth.validateUserName(username));
      });
    });

    group('submitProfilePic tests:', () {
      /// [submitProfilePic test (no connection)]
      test('''when submitProfilePic with no picked image should show dialog''',
          () async {
        // construct model
        var model = LoginViewModel();
        // set viewState to profilePic
        model.setState(ViewState.profilePic);
        // call submitProfilePic
        await model.submitProfilePic();
        // model viewState should stay ViewState.profilePic
        expect(model.viewState, emits(ViewState.profilePic));
        // verify dialog service showDialog call
        verify(dialogService.showDialog(
            title: 'Profile image empty',
            description: 'Please pick image from gallery or camera',
            buttonTitle: 'OK'));
      });

      /// [submitProfilePic test (success addUser)]
      test(
          '''when submitProfilePic with picked image should update viewState to busy and call submitAuth, then should saveUserName and navigateMainPage''',
          () async {
        when(auth.addUser(null, null))
            .thenAnswer((realInvocation) => Future.value(true));
        // construct model
        var model = LoginViewModel();
        // set viewState to profilePic
        model.setState(ViewState.profilePic);
        // call submitProfilePic
        await model.submitProfilePic(profileImage: PickedFile(''));
        // model viewState should be ViewState.busy
        expect(model.viewState, emits(ViewState.busy));
        verify(userService.saveUserName(null));
        verify(router.navigateMainPage());
        // should never call dialog service showDialog call
        verifyNever(dialogService.showDialog(
            title: 'Profile image empty',
            description: 'Please pick image from gallery or camera',
            buttonTitle: 'OK'));
      });

      /// [submitProfilePic test (failed to addUser)]
      test(
          '''when submitProfilePic with picked image should update viewState to busy and call submitAuth, then should show dialog and update viewState to profilePic''',
          () async {
        when(auth.addUser(null, null))
            .thenAnswer((realInvocation) => Future.value(false));
        // construct model
        var model = LoginViewModel();
        // set viewState to profilePic
        model.setState(ViewState.profilePic);
        // call submitProfilePic
        await model.submitProfilePic(profileImage: PickedFile(''));
        // model viewState should be ViewState.busy
        expect(model.viewState, emits(ViewState.profilePic));
        // should never call dialog service showDialog call
        verifyNever(userService.saveUserName(null));
        verifyNever(router.navigateMainPage());
        verify(dialogService.showDialog(
            title: 'Something went wrnog',
            description: 'Please try again.',
            buttonTitle: 'OK'));
      });
    });
  });
}
