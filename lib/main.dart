import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/app.dart';
import 'package:phone_recap/core/services/services.dart';
import 'package:phone_recap/core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme initialTheme = await ThemeService.getTheme();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc(initialTheme)),
      ],
      child: App(),
    ),
  );
}
