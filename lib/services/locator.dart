import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

// services
import '../core/routes/router.dart';
import 'api/dialogflow.dart';
import 'device/permission_service.dart';
import 'device/contacts_service.dart';
import 'auth/auth_service.dart';
import 'auth/user_service.dart';
import 'firebase/analytics_service.dart';
import 'network/connectivity.dart';

// repos
import '../repositories/contacts_repository.dart';

// data layer
import '../data/cloud_storage/cloud_database.dart';
import '../data/local_storage/local_database.dart';

GetIt locator = GetIt.instance;

void setupLocator() async {
  // initiate data layer

  var _localDatabase = LocalDatabase();
  var _cloudDatabase = CloudDatabase();
  var _contactsHandler = ContactsHandler();
  var _sharedPreferences = await SharedPreferences.getInstance();

  // first party services

  // router
  locator.registerLazySingleton<Router>(() => Router());
  // permission
  locator.registerLazySingleton<PermissionService>(() => PermissionService());
  // user
  locator.registerLazySingleton<UserService>(() => UserService(
      cloudDatabase: _cloudDatabase, sharedPreferences: _sharedPreferences));
  // analytics
  locator.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  // auth
  locator.registerLazySingleton<AuthService>(() => AuthService(
      cloudDatabase: _cloudDatabase, sharedPreferences: _sharedPreferences));
  // dailog flow api
  locator.registerLazySingleton<DialogFlowAPI>(() => DialogFlowAPI());
  // connectivity
  locator
      .registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  // repository
  locator.registerLazySingleton<ContactsRepository>(() => ContactsRepository(
      localDatabase: _localDatabase, contactHandler: _contactsHandler));

  // third party services (stacked services)
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<SnackbarService>(() => SnackbarService());
}
