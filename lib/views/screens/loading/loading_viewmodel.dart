import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:provider/provider.dart';

import '../../../services/locator.dart';
import '../../../services/device/permission_service.dart';
import '../../../services/local_storage/user_service.dart';
import '../../../services/local_storage/db_service.dart';
import '../../../services/network/connectivity.dart';

import '../../../core/provider/main.dart';

import '../../../core/routes/navigation_service .dart';

class LoadingViewModel extends BaseViewModel {
  bool _isLight;
  bool get isLight => _isLight;

  /// call once after the model is construct
  void initalise(BuildContext context) {
    _isLight = Theme.of(context).brightness == Brightness.light;
    // evoke init tasks
    runInitTasks(context);
  }

  /// run app services initial tasks
  void runInitTasks(BuildContext context) async {
    // get all services
    final navigator = locator<NavigationService>();
    final permission = locator<PermissionService>();
    final prefs = locator<UserService>();
    final localDB = locator<DBservice>();
    // construct connectivity service
    // ignore: unused_local_variable
    final connectivity = locator<ConnectivityService>();
    // request device permissions
    await permission.requestPermissions();
    // init prefs service
    await prefs.initPrefs();
    // init local storage sqlite db
    await localDB.asyncInitDB();
    // init main model data
    await context.read<MainModel>().initModel();
    // if authenticated navigate main page, else navigate log-in page
    if (prefs.isAuthenticated) {
      // navigate main page
      navigator.navigateMainPage();
    } else {
      // navigate login page
      navigator.navigateLoginPage();
    }
  }
}
