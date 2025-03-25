import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/app.dart';
import 'package:phone_recap/core/notification/notification.dart';
import 'package:phone_recap/core/services/services.dart';
import 'package:phone_recap/core/theme/theme.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  NotificationService().initialize();
  AppTheme initialTheme = await ThemeService.getTheme();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc(initialTheme)),
        BlocProvider<NotificationBloc>(
          create:
              (context) =>
                  NotificationBloc(notificationService: NotificationService()),
        ),
      ],
      child: App(),
    ),
  );
}
