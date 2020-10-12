import 'package:stacked/stacked.dart';

import '../../../locator.dart';
import '../../../services/firebase/analytics_service.dart';

import 'package:call_log/call_log.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class CallsViewModel extends BaseViewModel {
  final analytics = locator<AnalyticsService>();
  // return device call Logs data
  Future<Iterable<CallLogEntry>> getCallLogs() {
    return CallLog.get();
  }

  // launch device phone call
  void launchCall(String number) async {
    if (await url_launcher.canLaunch('tel:$number')) {
      analytics.logCallEvent();
      url_launcher.launch('tel:$number');
    }
  }
}
