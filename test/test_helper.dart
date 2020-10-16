import 'package:WhatsAppClone/services/index.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

class RouterServiceMock extends Mock implements Router {}

class PermissionServiceMock extends Mock implements PermissionService {}

class UserServiceMock extends Mock implements UserService {}

class AuthServiceMock extends Mock implements AuthService {}

class DialogFlowAPIMock extends Mock implements DialogFlowAPI {}

class NetworkInfoMock extends Mock implements NetworkInfo {}

class ContactsRepositoryMock extends Mock implements ContactsRepository {}

class AnalyticsServiceMock extends Mock implements AnalyticsService {}

class DialogServiceMock extends Mock implements DialogService {}

class NavigationServiceMock extends Mock implements NavigationService {}

class SnackbarServiceMock extends Mock implements SnackbarService {}

Router getAndRegisterRouterServiceMock() {
  _removeRegistrationIfExists<Router>();
  final service = RouterServiceMock();
  locator.registerSingleton<Router>(service);
  return service;
}

PermissionService getAndRegisterPermissionServiceMock() {
  _removeRegistrationIfExists<PermissionService>();
  final service = PermissionServiceMock();
  locator.registerSingleton<PermissionService>(service);
  return service;
}

UserService getAndRegisterUserServiceMock() {
  _removeRegistrationIfExists<UserService>();
  final service = UserServiceMock();
  locator.registerSingleton<UserService>(service);
  return service;
}

AuthService getAndRegisterAuthServiceMock() {
  _removeRegistrationIfExists<AuthService>();
  final service = AuthServiceMock();
  locator.registerSingleton<AuthService>(service);
  return service;
}

DialogFlowAPI getAndRegisterDialogFlowAPIMock() {
  _removeRegistrationIfExists<DialogFlowAPI>();
  final service = DialogFlowAPIMock();
  locator.registerSingleton<DialogFlowAPI>(service);
  return service;
}

NetworkInfo getAndRegisterConnectivityServiceMock() {
  _removeRegistrationIfExists<NetworkInfo>();
  final service = NetworkInfoMock();
  locator.registerSingleton<NetworkInfo>(service);
  return service;
}

ContactsRepository getAndRegisterContactsRepositoryMock() {
  _removeRegistrationIfExists<ContactsRepository>();
  final service = ContactsRepositoryMock();
  locator.registerSingleton<ContactsRepository>(service);
  return service;
}

DialogService getAndRegisterDialogServiceMock() {
  _removeRegistrationIfExists<DialogService>();
  final service = DialogServiceMock();
  locator.registerSingleton<DialogService>(service);
  return service;
}

NavigationService getAndRegisterNavigationServiceMock() {
  _removeRegistrationIfExists<NavigationService>();
  final service = NavigationServiceMock();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

SnackbarService getAndRegisterSnackbarServiceMock() {
  _removeRegistrationIfExists<SnackbarService>();
  final service = SnackbarServiceMock();
  locator.registerSingleton<SnackbarService>(service);
  return service;
}

AnalyticsService getAndRegisterAnalyticsServiceMock() {
  _removeRegistrationIfExists<AnalyticsService>();
  final service = AnalyticsServiceMock();
  locator.registerSingleton<AnalyticsService>(service);
  return service;
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

// ContactsHandler getAndRegisterContactsHandlerMock() {
//   _removeRegistrationIfExists<ContactsHandler>();
//   var service = ContactsHandlerMock();
//   locator.registerSingleton<ContactsHandler>(service);
//   return service;
// }

// CloudDatabase getAndRegisterCloudDatabaseMock() {
//   _removeRegistrationIfExists<CloudDatabase>();
//   var service = CloudDatabaseMock();
//   locator.registerSingleton<CloudDatabase>(service);
//   return service;
// }

// LocalDatabase getAndRegisterLocalDatabaseMock() {
//   _removeRegistrationIfExists<LocalDatabase>();
//   var service = LocalDatabaseMock();
//   locator.registerSingleton<LocalDatabase>(service);
//   return service;
// }
