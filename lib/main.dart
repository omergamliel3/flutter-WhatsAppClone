import 'package:WhatsAppClone/pages/login_page.dart';
import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/theme.dart';

import 'package:WhatsAppClone/pages/loading_page.dart';
import 'package:WhatsAppClone/pages/main_page.dart';

void main() {
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
      routes: {
        '/': (BuildContext context) => LoadingPage(),
        '/login_page': (BuildContext context) => LoginPage(),
        '/main_page': (BuildContext context) => MainPage()
      },
    );
  }
}
