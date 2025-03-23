import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:phone_recap/core/utils/time.dart';

class TotalSummaryTile extends StatelessWidget {
  const TotalSummaryTile({super.key, required this.entries});

  final List<CallLogEntry> entries;

  int get totalCalls => entries.length;

  int get totalsDuration =>
      entries.fold<int>(0, (sum, entry) => sum + (entry.duration ?? 0));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            "Total",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ListTile(
          title: Text(
            totalCalls.toString(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(TimeUtils.formatDuration(totalsDuration)),
        ),
      ],
    );
  }
}
