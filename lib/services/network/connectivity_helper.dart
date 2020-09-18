import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  final StreamController<ConnectivityState> _connectivityController =
      StreamController<ConnectivityState>();

  Stream<ConnectivityState> get connectivityStream =>
      _connectivityController.stream;

  ConnectivityService() {
    initConnectivity();
  }

  // init connectivity
  void initConnectivity() async {
    // first checks for connectivity
    final result = await Connectivity().checkConnectivity();
    handleResult(result);
    Connectivity().onConnectivityChanged.listen(handleResult);
  }

  void handleResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        _connectivityController
            .add(ConnectivityState(connection: true, result: result));
        break;
      case ConnectivityResult.wifi:
        _connectivityController
            .add(ConnectivityState(connection: true, result: result));
        break;
      case ConnectivityResult.none:
        _connectivityController
            .add(ConnectivityState(connection: false, result: result));
        break;
      default:
        _connectivityController
            .add(ConnectivityState(connection: false, result: result));
    }
  }

  /// checks for internet connectivity
  /// return true for connection, false for no connection
  static Future<bool> internetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}

class ConnectivityState {
  final bool connection;
  final ConnectivityResult result;
  ConnectivityState({this.connection, this.result});
}
