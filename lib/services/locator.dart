import 'package:get_it/get_it.dart';

import '../core/routes/navigation_service%20.dart';
import 'api/dialogflow.dart';
import 'device/permission_service.dart';
import 'device/contacts_service.dart';
import 'firebase/firestore_service.dart';
import 'firebase/auth_service.dart';
import 'local_storage/user_service.dart';
import 'local_storage/db_service.dart';
import 'network/connectivity.dart';

import '../repositories/contacts_repo/contacts_repository.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => PermissionService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => DBservice());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => DialogFlowAPI());
  locator.registerLazySingleton(() => ContactsHandler());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => ContactsRepository());
}
