import 'dart:async';

import 'package:WhatsAppClone/core/models/status.dart';
import 'package:WhatsAppClone/data/cloud_storage/cloud_database.dart';
import 'package:WhatsAppClone/services/auth/auth_service.dart';
import 'package:WhatsAppClone/services/auth/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_helper.dart';

class CloudDatabaseMock extends Mock implements CloudDatabase {}

class SharedPreferencesMock extends Mock implements SharedPreferences {}

void main() {
  AuthService authService;
  setUp(() {
    authService = getAndRegisterAuthServiceMock();
  });
  group('user service tests - ', () {
    /// [initUserService test - user is authenticated]
    test(
        '''when call initUserService should check if user is authenticated and getUserStauts if auth is true, else userStatus should be null.''',
        () async {
      // mocked data
      var username = 'omergamliel';
      var status = 'this is a test status!';
      // construct mocked data classes
      var cloudDatabase = CloudDatabaseMock();
      var prefs = SharedPreferencesMock();
      // mocked expected behavior
      when(authService.isAuthenticated).thenAnswer((realInvocation) => true);
      when(prefs.getString('username'))
          .thenAnswer((realInvocation) => username);
      when(cloudDatabase.getUserStatus(username))
          .thenAnswer((realInvocation) => Future.value(status));
      // construct tested service
      var userService =
          UserService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      // evoke initUserService tested method
      await userService.initUserService();
      // expected value is [status]
      expect(userService.userStatus, status);
      // verify service call
      verify(authService.isAuthenticated);
      verify(cloudDatabase.getUserStatus(username));
      verify(prefs.getString('username'));
    });

    /// [initUserService test - user is not authenticated]
    test(
        '''when call initUserService should check if user is authenticated and getUserStauts if auth is true, else userStatus should be null.''',
        () async {
      // construct mocked data classes
      var cloudDatabase = CloudDatabaseMock();
      var prefs = SharedPreferencesMock();
      // mocked tested behavior
      when(authService.isAuthenticated).thenAnswer((realInvocation) => false);
      var userService =
          // construct tested service
          UserService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      // evoke initUserService tested method
      await userService.initUserService();
      // expected value is null
      expect(userService.userStatus, null);
      // verify service call
      verify(authService.isAuthenticated);
    });

    /// [saveUserName test]
    test(
        '''when call saveUserName should set the given argument in shared preferences''',
        () async {
      // mocked data
      var username = 'omergamliel';
      // construct mocked data classes
      var cloudDatabase = CloudDatabaseMock();
      var prefs = SharedPreferencesMock();
      // mocked tested behavior
      when(prefs.setString('username', username))
          .thenAnswer((realInvocation) => Future.value(true));
      var userService =
          // construct tested service
          UserService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      // evoke saveUserName tested method
      var saved = await userService.saveUserName(username);
      // expecte valus is true
      expect(saved, true);
      // verify service call
      verify(prefs.setString('username', username));
    });

    /// [getUserStatus test]
    test(
        '''when call getUserStatus should set userStatus reactive value to the status retreived from cloudDatabase''',
        () async {
      // mocked data
      var username = 'omergamliel';
      var status = 'this is a test status!';
      // construct mocked data classes
      var cloudDatabase = CloudDatabaseMock();
      var prefs = SharedPreferencesMock();
      // mocked tested behavior
      when(prefs.getString('username'))
          .thenAnswer((realInvocation) => username);
      when(cloudDatabase.getUserStatus(username))
          .thenAnswer((realInvocation) => Future.value(status));
      // construct tested service
      var userService =
          UserService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      // expected to null (did not call init)
      expect(userService.userStatus, null);
      // evoke getUserStatus tested method
      await userService.getUserStatus();
      // expected status change after getUserStatus is called
      expect(userService.userStatus, status);
      // verify service calls
      verify(cloudDatabase.getUserStatus(username));
      verify(prefs.getString('username'));
    });

    /// [deleteStatus test]
    test(
        '''when call deleteStatus should remove the given status from cloudDatabase''',
        () async {
      // mocked status entity
      var status = Status(
          userName: 'omer',
          content: 'content',
          profileUrl: 'url',
          timestamp: DateTime.now());
      // construct mocked data classes
      var cloudDatabase = CloudDatabaseMock();
      var prefs = SharedPreferencesMock();
      // mocked tested behavior
      when(cloudDatabase.deleteStatus(status))
          .thenAnswer((realInvocation) => Future.value(true));
      // construct tested service
      var userService =
          UserService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      // evoke deleteStatus tested method
      var statusDeleted = await userService.deleteStatus(status);
      // expected value is true
      expect(statusDeleted, true);
      // verify service call
      verify(cloudDatabase.deleteStatus(status));
    });

    /// [getProfilePicURL test]
    test(
        '''when call getProfilePicURL should return profile pic download url''',
        () async {
      // mocked data
      var username = 'omergamliel';
      var url = 'firebase/images/url/image.jpg';
      // construct mocked data classes
      var cloudDatabase = CloudDatabaseMock();
      var prefs = SharedPreferencesMock();
      // mocked tested behavior
      when(prefs.getString('username'))
          .thenAnswer((realInvocation) => username);
      when(cloudDatabase.getProfilePicURL(username))
          .thenAnswer((realInvocation) => Future.value(url));
      // construct tested service
      var userService =
          UserService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      // evoke getProfilePicURL tested method
      var profilePicUrl = await userService.getProfilePicURL();
      // expected value is [url]
      expect(profilePicUrl, url);
      // veriy service call
      verify(cloudDatabase.getProfilePicURL(username));
    });

    /// [allowDelete test]
    test(
        '''when allowDelete should return whether the given name argument is the current device username''',
        () async {
      // mocked data
      var username = 'omergamliel';
      // construct mocked data classes
      var cloudDatabase = CloudDatabaseMock();
      var prefs = SharedPreferencesMock();
      // mocked tested behavior
      when(prefs.getString('username'))
          .thenAnswer((realInvocation) => username);
      // construct tested service
      var userService =
          UserService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
      var allow = userService.allowDelete(username);
      expect(allow, true);
      allow = userService.allowDelete('omer');
      expect(allow, false);
    });

    /// [statusStream getter test]
    test(
      '''after userService is constructed should able to get active status stream''',
      () async {
        // construct mocked data classes
        var cloudDatabase = CloudDatabaseMock();
        var prefs = SharedPreferencesMock();
        var statusStream = BehaviorSubject<QuerySnapshot>.seeded(null);
        // mocked tested behavior
        when(cloudDatabase.statusStream())
            .thenAnswer((realInvocation) => statusStream.stream);
        // construct tested service
        var userService =
            UserService(cloudDatabase: cloudDatabase, sharedPreferences: prefs);
        // statusStream should not be empty
        var empty = await userService.statusStream.isEmpty;
        // expected value is false
        expect(empty, false);
        // verify service call
        verify(cloudDatabase.statusStream());
      },
    );
  });
}
