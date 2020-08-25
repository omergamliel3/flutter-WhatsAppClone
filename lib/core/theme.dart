import 'package:flutter/material.dart';

// light theme data
ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: Color(0xff075E54),
    accentColor: Color(0xff25D366),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Color(0xff25D366)));

// dark theme data
ThemeData darkTheme = ThemeData.dark().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Color(0xff075E54)));
