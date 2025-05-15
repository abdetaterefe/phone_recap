import 'package:flutter/material.dart';
import 'package:phone_recap/core/utils/time.dart';

class SummarySection extends StatelessWidget {
  const SummarySection({
    super.key,
    required this.totalDuration,
    required this.averageDuration,
  });

  final int totalDuration;
  final double averageDuration;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Summary', style: Theme.of(context).textTheme.titleMedium),
            Divider(),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.call_outlined,
                          size: 32,
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          TimeUtils.formatDuration(totalDuration),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Total Duration',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.access_time_outlined,
                          size: 32,
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(height: 8),
                        Text(
                          TimeUtils.formatDuration(averageDuration.toInt()),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Avg. Duration',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
