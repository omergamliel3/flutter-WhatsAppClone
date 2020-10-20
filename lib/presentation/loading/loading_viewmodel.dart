import 'package:WhatsAppClone/services/firebase/push_notification_service.dart';
import 'package:stacked/stacked.dart';

import '../../locator.dart';
import '../../services/device/permission_service.dart';
import '../../services/auth/user_service.dart';
import '../../core/network/network_info.dart';
import '../../services/auth/auth_service.dart';

import '../../core/routes/router.dart';

import '../../data/repositories/contacts_repository.dart';

class LoadingViewModel extends BaseViewModel {
  // get all services
  final router = locator<Router>();
  final permission = locator<PermissionService>();
  final user = locator<UserService>();
  final auth = locator<AuthService>();
  final contactsRepo = locator<ContactsRepository>();
  final connectivity = locator<NetworkInfo>();
  final fcm = locator<PushNotificationService>();

  /// call once after the model is construct
  Future<void> initalise() async {
    // evoke init tasks
    await runInitTasks();
  }

  /// run app services initial tasks
  Future<void> runInitTasks() async {
    // init firebase cloud messaging
    await fcm.initialise();
    // init connectivity service
    await connectivity.initConnectivity();
    // request device permissions
    await permission.requestPermissions();
    // init user service
    await user.initUserService();
    // init contacts repo
    await contactsRepo.initalise();
    // if authenticated navigate main page, else navigate log-in page
    if (auth.isAuthenticated) {
      // navigate main page
      router.navigateMainPage();
    } else {
      // navigate login page
      router.navigateLoginPage();
    }
  }
}
