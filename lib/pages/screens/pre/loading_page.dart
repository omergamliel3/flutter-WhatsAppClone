import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:WhatsAppClone/services/device/permission_handler.dart';

import 'package:WhatsAppClone/core/provider/main.dart';

import 'package:WhatsAppClone/services/local_storage/prefs_service.dart';
import 'package:WhatsAppClone/services/local_storage/db_service.dart';

import 'package:WhatsAppClone/helpers/navigator_helper.dart';

import 'package:WhatsAppClone/core/shared/constants.dart';

import 'package:WhatsAppClone/core/widgets/ui_elements/spinkit_loading_indicator.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // invoke runInitTasks at startup
    runInitTasks();
    super.initState();
  }

  // run init tasks before navigate main page
  void runInitTasks() async {
    // request device permissions
    await PermissionHandler.requestPermissions();
    // init prefs service
    await PrefsService.initPrefs();
    // init local storage sqlite db
    await DBservice.asyncInitDB();
    // init main model data
    await context.read<MainModel>().initModel(context);
    // if authenticated navigate main page, else navigate log-in page
    if (PrefsService.isAuthenticated) {
      // navigate main page
      NavigatorHelper.navigateMainPage(context);
    } else {
      // navigate login page
      NavigatorHelper.navigateLoginPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLight = Theme.of(context).brightness == Brightness.light;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: isLight ? Colors.white : Colors.grey[900],
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                    flex: 5,
                    child: Image.asset(
                      iconAssetName,
                      fit: BoxFit.contain,
                      height: 100,
                      width: 100,
                    )),
                Expanded(flex: 1, child: SpinkitLoadingIndicator()),
                Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'from',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'FACEBOOK',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: isLight ? Colors.blue : Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        )
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
