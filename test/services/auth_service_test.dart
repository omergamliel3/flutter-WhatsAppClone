import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

import 'package:WhatsAppClone/data/datasources/cloud_database.dart';
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
      final authService = AuthServiceMock();
      const mobile = '0587675744';
      when(authService.registerUser(mobile))
          .thenAnswer((realInvocation) => Future.value(true));
      final register = await authService.registerUser(mobile);
      expect(register, true);
    });

    test(
        '''when registerUser with mobile should return false (firebase auth exception)''',
        () async {
      final authService = AuthServiceMock();
      const mobile = '0587675744';
      when(authService.registerUser(mobile))
          .thenAnswer((realInvocation) => Future.value(false));
      final register = await authService.registerUser(mobile);
      expect(register, false);
    });

    test(
        '''when addUserName should add username in cloudDatabase and return true''',
        () async {
      getAndRegisterDialogServiceMock();
      final prefs = SharedPreferencesMock();
      final cloudDatabase = CloudDatabaseMock();
      const username = 'omergamliel';
      final file = PickedFile('path');
      when(cloudDatabase.addUser(username, file))
          .thenAnswer((realInvocation) => Future.value(true));
      final authService =
          AuthService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      final success = await authService.addUser(username, file);
      expect(success, true);
      verify(cloudDatabase.addUser(username, file));
    });

    test(
        '''when addUserName should raise exception in cloudDatabase, and return false''',
        () async {
      getAndRegisterDialogServiceMock();
      final prefs = SharedPreferencesMock();
      final cloudDatabase = CloudDatabaseMock();
      final authService =
          AuthService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      const username = 'omergamliel';
      final file = PickedFile('path');
      when(cloudDatabase.addUser(username, file))
          .thenAnswer((realInvocation) => Future.value(false));
      final success = await authService.addUser(username, file);
      expect(success, false);
      verify(cloudDatabase.addUser(username, file));
    });

    test(
        '''when validateUserName should validate username via cloudDatabase and return true (valid username)''',
        () async {
      getAndRegisterDialogServiceMock();
      final prefs = SharedPreferencesMock();
      final cloudDatabase = CloudDatabaseMock();
      final authService =
          AuthService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      const username = 'omergamliel';
      when(cloudDatabase.validateUserName(username))
          .thenAnswer((realInvocation) => Future.value(true));
      final valid = await authService.validateUserName(username);
      expect(valid, true);
      verify(cloudDatabase.validateUserName(username));
    });

    test(
        '''when validateUserName should validate username via cloudDatabase and return false (invalid username)''',
        () async {
      getAndRegisterDialogServiceMock();
      final prefs = SharedPreferencesMock();
      final cloudDatabase = CloudDatabaseMock();
      final authService =
          AuthService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      const username = 'omergamliel';
      when(cloudDatabase.validateUserName(username))
          .thenAnswer((realInvocation) => Future.value(false));
      final valid = await authService.validateUserName(username);
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
      const _kAuthKeyName = 'authenticate';
      when(prefs.setBool(_kAuthKeyName, true))
          .thenAnswer((realInvocation) => Future.value(true));
      final saveAuth = await authService.saveAuthentication(auth: true);
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
      const _kAuthKeyName = 'authenticate';
      when(prefs.setBool(_kAuthKeyName, false))
          .thenAnswer((realInvocation) => Future.value(false));
      final saveAuth = await authService.saveAuthentication();
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
      const _kAuthKeyName = 'authenticate';
      const authenticated = true;
      when(prefs.getBool(_kAuthKeyName))
          .thenAnswer((realInvocation) => authenticated);
      final authState = authService.isAuthenticated;
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
      const _kAuthKeyName = 'authenticate';
      const authenticated = false;
      when(prefs.getBool(_kAuthKeyName))
          .thenAnswer((realInvocation) => authenticated);
      final authState = authService.isAuthenticated;
      expect(authState, authenticated);
      verify(prefs.getBool(_kAuthKeyName));
    });
  });
}
