import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/app/services/services.dart';
import 'package:phone_recap/app/theme/theme.dart';

class BusiestDay extends StatefulWidget {
  const BusiestDay({
    required this.callLogEntries,
    required this.month,
    super.key,
  });

  final String month;
  final List<CallLogEntry> callLogEntries;

  @override
  State<BusiestDay> createState() => _BusiestDayState();
}

class _BusiestDayState extends State<BusiestDay> {
  Map<String, int> getMostTalkedDates() {
    final mostTalkedDates = <String, int>{};

    if (widget.callLogEntries.isEmpty) {
      return mostTalkedDates;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(
      widget.callLogEntries.elementAt(0).timestamp!,
    );

    final month = date.month;
    final year = date.year;

    final firstDayOfNextMonth = DateTime(year, month + 1);

    final lastDayOfCurrentMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));

    for (var i = 1; i <= lastDayOfCurrentMonth.day; i++) {
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
    final colors = <int>[];
    final mtd = getMostTalkedDates();

    if (mtd.isEmpty) {
      return colors;
    }

    final maxColorValue = mtd.values
        .reduce((value, element) => value > element ? value : element);

    for (final value in mtd.values) {
      double brightnessRatio = (value / maxColorValue);

      int alphaValue = (brightnessRatio * 255).toInt();

      alphaValue = alphaValue.clamp(0, 255);

      colors.add(alphaValue);
    }

    return colors;
  }

  Map<String, int> getMostDayOfTheTalked({required bool duration}) {
    final mostDayOfTheTalked = <String, int>{};

    for (final entry in widget.callLogEntries) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);
      final day = _getDayOfWeek(date);

      mostDayOfTheTalked[day] ??= 0;
      if (duration) {
        mostDayOfTheTalked[day] =
            mostDayOfTheTalked[day]! + (entry.duration ?? 0);
      } else {
        mostDayOfTheTalked[day] = mostDayOfTheTalked[day]! + 1;
      }
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
      'Sunday',
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
    final mostDayOfTheTalked = getMostDayOfTheTalked(duration: false);
    final mostDayOfTheTalkedDuration = getMostDayOfTheTalked(duration: true);

    final mostTalkedDates = getMostTalkedDates();

    final currentTheme = BlocProvider.of<ThemeBloc>(context).state.appTheme;
    final themeData =
        ThemeService.buildTheme(ThemeState(appTheme: currentTheme));
    final primaryColor = themeData.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: List.generate(
              mostTalkedDates.length,
              (index) => Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message:
                    '${widget.month}: ${mostTalkedDates.keys.elementAt(index)}',
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: primaryColor
                        .withAlpha((getMostTalkedGraphColors()[index])),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Less',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color, // Themed text color
                  ),
                ),
                SizedBox(
                  height: 20,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final value = index == 0 ? 0 : index * 25;
                      return Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: primaryColor.withAlpha(value + 25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 4,
                      );
                    },
                  ),
                ),
                Text(
                  'More',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color, // Themed text color
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              mostDayOfTheTalked.isNotEmpty
                  ? 'Most calls were on ${mostDayOfTheTalked.keys.elementAt(0)}'
                  : 'No call data available',
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color, // Themed text color
              ),
            ),
            subtitle: Text(
              mostDayOfTheTalkedDuration.isNotEmpty
                  ? formatSeconds(
                      mostDayOfTheTalkedDuration[
                          mostDayOfTheTalkedDuration.keys.elementAt(0)]!,
                    )
                  : 'No duration data available',
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color, // Themed text color
              ),
            ),
            trailing: Text(
              mostDayOfTheTalked.isNotEmpty
                  ? '${mostDayOfTheTalked[mostDayOfTheTalked.keys.elementAt(0)]} Calls'
                  : 'No call data available',
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color, // Themed text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
