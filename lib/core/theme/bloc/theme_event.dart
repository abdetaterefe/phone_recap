part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final AppTheme appTheme;
  const ChangeTheme({required this.appTheme});
  @override
  List<Object?> get props => [appTheme];
}
