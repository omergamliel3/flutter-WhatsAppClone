import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  ConnectivityState _connectivityState;
  bool get connectivity => _connectivityState.connection ?? false;
  ConnectivityResult get result => _connectivityState.result;

  // init connectivity
  Future<void> initConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    handleResult(result);
    Connectivity().onConnectivityChanged.listen(handleResult);
  }

  // handle connectivity result and update connectivity state
  void handleResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        _connectivityState =
            ConnectivityState(connection: true, result: result);
        break;
      case ConnectivityResult.wifi:
        _connectivityState =
            ConnectivityState(connection: true, result: result);
        break;
      case ConnectivityResult.none:
        _connectivityState =
            ConnectivityState(connection: false, result: result);
        break;
      default:
        _connectivityState = ConnectivityState(
            connection: false, result: ConnectivityResult.none);
    }
  }
}

class ConnectivityState {
  final bool connection;
  final ConnectivityResult result;
  ConnectivityState({this.connection, this.result});
}
