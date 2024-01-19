import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

class BusiestDay extends StatefulWidget {
  const BusiestDay({
    Key? key,
    required this.callLogEntries,
  }) : super(key: key);

  final List<CallLogEntry> callLogEntries;

  @override
  State<BusiestDay> createState() => _BusiestDayState();
}

class _BusiestDayState extends State<BusiestDay> {
  Map<String, int> getMostTalkedDates() {
    final Map<String, int> mostTalkedDates = {};

    final date = DateTime.fromMillisecondsSinceEpoch(
        widget.callLogEntries.elementAt(0).duration!);

    final month = date.month;
    final year = date.year;

    final DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);

    final DateTime lastDayOfCurrentMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));

    for (var i = 1; i < lastDayOfCurrentMonth.day; i++) {
      mostTalkedDates[i.toString()] ??= 0;
    }

    for (final entry in widget.callLogEntries) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);
      final day = date.day.toString();
      mostTalkedDates[day] ??= 0;
      mostTalkedDates[day] = mostTalkedDates[day]! + 1;
    }

    return mostTalkedDates;
  }

  List<int> getMostTalkedGraphColors() {
    List<int> colors = [];
    final mtd = getMostTalkedDates();

    int maxColorValue = mtd.values
        .reduce((value, element) => value > element ? value : element);

    for (int value in mtd.values) {
      double brightness = (value / maxColorValue) * 900;

      if (brightness < 50) {
        colors.add(50);
      } else {
        brightness = (brightness / 100).round() * 100;
        colors.add(brightness.toInt());
      }
    }

    return colors;
  }

  Map<String, int> getMostDayOfTheTalked(bool duration) {
    final Map<String, int> mostDayOfTheTalked = {};

    for (final entry in widget.callLogEntries) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);
      final day = _getDayOfWeek(date);

      mostDayOfTheTalked[day] ??= 0;
      if (duration) {
        mostDayOfTheTalked[day] = mostDayOfTheTalked[day]! + entry.duration!;
      }
      mostDayOfTheTalked[day] = mostDayOfTheTalked[day]! + 1;
    }

    final sortedEntries = mostDayOfTheTalked.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final sortedMap = Map.fromEntries(sortedEntries);
    return sortedMap;
  }

  String _getDayOfWeek(DateTime date) {
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return daysOfWeek[date.weekday - 1];
  }

  String formatSeconds(int seconds) {
    final hours = seconds ~/ 3600;
    final remainingMinutes = (seconds % 3600) ~/ 60;

    if (hours == 0) {
      return "$remainingMinutes minute${remainingMinutes == 1 ? '' : 's'}";
    } else {
      return "$hours hour${hours == 1 ? '' : 's'}, $remainingMinutes minute${remainingMinutes == 1 ? '' : 's'}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final mostDayOfTheTalked = getMostDayOfTheTalked(false);
    final mostDayOfTheTalkedDuration = getMostDayOfTheTalked(true);

    final mostTalkedDates = getMostTalkedDates();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: List.generate(
              mostTalkedDates.length,
              (index) => Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.green[getMostTalkedGraphColors()[index]],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    mostTalkedDates[mostTalkedDates.keys.elementAt(index)]
                        .toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              mostDayOfTheTalked.keys.elementAt(0),
            ),
            subtitle: Text(
              formatSeconds(mostDayOfTheTalkedDuration[
                  mostDayOfTheTalkedDuration.keys.elementAt(0)]!),
            ),
            trailing: Text(
              mostDayOfTheTalked[mostDayOfTheTalked.keys.elementAt(0)]
                  .toString(),
            ),
          ),
          ListTile(
            title: Text(
              mostDayOfTheTalked.keys.elementAt(1),
            ),
            subtitle: Text(
              formatSeconds(mostDayOfTheTalkedDuration[
                  mostDayOfTheTalkedDuration.keys.elementAt(1)]!),
            ),
            trailing: Text(
              mostDayOfTheTalked[mostDayOfTheTalked.keys.elementAt(1)]
                  .toString(),
            ),
          ),
          ListTile(
            title: Text(
              mostDayOfTheTalked.keys.elementAt(2),
            ),
            subtitle: Text(
              formatSeconds(mostDayOfTheTalkedDuration[
                  mostDayOfTheTalkedDuration.keys.elementAt(2)]!),
            ),
            trailing: Text(
              mostDayOfTheTalked[mostDayOfTheTalked.keys.elementAt(2)]
                  .toString(),
            ),
          ),
        ],
      ),
    );
  }
}
