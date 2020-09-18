import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/provider/main.dart';
import 'core/shared/theme.dart';

import 'helpers/navigator_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel(),
      builder: (context, child) {
        return Selector<MainModel, bool>(
          selector: (context, model) => model.isLight,
          builder: (context, value, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'WhatsApp',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: value ?? ThemeMode.dark,
              onGenerateRoute: Routes.onGenerateRoute,
            );
          },
        );
      },
    );
  }
}
