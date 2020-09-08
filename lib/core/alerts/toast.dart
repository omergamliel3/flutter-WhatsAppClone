import 'package:fluttertoast/fluttertoast.dart';

/// show toast
void showToast(String message, Toast length) {
  Fluttertoast.showToast(
    msg: message ?? '',
    toastLength: length,
    gravity: ToastGravity.BOTTOM,
  );
}
