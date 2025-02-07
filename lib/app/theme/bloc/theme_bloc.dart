import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/app/services/services.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(AppTheme initialTheme) : super(ThemeState(appTheme: initialTheme)) {
    on<ChangeTheme>((event, emit) async {
      ThemeService.setTheme(appTheme: event.appTheme);
      emit(ThemeState(appTheme: event.appTheme));
    });
  }
}
