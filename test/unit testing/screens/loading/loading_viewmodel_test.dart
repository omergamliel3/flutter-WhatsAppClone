import 'package:WhatsAppClone/core/routes/navigation_service%20.dart';
import 'package:WhatsAppClone/repositories/contacts_repo/contacts_repository.dart';
import 'package:WhatsAppClone/services/auth/auth_service.dart';
import 'package:WhatsAppClone/services/auth/user_service.dart';
import 'package:WhatsAppClone/services/device/permission_service.dart';
import 'package:WhatsAppClone/services/local_storage/db_service.dart';
import 'package:WhatsAppClone/services/locator.dart';
import 'package:WhatsAppClone/services/network/connectivity.dart';
import 'package:WhatsAppClone/views/screens/loading/loading_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserServiceMock extends Mock implements UserService {}

class NavigationServiceMock extends Mock implements NavigationService {}

class PermissionServiceMock extends Mock implements PermissionService {}

class DBserviceMock extends Mock implements DBservice {}

class AuthServiceMock extends Mock implements AuthService {}

class ContactsRepositoryMock extends Mock implements ContactsRepository {}

class ConnectivityServiceMock extends Mock implements ConnectivityService {}

void main() {
  group('LoadingViewModel Test', () {
    group('initialise model', () {
      test('''
 After constructed call initialise method to initial all services,
 then navigate main page if user authenticated, if not navigate login page''',
          () async {
        // construct mock services
        var navigator = NavigationServiceMock();
        var localDb = DBserviceMock();
        var permmision = PermissionServiceMock();
        var user = UserServiceMock();
        var auth = AuthServiceMock();
        var repo = ContactsRepositoryMock();
        var connectivity = ConnectivityServiceMock();
        // GetIt register services
        locator.registerSingleton<NavigationService>(navigator);
        locator.registerSingleton<DBservice>(localDb);
        locator.registerSingleton<PermissionService>(permmision);
        locator.registerSingleton<UserService>(user);
        locator.registerSingleton<AuthService>(auth);
        locator.registerSingleton<ContactsRepository>(repo);
        locator.registerSingleton<ConnectivityService>(connectivity);

        // construct viewmodel
        var model = LoadingViewModel();
        // call model initalise
        await model.initalise();

        // verify async services and repo init calls
        verifyInOrder([
          connectivity.initConnectivity(),
          localDb.asyncInitDB(),
          permmision.requestPermissions(),
          user.initUserService(),
          auth.initAuth(),
          repo.initalise(),
          navigator.navigateLoginPage()
        ]);
      });
    });
  });
}
