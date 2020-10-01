import 'package:WhatsAppClone/presentation/screens/login/login_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_helper.dart';

void main() {
  // construct mocked services
  UserServiceMock userService;
  AuthServiceMock auth;
  ConnectivityServiceMock connectivity;
  RouterServiceMock router;
  DialogServiceMock dialogService;

  userService = getAndRegisterUserServiceMock();
  auth = getAndRegisterAuthServiceMock();
  connectivity = getAndRegisterConnectivityServiceMock();
  router = getAndRegisterRouterServiceMock();
  dialogService = getAndRegisterDialogServiceMock();

  group('LoginViewModel Test -', () {
    // construct login viewmodel
    var model = LoginViewModel();

    /// [connectivity getter test (connection)]
    test('''when get connectivity should return
            the device connectivity state (connected)''', () {
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
    test('''when get connectivity should return
            the device connectivity state (not connected)''', () {
      // mock authentication state to true
      when(connectivity.connectivity).thenAnswer((realInvocation) => false);
      // get auth state from model
      var connectivityState = model.connectivity;
      // verify service call
      verify(connectivity.connectivity);
      // expected value
      expect(connectivityState, false);
    });

    /// [isAuthenticated getter test (logged-in)]
    test('when get isAuthenticated should return the auth state (Logged-In)',
        () async {
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
      // mock authentication state to false
      when(auth.isAuthenticated).thenAnswer((realInvocation) => false);
      // get auth state from model
      var authState = model.isAuthenticated;
      // verify service call
      verify(auth.isAuthenticated);
      // expected value
      expect(authState, false);
    });

    /// [isUserValid method test (valid username)]
    test("when called isUserValid should return true (the username isn't used)",
        () async {
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
}
