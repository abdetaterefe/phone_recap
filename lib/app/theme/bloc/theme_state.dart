part of 'theme_bloc.dart';

enum AppTheme {
  darkGreen,
  lightGreen,
  darkBlue,
  lightBlue,
  darkPink,
  lightPink,
  darkPurple,
  lightPurple
}

class ThemeState {
  final AppTheme appTheme;
  ThemeState({required this.appTheme});
}
