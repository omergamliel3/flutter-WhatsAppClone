import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

import 'package:WhatsAppClone/data/cloud_storage/cloud_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:WhatsAppClone/services/auth/auth_service.dart';

import '../test_helper.dart';

class CloudDatabaseMock extends Mock implements CloudDatabase {}

class SharedPreferencesMock extends Mock implements SharedPreferences {}

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class AuthServiceMock extends Mock implements AuthService {}

void main() {
  group('auth service tests - ', () {
    test('when registerUser with mobile should return true', () async {
      var authService = AuthServiceMock();
      var mobile = '0587675744';
      when(authService.registerUser(mobile))
          .thenAnswer((realInvocation) => Future.value(true));
      var register = await authService.registerUser(mobile);
      expect(register, true);
    });

    test(
        '''when registerUser with mobile should return false (firebase auth exception)''',
        () async {
      var authService = AuthServiceMock();
      var mobile = '0587675744';
      when(authService.registerUser(mobile))
          .thenAnswer((realInvocation) => Future.value(false));
      var register = await authService.registerUser(mobile);
      expect(register, false);
    });

    test(
        '''when addUserName should add username in cloudDatabase and return true''',
        () async {
      getAndRegisterDialogServiceMock();
      var prefs = SharedPreferencesMock();
      var cloudDatabase = CloudDatabaseMock();
      var authService =
          AuthService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      var username = 'omergamliel';
      when(cloudDatabase.addUser(username, PickedFile('')))
          .thenAnswer((realInvocation) => Future.value(true));
      var success = await authService.addUser(username, PickedFile(''));
      expect(success, true);
      verify(cloudDatabase.addUser(username, PickedFile('')));
    });

    test(
        '''when addUserName should raise exception in cloudDatabase, and return false''',
        () async {
      getAndRegisterDialogServiceMock();
      var prefs = SharedPreferencesMock();
      var cloudDatabase = CloudDatabaseMock();
      var authService =
          AuthService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      var username = 'omergamliel';
      when(cloudDatabase.addUser(username, PickedFile('')))
          .thenAnswer((realInvocation) => Future.value(false));
      var success = await authService.addUser(username, PickedFile(''));
      expect(success, false);
      verify(cloudDatabase.addUser(username, PickedFile('')));
    });

    test(
        '''when validateUserName should validate username via cloudDatabase and return true (valid username)''',
        () async {
      getAndRegisterDialogServiceMock();
      var prefs = SharedPreferencesMock();
      var cloudDatabase = CloudDatabaseMock();
      var authService =
          AuthService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      var username = 'omergamliel';
      when(cloudDatabase.validateUserName(username))
          .thenAnswer((realInvocation) => Future.value(true));
      var valid = await authService.validateUserName(username);
      expect(valid, true);
      verify(cloudDatabase.validateUserName(username));
    });

    test(
        '''when validateUserName should validate username via cloudDatabase and return false (invalid username)''',
        () async {
      getAndRegisterDialogServiceMock();
      var prefs = SharedPreferencesMock();
      var cloudDatabase = CloudDatabaseMock();
      var authService =
          AuthService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      var username = 'omergamliel';
      when(cloudDatabase.validateUserName(username))
          .thenAnswer((realInvocation) => Future.value(false));
      var valid = await authService.validateUserName(username);
      expect(valid, false);
      verify(cloudDatabase.validateUserName(username));
    });

    test(
        '''when saveAuthentication should set auth-key to true in shared preferences, and return true''',
        () async {
      getAndRegisterDialogServiceMock();
      final prefs = SharedPreferencesMock();
      final cloudDatabase = CloudDatabaseMock();
      final authService =
          AuthService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      final _kAuthKeyName = 'authenticate';
      when(prefs.setBool(_kAuthKeyName, true))
          .thenAnswer((realInvocation) => Future.value(true));
      var saveAuth = await authService.saveAuthentication(auth: true);
      expect(saveAuth, true);
      verify(prefs.setBool(_kAuthKeyName, true));
    });

    test(
        '''when saveAuthentication should set auth-key to false in shared preferences, and return false''',
        () async {
      getAndRegisterDialogServiceMock();
      final prefs = SharedPreferencesMock();
      final cloudDatabase = CloudDatabaseMock();
      final authService =
          AuthService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      final _kAuthKeyName = 'authenticate';
      when(prefs.setBool(_kAuthKeyName, false))
          .thenAnswer((realInvocation) => Future.value(false));
      var saveAuth = await authService.saveAuthentication(auth: false);
      expect(saveAuth, false);
      verify(prefs.setBool(_kAuthKeyName, false));
    });

    test(
        '''when get isAuthenticated should retunr auth state (Authenticated)''',
        () async {
      getAndRegisterDialogServiceMock();
      final prefs = SharedPreferencesMock();
      final cloudDatabase = CloudDatabaseMock();
      final authService =
          AuthService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      final _kAuthKeyName = 'authenticate';
      var authenticated = true;
      when(prefs.getBool(_kAuthKeyName))
          .thenAnswer((realInvocation) => authenticated);
      var authState = await authService.isAuthenticated;
      expect(authState, authenticated);
      verify(prefs.getBool(_kAuthKeyName));
    });

    test(
        '''when get isAuthenticated should return auth state (Not-authenticated)''',
        () async {
      getAndRegisterDialogServiceMock();
      final prefs = SharedPreferencesMock();
      final cloudDatabase = CloudDatabaseMock();
      final authService =
          AuthService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      final _kAuthKeyName = 'authenticate';
      var authenticated = false;
      when(prefs.getBool(_kAuthKeyName))
          .thenAnswer((realInvocation) => authenticated);
      var authState = await authService.isAuthenticated;
      expect(authState, authenticated);
      verify(prefs.getBool(_kAuthKeyName));
    });
  });
}
