import 'package:flutter/material.dart';
import 'package:phone_recap/core/constants/constants.dart';
import 'package:phone_recap/core/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static Future<void> setTheme({required AppTheme appTheme}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', appTheme.name);
  }

  static Future<AppTheme> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeString = prefs.getString('theme');

    try {
      return AppTheme.values.firstWhere(
        (e) => e.name == themeString,
        orElse: () => AppTheme.darkGreen,
      );
    } catch (e) {
      return AppTheme.darkGreen;
    }
  }

  static ThemeData buildTheme(ThemeState state) {
    switch (state.appTheme) {
      case AppTheme.darkGreen:
        return darkGreenTheme;
      case AppTheme.lightGreen:
        return lightGreenTheme;
      case AppTheme.darkBlue:
        return darkBlueTheme;
      case AppTheme.lightBlue:
        return lightBlueTheme;
      case AppTheme.darkPink:
        return darkPinkTheme;
      case AppTheme.lightPink:
        return lightPinkTheme;
      case AppTheme.darkPurple:
        return darkPurpleTheme;
      case AppTheme.lightPurple:
        return lightPurpleTheme;
    }
  }
}
