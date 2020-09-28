import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

import '../core/routes/router.dart';
import 'api/dialogflow.dart';
import 'device/permission_service.dart';
import 'device/contacts_service.dart';
import 'auth/auth_service.dart';
import 'auth/user_service.dart';
import 'local_storage/local_database.dart';
import 'cloud_storage/cloud_database.dart';
import 'network/connectivity.dart';

import '../repositories/contacts_repo/contacts_repository.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // first party services
  locator.registerLazySingleton<Router>(() => Router());
  locator.registerLazySingleton<PermissionService>(() => PermissionService());
  locator.registerLazySingleton<UserService>(() => UserService());
  locator.registerLazySingleton<LocalDatabase>(() => LocalDatabase());
  locator.registerLazySingleton<CloudDatabase>(() => CloudDatabase());
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<DialogFlowAPI>(() => DialogFlowAPI());
  locator.registerLazySingleton<ContactsHandler>(() => ContactsHandler());
  locator
      .registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  // repos
  locator.registerLazySingleton<ContactsRepository>(() => ContactsRepository());
  // third party services (stacked)
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<SnackbarService>(() => SnackbarService());
}
