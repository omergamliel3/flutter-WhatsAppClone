import 'package:stacked/stacked.dart';
import 'package:call_log/call_log.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class CallsViewModel extends BaseViewModel {
  // return device call Logs data
  Future<Iterable<CallLogEntry>> getCallLogs() {
    return CallLog.get();
  }

  // launch device phone call
  void launchCall(String number) {
    print('launchCall');
    url_launcher.launch('tel:$number');
  }
}
