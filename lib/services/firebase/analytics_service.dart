import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  Future<void> logMsgEvent(int length) async {
    await FirebaseAnalytics()
        .logEvent(name: 'message_send', parameters: {'message_length': length});
  }

  Future<void> logCreateNewContactEvent() async {
    await FirebaseAnalytics().logEvent(name: 'create_new_contact');
  }

  Future<void> logCallEvent() async {
    await FirebaseAnalytics().logEvent(name: 'call_made');
  }

  Future<void> logStatusEvent(int length) async {
    await FirebaseAnalytics()
        .logEvent(name: 'status_send', parameters: {'status_length': length});
  }
}
