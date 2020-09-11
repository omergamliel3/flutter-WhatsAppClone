import 'package:WhatsAppClone/helpers/navigator_helper.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:WhatsAppClone/core/provider/main.dart';
import 'package:WhatsAppClone/core/shared/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainModel(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WhatsApp',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          routes: Routes.routes,
          onGenerateRoute: (RouteSettings settings) {
            return Routes.onGenerateRoute(settings, context);
          },
        );
      },
    );
  }
}
