import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kUserNamesCollection = 'user_names';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPreferences _sharedPreferences;

  PushNotificationService(this._sharedPreferences);

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions();
    }

    _fcm.configure(
      onMessage: (message) async {
        print('OnMessage: $message');
      },
      onLaunch: (message) async {
        print('onLaunch: $message');
      },
      onResume: (message) async {
        print('onResume: $message');
      },
    );
  }

  // save device token in firestore db
  Future saveDeviceToken() async {
    // Get the token for this device
    final fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      final uid = _sharedPreferences.getString('uid');
      _firestore
          .collection(_kUserNamesCollection)
          .doc(uid)
          .update({'fcm_token': fcmToken});
    }
  }
}
