import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/core/services/services.dart';
import 'package:phone_recap/theme/theme.dart';
import 'package:phone_recap/features/home/home.dart';
import 'package:phone_recap/features/analytics/view/analytics_page.dart';
import 'package:phone_recap/features/settings/view/settings_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int currentPageIndex = 0;
  final List<Widget> pages = [
    const HomePage(),
    const AnalyticsPage(),
    const SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeService.buildTheme(themeState),
          home: Scaffold(
            body: pages[currentPageIndex],
            bottomNavigationBar: NavigationBar(
              selectedIndex: currentPageIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              destinations: [
                NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.analytics),
                  icon: Icon(Icons.analytics_outlined),
                  label: 'Analytics',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.settings),
                  icon: Icon(Icons.settings_outlined),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
