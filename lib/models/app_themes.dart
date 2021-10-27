import 'package:flutter/material.dart';

import '../helpers/custom_route.dart';

enum AppTheme {
  Light,
  Dark,
}

//Returns enum value name without enum class name.
String enumName(AppTheme anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appThemeData = {
  AppTheme.Light: ThemeData(
    canvasColor: Color.fromRGBO(230, 235, 239, 1),
    fontFamily: 'OpenSans',
    primaryColor: Color.fromRGBO(74, 128, 192, 1),
    accentColor: Color.fromRGBO(3, 81, 124, 1),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      },
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: IconThemeData(size: 23.0),
  ),
  AppTheme.Dark: ThemeData(
    brightness: Brightness.dark,
    canvasColor: Color.fromRGBO(16, 29, 36, 1),
    fontFamily: 'OpenSans',
    primaryColor: Color.fromRGBO(34, 45, 54, 1),
    accentColor: Color.fromRGBO(3, 81, 124, 1),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      },
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: IconThemeData(size: 23.0),
  ),
};
