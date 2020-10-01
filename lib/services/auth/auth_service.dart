import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../data/cloud_storage/cloud_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';
import '../locator.dart';

class AuthService {
  AuthService({@required this.cloudDatabase, @required this.sharedPreferences});
  final _kAuthKeyName = 'authenticate';
  final CloudDatabase cloudDatabase;
  final SharedPreferences sharedPreferences;
  final dialogService = locator<DialogService>();

  /// register user with phone number [FirebaseAuth]
  Future registerUser(String mobile) async {
    var _auth = FirebaseAuth.instance;

    await _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(minutes: 1),
      verificationCompleted: (authCredential) {
        _auth.signInWithCredential(authCredential).then((_) {
          // save authentication in prefs service
          saveAuthentication(auth: true);
        }).catchError(print);
      },
      verificationFailed: (authException) {
        dialogService.showDialog(
            title: 'Failed to verify phone number',
            description: authException.message);
      },
      codeSent: (verificationId, forceResendingToken) {
        // TODO: IMPLEMENT STACKED DIALOG SERVICE
        //var _codeController = TextEditingController();
        // showDialog(
        //   context: context,
        //   barrierDismissible: false,
        //   builder: (context) {
        //     return AlertDialog(
        //       title: Text('Enter SMS Code'),
        //       content: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           TextField(
        //             controller: _codeController,
        //           )
        //         ],
        //       ),
        //       actions: [
        //         FlatButton(
        //           child: Text('DONE'),
        //           onPressed: () {
        //             var auth = FirebaseAuth.instance;
        //             var smsCode = _codeController.text.trim();
        //             var _credential = PhoneAuthProvider.credential(
        //                 verificationId: verificationId, smsCode: smsCode);
        //             auth
        //                 .signInWithCredential(_credential)
        //                 .then((_) {})
        //                 .catchError(print);
        //           },
        //         )
        //       ],
        //     );
        //   },
        // );
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
    return cloudDatabase.addUserName(username);
  }

  /// compare username argument with user_names collection
  /// returns true if do not exists in collection, false if exists
  Future<bool> validateUserName(String username) async {
    return await cloudDatabase.validateUserName(username);
  }

  /// save authentication state in prefs
  void saveAuthentication({bool auth = false}) {
    sharedPreferences.setBool(_kAuthKeyName, auth);
  }

  /// is authenticate getter
  bool get isAuthenticated => sharedPreferences.getBool(_kAuthKeyName) ?? false;
}
