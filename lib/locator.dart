import 'package:connectivity/connectivity.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

// services
import 'core/routes/router.dart';
import 'services/api/dialogflow.dart';
import 'services/device/permission_service.dart';
import 'services/device/contacts_service.dart';
import 'services/auth/auth_service.dart';
import 'services/auth/user_service.dart';
import 'services/firebase/analytics_service.dart';
import 'core/network/network_info.dart';

// data
import 'data/datasources/cloud_database.dart';
import 'data/datasources/local_database.dart';
import 'data/repositories/contacts_repository.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // data
  final _localDatabase = LocalDatabase();
  final _cloudDatabase = CloudDatabase();
  final _contactsService = ContactsService();
  final _contactsHandler = ContactsHandler(_contactsService);
  final _sharedPreferences = await SharedPreferences.getInstance();

  locator.registerLazySingleton<ContactsRepository>(() => ContactsRepository(
      localDatabase: _localDatabase, contactHandler: _contactsHandler));

  // services

  locator.registerLazySingleton<Router>(() => Router());
  locator.registerLazySingleton<PermissionService>(() => PermissionService());
  locator.registerLazySingleton<UserService>(() => UserService(
      cloudDatabase: _cloudDatabase, sharedPreferences: _sharedPreferences));
  locator.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  locator.registerLazySingleton<AuthService>(() => AuthService(
      cloudDatabase: _cloudDatabase, sharedPreferences: _sharedPreferences));
  locator.registerLazySingleton<DialogFlowAPI>(() => DialogFlowAPI());

  // core
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfo(Connectivity()));

  // third party services (stacked services)
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<SnackbarService>(() => SnackbarService());
}
