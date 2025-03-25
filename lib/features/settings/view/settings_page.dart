import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/core/constants/constants.dart';
import 'package:phone_recap/core/notification/notification.dart';
import 'package:phone_recap/core/services/services.dart';
import 'package:phone_recap/core/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static MaterialPageRoute<SettingsPage> route() =>
      MaterialPageRoute(builder: (context) => SettingsPage());

  @override
  Widget build(BuildContext context) {
    return SettingsView();
  }
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(CheckPermission());
  }

  void _handleNotificationToggle(
    BuildContext context,
    NotificationState state,
    bool value,
  ) {
    if (state.hasPermission) {
      context.read<NotificationBloc>().add(
        value ? ScheduleNotification() : CancelAllNotifications(),
      );
    } else {
      if (state.isPermanentlyDenied) {
        context.read<NotificationBloc>().add(OpenSettings());
      } else {
        context.read<NotificationBloc>().add(RequestPermission());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = BlocProvider.of<ThemeBloc>(context).state.appTheme;
    final themeNameMap = <AppTheme, String>{
      AppTheme.darkGreen: 'Dark Green',
      AppTheme.lightGreen: 'Light Green',
      AppTheme.darkBlue: 'Dark Blue',
      AppTheme.lightBlue: 'Light Blue',
      AppTheme.darkPink: 'Dark Pink',
      AppTheme.lightPink: 'Light Pink',
      AppTheme.darkPurple: 'Dark Purple',
      AppTheme.lightPurple: 'Light Purple',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                "Appearance",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            ListTile(
              leading: Icon(Icons.palette),
              title: const Text('App Theme'),
              subtitle: Text(themeNameMap[currentTheme] ?? currentTheme.name),
              onTap: () => _showThemeBottomSheet(context),
            ),
            Divider(),
            ListTile(
              title: Text(
                "Options",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                return ListTile(
                  title: const Text('Notifications'),
                  leading: Icon(Icons.notifications),
                  subtitle: const Text('Enable Notifications'),
                  trailing: Switch(
                    value: state.isEnabled,
                    onChanged:
                        (value) =>
                            _handleNotificationToggle(context, state, value),
                  ),
                  onTap:
                      () => _handleNotificationToggle(
                        context,
                        state,
                        !state.isEnabled,
                      ),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                "Privacy",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            ListTile(
              title: const Text('Send Crash Reports'),
              leading: Icon(Icons.bug_report),
              subtitle: const Text(
                'Allow Phone Recap to send crash reports, which help us improve the app.',
              ),
              trailing: Switch(value: false, onChanged: (value) {}),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              title: Text(
                "About",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            ListTile(
              title: const Text('Version'),
              leading: Icon(Icons.info),
              subtitle: const Text('1.1.0'),
              onTap: () async {
                final url = Uri.parse(
                  'https://github.com/abdetaterefe/phone_recap/releases',
                );
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
            ),
            ListTile(
              title: const Text('License'),
              leading: Icon(Icons.copyright),
              subtitle: const Text('MIT License'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Source Code'),
              leading: Icon(Icons.code),
              subtitle: const Text(
                'https://github.com/abdetaterefe/phone_recap',
              ),
              onTap: () async {
                final url = Uri.parse(
                  'https://github.com/abdetaterefe/phone_recap',
                );
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final themeNameMap = <AppTheme, String>{
          AppTheme.darkGreen: 'Dark Green',
          AppTheme.lightGreen: 'Light Green',
          AppTheme.darkBlue: 'Dark Blue',
          AppTheme.lightBlue: 'Light Blue',
          AppTheme.darkPink: 'Dark Pink',
          AppTheme.lightPink: 'Light Pink',
          AppTheme.darkPurple: 'Dark Purple',
          AppTheme.lightPurple: 'Light Purple',
        };

        final primaryColorMap = <AppTheme, Color>{
          AppTheme.darkGreen: darkGreenTheme.colorScheme.primary,
          AppTheme.lightGreen: lightGreenTheme.colorScheme.primary,
          AppTheme.darkBlue: darkBlueTheme.colorScheme.primary,
          AppTheme.lightBlue: lightBlueTheme.colorScheme.primary,
          AppTheme.darkPink: darkPinkTheme.colorScheme.primary,
          AppTheme.lightPink: lightPinkTheme.colorScheme.primary,
          AppTheme.darkPurple: darkPurpleTheme.colorScheme.primary,
          AppTheme.lightPurple: lightPurpleTheme.colorScheme.primary,
        };
        final secondaryColorMap = <AppTheme, Color>{
          AppTheme.darkGreen: darkGreenTheme.colorScheme.secondary,
          AppTheme.lightGreen: lightGreenTheme.colorScheme.secondary,
          AppTheme.darkBlue: darkBlueTheme.colorScheme.secondary,
          AppTheme.lightBlue: lightBlueTheme.colorScheme.secondary,
          AppTheme.darkPink: darkPinkTheme.colorScheme.secondary,
          AppTheme.lightPink: lightPinkTheme.colorScheme.secondary,
          AppTheme.darkPurple: darkPurpleTheme.colorScheme.secondary,
          AppTheme.lightPurple: lightPurpleTheme.colorScheme.secondary,
        };
        final tertiaryColorMap = <AppTheme, Color>{
          AppTheme.darkGreen: darkGreenTheme.colorScheme.tertiary,
          AppTheme.lightGreen: lightGreenTheme.colorScheme.tertiary,
          AppTheme.darkBlue: darkBlueTheme.colorScheme.tertiary,
          AppTheme.lightBlue: lightBlueTheme.colorScheme.tertiary,
          AppTheme.darkPink: darkPinkTheme.colorScheme.tertiary,
          AppTheme.lightPink: lightPinkTheme.colorScheme.tertiary,
          AppTheme.darkPurple: darkPurpleTheme.colorScheme.tertiary,
          AppTheme.lightPurple: lightPurpleTheme.colorScheme.tertiary,
        };

        final currentTheme = BlocProvider.of<ThemeBloc>(context).state.appTheme;
        final themeData = ThemeService.buildTheme(
          ThemeState(appTheme: currentTheme),
        );
        final primaryColor = themeData.colorScheme.primaryContainer;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children:
                AppTheme.values.map((itemAppTheme) {
                  return Card.outlined(
                    color:
                        currentTheme.name == itemAppTheme.name
                            ? primaryColor
                            : null,
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<ThemeBloc>(
                          context,
                        ).add(ChangeTheme(appTheme: itemAppTheme));

                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              themeNameMap[itemAppTheme] ?? itemAppTheme.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: primaryColorMap[itemAppTheme],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: secondaryColorMap[itemAppTheme],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: tertiaryColorMap[itemAppTheme],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
