part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsSetAppTheme extends SettingsEvent {
  final AppTheme appTheme;

  const SettingsSetAppTheme({required this.appTheme});

  @override
  List<Object> get props => [appTheme];
}
