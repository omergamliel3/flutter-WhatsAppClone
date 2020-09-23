import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _kAuthKeyName = 'authenticate';
  final _kUserNamesCollection = 'user_names';
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
    try {
      // add new username object to user_names db collection
      var docRef = await FirebaseFirestore.instance
          .collection(_kUserNamesCollection)
          .add({'username': username});

      print('created new firestore recored with id: ${docRef.id}');
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// compare username argument with user_names collection
  /// returns true if do not exists in collection, false if exists
  Future<bool> validateUserName(String username) async {
    try {
      // get query db collection
      var query = await FirebaseFirestore.instance
          .collection(_kUserNamesCollection)
          .get();
      // get query docs
      var usernames = query.docs;
      // username flag
      var flag = false;
      // iterate usernames query docs list
      for (var user in usernames) {
        var name = user.data()['username'] as String;
        if (name.toLowerCase() == username.toLowerCase()) {
          flag = true;
          break;
        }
      }

      // username is taken, not valid.
      if (flag) {
        return false;
      }
      // username is not taken, valid.
      return true;
    }
    // return false if catch error
    on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// save authentication state in prefs
  void saveAuthentication({bool auth = false}) {
    _sharedPreferences.setBool(_kAuthKeyName, auth);
  }

  /// is authenticate getter
  bool get isAuthenticated =>
      _sharedPreferences.getBool(_kAuthKeyName) ?? false;
}
