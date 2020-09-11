import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:WhatsAppClone/services/local_storage/prefs_service.dart';

class AuthService {
  AuthService._();

  /// register user with phone number [FirebaseAuth]
  static Future registerUser(String mobile, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    await _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(minutes: 1),
      verificationCompleted: (PhoneAuthCredential authCredential) {
        print('verificationCompleted');
        _auth.signInWithCredential(authCredential).then((_) {
          // save authentication in prefs service
          PrefsService.saveAuthentication(auth: true);
        }).catchError((e) {
          print(e);
        });
      },
      verificationFailed: (FirebaseAuthException authException) {
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
      codeSent: (String verificationId, int forceResendingToken) {
        print('codeSent');
        TextEditingController _codeController = TextEditingController();
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
                    FirebaseAuth auth = FirebaseAuth.instance;
                    String smsCode = _codeController.text.trim();
                    AuthCredential _credential = PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: smsCode);
                    auth
                        .signInWithCredential(_credential)
                        .then((_) {})
                        .catchError((e) {
                      print(e);
                    });
                  },
                )
              ],
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('codeAutoRetrievalTimeout');
        print('Timeout ' + verificationId);
      },
    );
  }

  /// mock register user
  static Future mockRegisterUser({int delay = 3, bool auth = true}) async {
    await Future.delayed(Duration(seconds: delay), () {
      PrefsService.saveAuthentication(auth: auth);
    });
  }
}
