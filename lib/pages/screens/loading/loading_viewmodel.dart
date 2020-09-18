import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:provider/provider.dart';

import '../../../services/locator.dart';
import '../../../services/device/permission_service.dart';
import '../../../services/local_storage/prefs_service.dart';
import '../../../services/local_storage/db_service.dart';
import '../../../services/network/connectivity.dart';

import '../../../core/provider/main.dart';

import '../../../helpers/navigator_helper.dart';

class LoadingViewModel extends BaseViewModel {
  // Class Attributes
  bool _isLight;
  bool get isLight => _isLight;
  BuildContext _context;

  /// call once after the model is construct
  void initalise(BuildContext context) {
    // set context
    _context = context;
    // set isLight
    _isLight = Theme.of(_context).brightness == Brightness.light;
    // evoke init tasks
    runInitTasks();
  }

  /// run app services initial tasks
  void runInitTasks() async {
    // get all services
    final permission = locator<PermissionService>();
    final prefs = locator<PrefsService>();
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
    await _context.read<MainModel>().initModel();
    // if authenticated navigate main page, else navigate log-in page
    if (prefs.isAuthenticated) {
      // navigate main page
      Routes.navigateMainPage(_context);
    } else {
      // navigate login page
      Routes.navigateLoginPage(_context);
    }
  }
}
