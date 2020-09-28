import 'package:firebase_analytics/firebase_analytics.dart';

// ignore: avoid_classes_with_only_static_members
class AnalyticsService {
  static Future<void> logMsgEvent(int length) async {
    await FirebaseAnalytics()
        .logEvent(name: 'message_send', parameters: {'message_length': length});
  }

  static Future<void> logCreateNewContactEvent() async {
    await FirebaseAnalytics()
        .logEvent(name: 'create_new_contact', parameters: null);
  }

  static Future<void> logCallEvent() async {
    await FirebaseAnalytics().logEvent(name: 'call_made', parameters: null);
  }

  static Future<void> logStatusEvent(int length) async {
    await FirebaseAnalytics()
        .logEvent(name: 'status_send', parameters: {'status_length': length});
  }
}
