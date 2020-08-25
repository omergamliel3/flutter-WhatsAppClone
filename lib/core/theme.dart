import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/constants.dart';

// light theme data
ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Color(0xff25D366)));

// dark theme data
ThemeData darkTheme = ThemeData.dark().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Color(0xff075E54)));
