import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  PermissionHandler._();

  /// request device permissions (contacts, call logs, camera)
  static Future<void> requestPermissions() async {
    // request contacts permission
    PermissionStatus contactsStatus = await Permission.contacts.request();
    while (contactsStatus != PermissionStatus.granted) {
      contactsStatus = await Permission.contacts.request();
    }
    // request camera permission
    PermissionStatus cameraStatus = await Permission.camera.request();
    while (cameraStatus != PermissionStatus.granted) {
      cameraStatus = await Permission.contacts.request();
    }
    // request phone permission
    PermissionStatus phoneStatus = await Permission.phone.request();
    while (phoneStatus != PermissionStatus.granted) {
      phoneStatus = await Permission.phone.request();
    }
  }
}
