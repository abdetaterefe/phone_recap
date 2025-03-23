import 'package:flutter/material.dart';

class CalendarSection extends StatefulWidget {
  const CalendarSection({super.key});

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  final DateTime _focusedDay = DateTime.now();

  Widget _buildDaysOfWeek() {
    return Row(
      children:
          ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    int daysBefore = (firstDayOfMonth.weekday - DateTime.monday) % 7;

    final totalDays = lastDayOfMonth.day + daysBefore;
    final rows = (totalDays / 7).ceil();

    List<Widget> gridChildren = [];

    for (int i = 0; i < daysBefore; i++) {
      gridChildren.add(const Expanded(child: SizedBox()));
    }

    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      gridChildren.add(
        Expanded(
          child: Card.filled(child: Center(child: Text(day.toString()))),
        ),
      );
    }

    // Add empty cells for days after the last day of the month
    final daysAfter = (rows * 7) - totalDays;
    for (int i = 0; i < daysAfter; i++) {
      gridChildren.add(const Expanded(child: Card()));
    }

    // Create rows
    List<Widget> rowsList = [];
    for (int i = 0; i < rows; i++) {
      rowsList.add(Row(children: gridChildren.sublist(i * 7, (i + 1) * 7)));
    }

    return Column(children: rowsList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            "Calendar",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        _buildDaysOfWeek(),
        _buildCalendarGrid(),
      ],
    );
  }
}
