import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../cloud_storage/cloud_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../locator.dart';

class AuthService {
  final _kAuthKeyName = 'authenticate';
  final database = locator<CloudDatabase>();

  SharedPreferences _sharedPreferences;

  /// initialise service
  Future<void> initAuth() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// register user with phone number [FirebaseAuth]
  Future registerUser(String mobile, BuildContext context) async {
    var _auth = FirebaseAuth.instance;

    await _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(minutes: 1),
      verificationCompleted: (authCredential) {
        print('verificationCompleted');
        _auth.signInWithCredential(authCredential).then((_) {
          // save authentication in prefs service
          saveAuthentication(auth: true);
        }).catchError(print);
      },
      verificationFailed: (authException) {
        // TODO: IMPLEMENT STACKED DIALOG SERVICE
        print('verificationFailed');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Failed to verify phone number'),
              content: Text(authException.message),
            );
          },
        );
      },
      codeSent: (verificationId, forceResendingToken) {
        // TODO: IMPLEMENT STACKED DIALOG SERVICE
        print('codeSent');
        var _codeController = TextEditingController();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Enter SMS Code'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _codeController,
                  )
                ],
              ),
              actions: [
                FlatButton(
                  child: Text('DONE'),
                  onPressed: () {
                    var auth = FirebaseAuth.instance;
                    var smsCode = _codeController.text.trim();
                    var _credential = PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: smsCode);
                    auth
                        .signInWithCredential(_credential)
                        .then((_) {})
                        .catchError(print);
                  },
                )
              ],
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        print('codeAutoRetrievalTimeout');
        print('Timeout $verificationId');
      },
    );
  }

  /// mock register user
  Future mockRegisterUser({int delay = 3, bool auth = true}) async {
    await Future.delayed(Duration(seconds: delay), () {
      saveAuthentication(auth: auth);
    });
  }

  /// add new username to firestore db user_names collection
  Future<bool> addUserName(String username) async {
    return database.addUserName(username);
  }

  /// compare username argument with user_names collection
  /// returns true if do not exists in collection, false if exists
  Future<bool> validateUserName(String username) async {
    return await database.validateUserName(username);
  }

  /// save authentication state in prefs
  void saveAuthentication({bool auth = false}) {
    _sharedPreferences.setBool(_kAuthKeyName, auth);
  }

  /// is authenticate getter
  bool get isAuthenticated =>
      _sharedPreferences.getBool(_kAuthKeyName) ?? false;
}