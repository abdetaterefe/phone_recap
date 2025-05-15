import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/core/services/services.dart';
import 'package:phone_recap/core/theme/theme.dart';
import 'package:phone_recap/features/comparative_analytics/comparative_analytics.dart';
import 'package:phone_recap/features/contact_insights/contact_insights.dart';
import 'package:phone_recap/features/home/home.dart';
import 'package:phone_recap/features/settings/settings.dart';
import 'package:phone_recap/features/summaries/summaries.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int currentPageIndex = 0;
  final List<Widget> pages = [
    const HomePage(),
    const SummariesPage(),
    const ContactInsightsPage(),
    const ComparativeAnalyticsPage(),
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
                  selectedIcon: Icon(Icons.summarize),
                  icon: Icon(Icons.summarize_outlined),
                  label: 'Summary',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.person_search),
                  icon: Icon(Icons.person_search_outlined),
                  label: 'Contact',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.compare_arrows),
                  icon: Icon(Icons.compare_arrows_outlined),
                  label: 'Compare',
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
