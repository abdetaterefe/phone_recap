import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/about/about.dart';
import 'package:phone_recap/settings/settings.dart' as settings;
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

enum ThemeModeOption { system, light, dark }

class SettingsViewState extends State<SettingsView> {
  ThemeModeOption _selectedTheme = ThemeModeOption.system;

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
              subtitle: Text(_selectedTheme.name),
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
              leading: const Icon(Icons.info_outline),
              trailing: IconButton.filledTonal(
                onPressed: () async {
                  Navigator.push(context, AboutPage.route());
                },
                icon: const Icon(Icons.navigate_next),
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
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: settings.AppTheme.values.length,
              itemBuilder: (context, index) {
                final itemAppTheme = settings.AppTheme.values[index];
                return Card(
                  color: settings.appThemeData[itemAppTheme]?.cardColor,
                  child: ListTile(
                    title: Text(itemAppTheme.toString()),
                    onTap: () {
                      context.read<settings.SettingsBloc>().add(
                        settings.SettingsSetAppTheme(appTheme: itemAppTheme),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
