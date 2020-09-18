import 'package:get_it/get_it.dart';

import 'api/dialogflow.dart';
import 'device/permission_service.dart';
import 'device/contacts_service.dart';
import 'firebase/firestore_service.dart';
import 'firebase/auth_service.dart';
import 'local_storage/prefs_service.dart';
import 'local_storage/db_service.dart';
import 'network/connectivity.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => PermissionService());
  locator.registerLazySingleton(() => PrefsService());
  locator.registerLazySingleton(() => DBservice());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => DialogFlowAPI());
  locator.registerLazySingleton(() => ContactsHandler());
  locator.registerLazySingleton(() => ConnectivityService());
}
