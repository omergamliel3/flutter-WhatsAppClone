import 'dart:async';

import 'package:WhatsAppClone/core/network/network_info.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ConnectivityMock extends Mock implements Connectivity {}

void main() {
  // construct mocked class instance
  ConnectivityMock connectivityMock;
  // run before every test
  setUp(() {
    connectivityMock = ConnectivityMock();
  });
  group('Connectivity service tests - ', () {
    test(
        '''when initConnectivity should checkConnectivity and pass the result to handleResult, then should listen to onConnectivityChanged (handleResult for each event)''',
        () async {
      // mock connectity behavior
      when(connectivityMock.checkConnectivity()).thenAnswer(
          (realInvocation) => Future.value(ConnectivityResult.mobile));
      // mock connectivityStream controller (instead of connectivity)
      final connectivityStream = StreamController<ConnectivityResult>();
      when(connectivityMock.onConnectivityChanged)
          .thenAnswer((realInvocation) => connectivityStream.stream);
      // construct tested service
      final connectivityService = NetworkInfo(connectivityMock);
      // init tested service
      await connectivityService.initConnectivity();
      final connectivity = connectivityService.connectivity;
      final state = connectivityService.result;
      // expected values
      expect(state, ConnectivityResult.mobile);
      expect(connectivity, true);

      // raise onConnectivityChanged event
      connectivityStream.add(ConnectivityResult.none);
      await Future.delayed(const Duration(milliseconds: 1000));
      final newConnectivity = connectivityService.connectivity;
      final newState = connectivityService.result;
      // expected values
      expect(newState, ConnectivityResult.none);
      expect(newConnectivity, false);
    });
  });
}
