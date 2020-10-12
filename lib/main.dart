import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:stacked_services/stacked_services.dart';

import 'locator.dart';

import 'core/shared/theme.dart';

import 'core/routes/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: locator<Router>().onGenerateRoute,
    );
  }
}
