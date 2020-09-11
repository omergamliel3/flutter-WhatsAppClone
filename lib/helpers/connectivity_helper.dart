import 'dart:io';

class ConnectivityHelper {
  ConnectivityHelper._();

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
