import 'package:flutter/material.dart';

import 'constants.dart';

class Themes {
  ThemeData darkTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'SFPRODISPLAY',
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        appBarTheme: const AppBarTheme(
          color: AppConstants.appBarColor,
        ));
  }
}
