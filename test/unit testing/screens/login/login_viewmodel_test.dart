import 'package:WhatsAppClone/core/routes/navigation_service%20.dart';
import 'package:WhatsAppClone/services/auth/auth_service.dart';
import 'package:WhatsAppClone/services/auth/user_service.dart';
import 'package:WhatsAppClone/services/locator.dart';
import 'package:WhatsAppClone/services/network/connectivity.dart';
import 'package:WhatsAppClone/views/screens/login/login_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserServiceMock extends Mock implements UserService {}

class AuthServiceMock extends Mock implements AuthService {}

class ConnectivityServiceeMock extends Mock implements ConnectivityService {}

class NavigationServiceMock extends Mock implements NavigationService {}

void main() {
  group('LoginViewModel Test -', () {
    // construct mocked services
    var userService = UserServiceMock();
    var auth = AuthServiceMock();
    var connectivity = ConnectivityServiceeMock();
    var navigator = NavigationServiceMock();
    // register services via locator
    locator.registerSingleton<UserService>(userService);
    locator.registerSingleton<AuthService>(auth);
    locator.registerSingleton<ConnectivityService>(connectivity);
    locator.registerSingleton<NavigationService>(navigator);
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

    /// [saveUsername method test (success save username)]
    test('''when called saveUsername and success should save username
           in userService, authService, and navigate to main page''', () async {
      // mock addUserName to return true when called
      when(auth.addUserName('omergamliel'))
          .thenAnswer((realInvocation) => Future.value(true));
      // call and await for saveUsername from model
      await model.saveUsername('omergamliel');
      // verify in services calls
      verifyInOrder([
        auth.addUserName('omergamliel'),
        userService.saveUserName('omergamliel'),
        navigator.navigateMainPage()
      ]);
    });

    /// [saveUsername method test (failed to save username)]
    test('''when called saveUsername and failed should call dialog service''',
        () async {
      // mock addUserName to return false when called
      when(auth.addUserName('omergamliel'))
          .thenAnswer((realInvocation) => Future.value(false));
      // call and await for saveUserName from model
      await model.saveUsername('omergamliel');
      // verify service call
      verify(auth.addUserName('omergamliel'));
      // should never save username in userService
      verifyNever(userService.saveUserName('omergamliel'));
      // should never navigate to main page
      verifyNever(navigator.navigateMainPage());
    });

    /// [navigateMainPage method test]
    test('''when called navigateMainPage should navigate
           main page from navigator service''', () {
      model.navigateMainPage();
      verify(navigator.navigateMainPage());
    });
  });
}
