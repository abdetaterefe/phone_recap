import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

class CalendarSection extends StatefulWidget {
  const CalendarSection({
    super.key,
    required this.entries,
    required this.currentMonth,
  });
  final List<CallLogEntry> entries;
  final String currentMonth;

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  final DateTime _today = DateTime.now();

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

  Map<String, int> _getCallCountsByDay(int month, int year) {
    final dayCounts = <String, int>{};
    final lastDay = DateTime(year, month + 1, 0).day;

    // Initialize all days to 0
    for (var day = 1; day <= lastDay; day++) {
      dayCounts[day.toString()] = 0;
    }

    // Count calls for each day in target month
    for (final entry in widget.entries) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);
      if (date.month == month && date.year == year) {
        final day = date.day.toString();
        dayCounts[day] = dayCounts[day]! + 1;
      }
    }

    return dayCounts;
  }

  List<int> _calculateDayAlphas(int month, int year) {
    final dayCounts = _getCallCountsByDay(month, year).values.toList();
    if (dayCounts.isEmpty) return [];

    final maxCalls = dayCounts.reduce((a, b) => a > b ? a : b);
    if (maxCalls == 0) return List.filled(dayCounts.length, 0);

    return dayCounts.map((count) {
      return ((count / maxCalls) * 255).clamp(0, 255).toInt();
    }).toList();
  }

  Widget _buildCalendarGrid() {
    final focusedDay =
        widget.entries.isEmpty
            ? DateTime.now()
            : DateTime.fromMillisecondsSinceEpoch(
              widget.entries.first.timestamp!,
            );

    final month = focusedDay.month;
    final year = focusedDay.year;
    final lastDay = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday;

    // Calculate grid layout
    final daysBefore = (firstWeekday - DateTime.monday) % 7;
    final totalSlots = lastDay + daysBefore;
    final weeks = (totalSlots / 7).ceil();
    final trailingSlots = weeks * 7 - totalSlots;

    // Get alpha values for coloring
    final alphas = _calculateDayAlphas(month, year);

    // Build grid cells
    final cells = <Widget>[
      ...List.generate(daysBefore, (_) => _buildEmptyDay()),
      ...List.generate(lastDay, (index) {
        final day = index + 1;
        return _buildCalendarDay(
          day: day,
          alpha: alphas.isNotEmpty ? alphas[index] : 0,
          isToday:
              day == _today.day && month == _today.month && year == _today.year,
        );
      }),
      ...List.generate(trailingSlots, (_) => _buildEmptyDay()),
    ];

    // Build week rows
    return Column(
      children: List.generate(weeks, (week) {
        return Row(children: cells.sublist(week * 7, (week + 1) * 7));
      }),
    );
  }

  Widget _buildEmptyDay() {
    return const Expanded(child: Card.outlined(child: SizedBox.shrink()));
  }

  Widget _buildCalendarDay({
    required int day,
    required int alpha,
    required bool isToday,
  }) {
    return Expanded(
      child: Tooltip(
        triggerMode: TooltipTriggerMode.tap,
        message: '${day.toString()} ${widget.currentMonth}',
        child: Card.outlined(
          color:
              alpha > 0
                  ? Theme.of(context).colorScheme.primary.withAlpha(alpha)
                  : null,
          child: Center(
            child: Text(
              isToday ? day.toString() : "",
              style: TextStyle(
                color:
                    Theme.of(context).colorScheme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Calendar",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _buildDaysOfWeek(),
        _buildCalendarGrid(),
      ],
    );
  }
}
