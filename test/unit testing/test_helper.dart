import 'package:WhatsAppClone/core/routes/router.dart';
import 'package:WhatsAppClone/repositories/contacts_repo/contacts_repository.dart';
import 'package:WhatsAppClone/services/api/dialogflow.dart';
import 'package:WhatsAppClone/services/auth/auth_service.dart';
import 'package:WhatsAppClone/services/auth/user_service.dart';
import 'package:WhatsAppClone/services/cloud_storage/cloud_database.dart';
import 'package:WhatsAppClone/services/device/contacts_service.dart';
import 'package:WhatsAppClone/services/device/permission_service.dart';
import 'package:WhatsAppClone/services/firebase/analytics_service.dart';
import 'package:WhatsAppClone/services/local_storage/local_database.dart';
import 'package:WhatsAppClone/services/locator.dart';
import 'package:WhatsAppClone/services/network/connectivity.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

class RouterServiceMock extends Mock implements Router {}

class PermissionServiceMock extends Mock implements PermissionService {}

class UserServiceMock extends Mock implements UserService {}

class CloudDatabaseMock extends Mock implements CloudDatabase {}

class LocalDatabaseMock extends Mock implements LocalDatabase {}

class AuthServiceMock extends Mock implements AuthService {}

class DialogFlowAPIMock extends Mock implements DialogFlowAPI {}

class ContactsHandlerMock extends Mock implements ContactsHandler {}

class ConnectivityServiceMock extends Mock implements ConnectivityService {}

class ContactsRepositoryMock extends Mock implements ContactsRepository {}

class AnalyticsServiceMock extends Mock implements AnalyticsService {}

class DialogServiceMock extends Mock implements DialogService {}

class NavigationServiceMock extends Mock implements NavigationService {}

class SnackbarServiceMock extends Mock implements SnackbarService {}

Router getAndRegisterRouterServiceMock() {
  _removeRegistrationIfExists<Router>();
  var service = RouterServiceMock();
  locator.registerSingleton<Router>(service);
  return service;
}

PermissionService getAndRegisterPermissionServiceMock() {
  _removeRegistrationIfExists<PermissionService>();
  var service = PermissionServiceMock();
  locator.registerSingleton<PermissionService>(service);
  return service;
}

UserService getAndRegisterUserServiceMock() {
  _removeRegistrationIfExists<UserService>();
  var service = UserServiceMock();
  locator.registerSingleton<UserService>(service);
  return service;
}

CloudDatabase getAndRegisterCloudDatabaseMock() {
  _removeRegistrationIfExists<CloudDatabase>();
  var service = CloudDatabaseMock();
  locator.registerSingleton<CloudDatabase>(service);
  return service;
}

LocalDatabase getAndRegisterLocalDatabaseMock() {
  _removeRegistrationIfExists<LocalDatabase>();
  var service = LocalDatabaseMock();
  locator.registerSingleton<LocalDatabase>(service);
  return service;
}

AuthService getAndRegisterAuthServiceMock() {
  _removeRegistrationIfExists<AuthService>();
  var service = AuthServiceMock();
  locator.registerSingleton<AuthService>(service);
  return service;
}

DialogFlowAPI getAndRegisterDialogFlowAPIMock() {
  _removeRegistrationIfExists<DialogFlowAPI>();
  var service = DialogFlowAPIMock();
  locator.registerSingleton<DialogFlowAPI>(service);
  return service;
}

ContactsHandler getAndRegisterContactsHandlerMock() {
  _removeRegistrationIfExists<ContactsHandler>();
  var service = ContactsHandlerMock();
  locator.registerSingleton<ContactsHandler>(service);
  return service;
}

ConnectivityService getAndRegisterConnectivityServiceMock() {
  _removeRegistrationIfExists<ConnectivityService>();
  var service = ConnectivityServiceMock();
  locator.registerSingleton<ConnectivityService>(service);
  return service;
}

ContactsRepository getAndRegisterContactsRepositoryMock() {
  _removeRegistrationIfExists<ContactsRepository>();
  var service = ContactsRepositoryMock();
  locator.registerSingleton<ContactsRepository>(service);
  return service;
}

DialogService getAndRegisterDialogServiceMock() {
  _removeRegistrationIfExists<DialogService>();
  var service = DialogServiceMock();
  locator.registerSingleton<DialogService>(service);
  return service;
}

NavigationService getAndRegisterNavigationServiceMock() {
  _removeRegistrationIfExists<NavigationService>();
  var service = NavigationServiceMock();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

SnackbarService getAndRegisterSnackbarServiceMock() {
  _removeRegistrationIfExists<SnackbarService>();
  var service = SnackbarServiceMock();
  locator.registerSingleton<SnackbarService>(service);
  return service;
}

AnalyticsService getAndRegisterAnalyticsServiceMock() {
  _removeRegistrationIfExists<AnalyticsService>();
  var service = AnalyticsServiceMock();
  locator.registerSingleton<AnalyticsService>(service);
  return service;
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
