import 'package:flutter/material.dart';
import 'package:phone_recap/core/utils/time.dart';

class TopContactsSection extends StatelessWidget {
  const TopContactsSection({super.key, required this.topContactsByDuration});

  final List<MapEntry<String, int>> topContactsByDuration;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Top Contacts',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Divider(),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: topContactsByDuration.length,
              separatorBuilder: (context, index) => SizedBox(height: 8),
              itemBuilder: (context, index) {
                final entry = topContactsByDuration[index];
                return Row(
                  children: [
                    CircleAvatar(
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
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(TimeUtils.formatDuration(entry.value)),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
