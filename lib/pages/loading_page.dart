import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:WhatsAppClone/core/constants.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    // invoke runInitTasks at startup
    runInitTasks();
    super.initState();
  }

  // run init tasks method
  void runInitTasks() async {
    // request contracts, camera permissions
    PermissionStatus locationStatus = await Permission.contacts.request();
    while (locationStatus != PermissionStatus.granted) {
      locationStatus = await Permission.contacts.request();
    }
    PermissionStatus cameraStatus = await Permission.camera.request();
    while (cameraStatus != PermissionStatus.granted) {
      cameraStatus = await Permission.contacts.request();
    }
    await Future.delayed(Duration(seconds: 2));
    // navigate main page
    Navigator.pushReplacementNamed(context, '/login_page');
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
