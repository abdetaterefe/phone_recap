import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/app/core/constants/constants.dart';
import 'package:phone_recap/app/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static MaterialPageRoute<SettingsPage> route() =>
      MaterialPageRoute(builder: (context) => const SettingsPage());

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: <Widget>[
          Card(
            elevation: 2,
            child: ListTile(
              title: const Text('Theme'),
              onTap: () {
                _showThemeBottomSheet(context);
              },
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ),
          ),
          Card(
            elevation: 2,
            child: ListTile(
              title: const Text('About'),
              subtitle: Text("Made by Abdeta Terefe"),
              leading: const Icon(Icons.info_outline),
              trailing: IconButton.filledTonal(
                onPressed: () async {
                  final url = Uri.parse('https://abdeta.dev');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                icon: const Icon(Icons.open_in_browser),
              ),
            ),
          ),
          Card(
            elevation: 2,
            child: ListTile(
              title: const Text('Privacy'),
              leading: const Icon(Icons.privacy_tip_outlined),
              trailing: IconButton.filledTonal(
                onPressed: () async {
                  final url = Uri.parse(
                    'https://phone-recap.jinc.team/privary',
                  );
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                icon: const Icon(Icons.open_in_browser),
              ),
            ),
          ),
          Card(
            elevation: 2,
            child: ListTile(
              title: const Text('Contact'),
              leading: const Icon(Icons.contact_support_outlined),
              trailing: IconButton.filledTonal(
                onPressed: () async {
                  final url = Uri.parse('https://abdeta.dev');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                icon: const Icon(Icons.open_in_browser),
              ),
            ),
          ),
        ],
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

        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: AppTheme.values.map((itemAppTheme) {
              return Card.outlined(
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<ThemeBloc>(context)
                        .add(ChangeTheme(appTheme: itemAppTheme));
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
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: secondaryColorMap[itemAppTheme],
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
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
