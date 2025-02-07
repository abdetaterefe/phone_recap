import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:phone_recap/app/services/services.dart';
import 'package:phone_recap/app/theme/theme.dart';
import 'package:phone_recap/home/home.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Future<InitializationStatus> initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          theme: ThemeService.buildTheme(themeState),
          home: FutureBuilder<void>(
            future: initGoogleMobileAds(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              return HomePage();
            },
          ),
        );
      },
    );
  }
}
