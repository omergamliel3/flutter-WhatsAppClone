import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// request device permissions (contacts, call logs, camera)
  Future<void> requestPermissions() async {
    // request contacts permission
    var contactsStatus = await Permission.contacts.request();
    while (contactsStatus != PermissionStatus.granted) {
      contactsStatus = await Permission.contacts.request();
    }
    // request camera permission
    var cameraStatus = await Permission.camera.request();
    while (cameraStatus != PermissionStatus.granted) {
      cameraStatus = await Permission.contacts.request();
    }
    // request phone permission
    var phoneStatus = await Permission.phone.request();
    while (phoneStatus != PermissionStatus.granted) {
      phoneStatus = await Permission.phone.request();
    }
  }
}
