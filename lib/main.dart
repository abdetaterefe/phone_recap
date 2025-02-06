import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/app/app.dart';
import 'package:phone_recap/app/services/services.dart';
import 'package:phone_recap/app/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme initialTheme = await ThemeService.getTheme();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(initialTheme),
        ),
      ],
      child: const App(),
    ),
  );
}
