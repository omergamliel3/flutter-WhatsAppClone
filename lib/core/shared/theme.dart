import 'package:flutter/material.dart';
import 'constants.dart';

// light theme data
ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xff25D366)));

// dark theme data
ThemeData darkTheme = ThemeData.dark().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xff075E54)));
