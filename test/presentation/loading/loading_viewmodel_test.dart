import 'package:WhatsAppClone/presentation/loading/loading_viewmodel.dart';
import 'package:WhatsAppClone/services/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_helper.dart';

void main() {
  // construct mock services
  Router router;
  PermissionService permmision;
  UserService user;
  AuthService auth;
  ContactsRepository repo;
  NetworkInfo connectivity;
  setUp(() {
    router = getAndRegisterRouterServiceMock();
    //localDb = getAndRegisterLocalDatabaseMock();
    permmision = getAndRegisterPermissionServiceMock();
    user = getAndRegisterUserServiceMock();
    auth = getAndRegisterAuthServiceMock();
    repo = getAndRegisterContactsRepositoryMock();
    connectivity = getAndRegisterConnectivityServiceMock();
  });
  group('LoadingViewModel Test', () {
    /// [initalise method method test (with auth)]
    test('initialise with authentication, navigate main page', () async {
      // mock authentication to true
      when(auth.isAuthenticated).thenAnswer((realInvocation) => true);
      // construct viewmodel
      final model = LoadingViewModel();
      // call model initalise
      await model.initalise();
      // authentication
      expect(model.auth.isAuthenticated, true);
      // verify async services and repo init calls
      verifyInOrder([
        connectivity.initConnectivity(),
        permmision.requestPermissions(),
        user.initUserService(),
        repo.initalise(),
        router.navigateMainPage()
      ]);
      verifyNever(router.navigateLoginPage());
    });

    /// [initalise method method test (without auth)]
    test('initialise without authentication, navigate login page', () async {
      // mock authentication to false
      when(auth.isAuthenticated).thenAnswer((realInvocation) => false);
      // construct viewmodel
      final model = LoadingViewModel();
      // call model initalise
      await model.initalise();
      // not authentication
      expect(model.auth.isAuthenticated, false);
      // verify async services and repo init calls
      verifyInOrder([
        connectivity.initConnectivity(),
        permmision.requestPermissions(),
        user.initUserService(),
        repo.initalise(),
        router.navigateLoginPage()
      ]);
      verifyNever(router.navigateMainPage());
    });
  });
}
