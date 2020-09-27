import 'package:WhatsAppClone/views/screens/calls/calls_viewmodel.dart';
import 'package:call_log/call_log.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// mock UrlLauncher calss from url_launcher methods
class UrlLauncher {
  // launch device phone call
  Future<bool> launchCall(String number) async {
    if (await url_launcher.canLaunch('tel:$number')) {
      url_launcher.launch('tel:$number');
      return true;
    }
    return false;
  }
}

class UrlLauncherMock extends Mock implements UrlLauncher {}

class CallsViewModelMock extends Mock implements CallsViewModel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CallsViewModel Test - ', () {
    final launcher = UrlLauncherMock();

    /// [Launch call method test]
    test('Launch call', () async {
      when(launcher.launchCall('0528584833'))
          .thenAnswer((realInvocation) => Future.value(true));
      expect(await launcher.launchCall('0528584833'), true);
    });

    /// [getCallLogs method test]
    test(
        'when invoke call logs from model should be return a list of call logs',
        () async {
      final model = CallsViewModelMock();
      when(model.getCallLogs())
          .thenAnswer((realInvocation) => Future<Iterable<CallLogEntry>>.value([
                CallLogEntry(name: 'OMER'),
                CallLogEntry(name: 'TAL'),
                CallLogEntry(name: 'OHAD')
              ]));
      var logs = await model.getCallLogs();
      expect(logs.length, 3);
    });
  });
}
