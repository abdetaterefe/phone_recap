import 'package:flutter/material.dart';
import 'package:phone_recap/core/utils/time.dart';

class TopContactsSection extends StatelessWidget {
  const TopContactsSection({super.key, required this.topContactsByDuration});

  final List<MapEntry<String, int>> topContactsByDuration;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Top Contacts', style: Theme.of(context).textTheme.titleLarge),
            Divider(),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: topContactsByDuration.length,
              itemBuilder: (context, index) {
                final entry = topContactsByDuration[index];
                return ListTile(
                  title: Text(entry.key),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      entry.key[0],
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.brightness ==
                                    Brightness.dark
                                ? Colors.black
                                : Colors.white,
                      ),
                    ),
                  ),
                  subtitle: Text(TimeUtils.formatDuration(entry.value)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
