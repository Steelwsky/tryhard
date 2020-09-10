import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData myTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: SCAFFOLD_BLACK,
  accentColor: PURPLE,
  primaryColorBrightness: Brightness.dark,
  brightness: Brightness.dark,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: NAVBAR_BLACK),
  scaffoldBackgroundColor: SCAFFOLD_BLACK,
  // textTheme: TextTheme(),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(foregroundColor: SCAFFOLD_BLACK, backgroundColor: PURPLE),
  indicatorColor: DARK_PURPLE,
  buttonTheme: ButtonThemeData(),
  buttonColor: DARK_PURPLE,
  // buttonBarTheme: ButtonBarThemeData(),
  cardColor: BACKGROUND_DARK_GREY,
);
