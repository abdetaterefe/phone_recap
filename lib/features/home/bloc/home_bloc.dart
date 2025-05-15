import 'package:call_log/call_log.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeLoadTotalStatsEvent>(_onGetCallYears);
  }

  Future<void> _onGetCallYears(
    HomeLoadTotalStatsEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(const HomeState());
      final Iterable<CallLogEntry> entries = await CallLog.query();
      if (entries.isEmpty) {
        emit(const HomeState(status: Status.complete));
      }
      final totalCalls = entries.length;

      // Total and Average Duration
      final totalDuration = entries.fold<int>(
        0,
        (sum, entry) => sum + (entry.duration ?? 0),
      );
      final averageDuration = totalCalls > 0 ? totalDuration / totalCalls : 0.0;

      // Group contacts by phone number
      final contactGroups = <String, List<CallLogEntry>>{};
      for (final entry in entries) {
        final number = entry.name ?? entry.number ?? 'Unknown';
        contactGroups.putIfAbsent(number, () => []).add(entry);
      }

      // Calculate top contacts by total duration
      final sortedByDuration =
          contactGroups.entries.toList()..sort((a, b) {
            final aDuration = a.value.fold<int>(
              0,
              (sum, entry) => sum + (entry.duration ?? 0),
            );
            final bDuration = b.value.fold<int>(
              0,
              (sum, entry) => sum + (entry.duration ?? 0),
            );
            return bDuration.compareTo(aDuration);
          });
      final topContactsByDuration =
          sortedByDuration.take(3).map((group) {
            final duration = group.value.fold<int>(
              0,
              (sum, entry) => sum + (entry.duration ?? 0),
            );
            return MapEntry(group.key, duration);
          }).toList();

      // Call Volume Chart Data (grouped by day)
      final weeklyCalls = <DateTime, int>{};
      for (final entry in entries) {
        final date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);
        // Get the first day of the week
        final firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1));
        final weekStart = DateTime(
          firstDayOfWeek.year,
          firstDayOfWeek.month,
          firstDayOfWeek.day,
        );
        weeklyCalls.update(weekStart, (count) => count + 1, ifAbsent: () => 1);
      }

      // Filter data to include only the last year
      final now = DateTime.now();
      final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
      final filteredWeeklyCalls =
          weeklyCalls.entries
              .where((entry) => entry.key.isAfter(oneYearAgo))
              .toList()
            ..sort((a, b) => a.key.compareTo(b.key));

      final callVolumeChartData =
          filteredWeeklyCalls.map((entry) {
            // Use the week start as the x-value
            return FlSpot(
              entry.key.millisecondsSinceEpoch.toDouble(),
              entry.value.toDouble(),
            );
          }).toList();

      final heatmap = <int, Map<int, int>>{};
      for (int day = DateTime.monday; day <= DateTime.sunday; day++) {
        heatmap[day] = {for (int hour = 0; hour < 24; hour++) hour: 0};
      }
      for (final entry in entries) {
        final callDate = DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);
        final dayOfWeek = callDate.weekday;
        final hourOfDay = callDate.hour;

        heatmap[dayOfWeek]![hourOfDay] = heatmap[dayOfWeek]![hourOfDay]! + 1;
      }

      var largestCount = 0;
      for (final dayEntry in heatmap.values) {
        for (final count in dayEntry.values) {
          if (count > largestCount) largestCount = count;
        }
      }
      if (largestCount == 0) return;

      for (final dayEntry in heatmap.entries) {
        for (final hourEntry in dayEntry.value.entries) {
          final normalizedValue =
              (hourEntry.value / largestCount * 255).clamp(0, 255).toInt();
          heatmap[dayEntry.key]![hourEntry.key] = normalizedValue;
        }
      }

      final missedCalls = entries.where(
        (entry) => entry.callType == CallType.missed,
      );
      final rejectedCalls = entries.where(
        (entry) => entry.callType == CallType.rejected,
      );
      final blockedCalls = entries.where(
        (entry) => entry.callType == CallType.blocked,
      );

      emit(
        HomeState(
          status: Status.complete,
          averageDuration: averageDuration,
          topContactsByDuration: topContactsByDuration,
          totalDuration: totalDuration,
          callVolumeChartData: callVolumeChartData,
          frequencyHeatmap: heatmap,
          missedCalls: missedCalls.length,
          rejectedCalls: rejectedCalls.length,
          blockedCalls: blockedCalls.length,
        ),
      );
    } catch (e) {
      debugPrint('Error fetching call years: $e');
      emit(const HomeState(status: Status.error));
    }
  }
}
