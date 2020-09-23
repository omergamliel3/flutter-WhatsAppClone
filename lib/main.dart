import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'services/locator.dart';

import 'core/provider/main.dart';
import 'core/shared/theme.dart';

import 'core/routes/navigation_service .dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
        create: (_) => MainModel(),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'WhatsApp',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.dark,
            navigatorKey: locator<NavigationService>().navigatorKey,
            onGenerateRoute: locator<NavigationService>().onGenerateRoute,
          );
        });
  }
}
