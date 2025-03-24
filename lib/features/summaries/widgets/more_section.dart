import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:phone_recap/core/utils/time.dart';

class MoreSection extends StatelessWidget {
  const MoreSection({super.key, required this.entries});

  final List<CallLogEntry> entries;

  CallLogEntry? get longestCall {
    if (entries.isEmpty) {
      return null;
    }
    return entries.reduce((a, b) {
      final aDuration = a.duration ?? 0;
      final bDuration = b.duration ?? 0;
      return aDuration > bDuration ? a : b;
    });
  }

  Map<String, int> get mostFrequentCallsByDuration {
    final callDurations = <String, int>{};
    for (final entry in entries) {
      final key = entry.name ?? entry.number ?? 'Unknown';
      callDurations.update(
        key,
        (value) => value + (entry.duration ?? 0),
        ifAbsent: () => entry.duration ?? 0,
      );
    }

    final sortedEntries =
        callDurations.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }

  Map<String, int> mostCalledPersonByType(int callTypeIndex) {
    final mostCalledPersonMap = <String, int>{};

    for (final entry in entries) {
      if (entry.callType?.index == callTypeIndex) {
        final key = entry.name ?? entry.number ?? 'Unknown';
        mostCalledPersonMap.update(
          key,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
    }

    final sortedEntries =
        mostCalledPersonMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }

  Map<String, int> getMostDayOfTheTalked({required bool duration}) {
    final mostDayOfTheTalked = <String, int>{};

    for (final entry in entries) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);
      final day = TimeUtils.getDayOfWeek(date);

      mostDayOfTheTalked[day] ??= 0;
      if (duration) {
        mostDayOfTheTalked[day] =
            mostDayOfTheTalked[day]! + (entry.duration ?? 0);
      } else {
        mostDayOfTheTalked[day] = mostDayOfTheTalked[day]! + 1;
      }
    }

    final sortedEntries =
        mostDayOfTheTalked.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final sortedMap = Map.fromEntries(sortedEntries);
    return sortedMap;
  }

  Map<String, int> get mostIncomingCalls => mostCalledPersonByType(0);
  Map<String, int> get mostOutgoingCalls => mostCalledPersonByType(1);
  Map<String, int> get mostDayOfTheTalked =>
      getMostDayOfTheTalked(duration: false);
  Map<String, int> get mostDayOfTheTalkedDuration =>
      getMostDayOfTheTalked(duration: true);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            "More",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ListTile(
          title: const Text("Longest Calls"),
          subtitle: Text(
            "${longestCall?.name ?? longestCall?.number ?? 'Unknown'} - ${longestCall?.callType?.name}",
          ),
          trailing: Text(TimeUtils.formatDuration(longestCall?.duration ?? 0)),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Most Frequent Calls"),
          subtitle: Text(
            mostFrequentCallsByDuration.keys.isEmpty
                ? "No calls"
                : mostFrequentCallsByDuration.keys.first,
          ),
          trailing: Text(
            TimeUtils.formatDuration(
              mostFrequentCallsByDuration.values.isEmpty
                  ? 0
                  : mostFrequentCallsByDuration.values.first,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Most Incoming Calls"),
          subtitle: Text(
            mostIncomingCalls.entries.isEmpty
                ? "No calls"
                : mostIncomingCalls.entries.first.key,
          ),
          trailing: Text(
            mostIncomingCalls.entries.isEmpty
                ? "No calls"
                : mostIncomingCalls.entries.first.value.toString(),
          ),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Most Outgoing Calls"),
          subtitle: Text(
            mostOutgoingCalls.entries.isEmpty
                ? "No calls"
                : mostOutgoingCalls.entries.first.key,
          ),
          trailing: Text(
            mostOutgoingCalls.entries.isEmpty
                ? "No calls"
                : mostOutgoingCalls.entries.first.value.toString(),
          ),
          onTap: () {},
        ),
        ListTile(
          title: Text('Most calls were on'),
          subtitle: Text(
            mostDayOfTheTalked.isNotEmpty
                ? '${mostDayOfTheTalked.keys.elementAt(0)} - ${mostDayOfTheTalked[mostDayOfTheTalked.keys.elementAt(0)]} calls'
                : 'Unknown',
          ),
          trailing: Text(
            mostDayOfTheTalkedDuration.isNotEmpty
                ? TimeUtils.formatDuration(
                  mostDayOfTheTalkedDuration[mostDayOfTheTalked.keys.first]!,
                )
                : '0 hours',
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
