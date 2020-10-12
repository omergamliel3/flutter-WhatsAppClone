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
      var connectivityStream = StreamController<ConnectivityResult>();
      when(connectivityMock.onConnectivityChanged)
          .thenAnswer((realInvocation) => connectivityStream.stream);
      // construct tested service
      var connectivityService = NetworkInfo(connectivityMock);
      // init tested service
      await connectivityService.initConnectivity();
      var connectivity = connectivityService.connectivity;
      var state = connectivityService.result;
      // expected values
      expect(state, ConnectivityResult.mobile);
      expect(connectivity, true);

      // raise onConnectivityChanged event
      connectivityStream.add(ConnectivityResult.none);
      await Future.delayed(Duration(milliseconds: 1000));
      var newConnectivity = connectivityService.connectivity;
      var newState = connectivityService.result;
      // expected values
      expect(newState, ConnectivityResult.none);
      expect(newConnectivity, false);
    });
  });
}
