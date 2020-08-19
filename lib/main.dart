import 'package:flutter/material.dart';

import 'package:WhatAppClone/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff075E54),
        accentColor: Color(0xff25D366),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      routes: {'/': (BuildContext context) => HomePage()},
    );
  }
}
