import 'dart:collection';
import 'package:flutter/material.dart';

class ContactInsightsPage extends StatelessWidget {
  const ContactInsightsPage({super.key});
  static MaterialPageRoute<ContactInsightsPage> route() =>
      MaterialPageRoute(builder: (context) => ContactInsightsPage());

  @override
  Widget build(BuildContext context) {
    return ContactInsightsView();
  }
}

class ContactInsightsView extends StatefulWidget {
  const ContactInsightsView({super.key});

  @override
  State<ContactInsightsView> createState() => _ContactInsightsViewState();
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
typedef MenuEntry = DropdownMenuEntry<String>;

class _ContactInsightsViewState extends State<ContactInsightsView> {
  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Insights')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card.filled(
              child: DropdownMenu<String>(
                width: double.infinity,
                leadingIcon: Icon(
                  Icons.contacts,
                  color: Theme.of(context).colorScheme.primary,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: InputBorder.none,
                ),
                initialSelection: list.first,
                onSelected: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                dropdownMenuEntries: menuEntries,
              ),
            ),
            Expanded(
              child: Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "Response Rate",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "78%",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            subtitle: Text(
                              "125 calls have been answered out of 138 calls",
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              "Average Call Duration",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "3 minutes",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              "Communication Streak",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "3 days",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            subtitle: Text(
                              "Longest streak was recorded from 2022-01-01 to 2022-02-01",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
