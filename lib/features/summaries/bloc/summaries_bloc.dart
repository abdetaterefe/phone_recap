import 'package:call_log/call_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/core/utils/time.dart';

part 'summaries_state.dart';
part 'summaries_event.dart';

class SummariesBloc extends Bloc<SummariesEvent, SummariesState> {
  SummariesBloc() : super(const SummariesState()) {
    on<SummariesLoadEvent>(_onLoadEvent);
  }

  Future<void> _onLoadEvent(
    SummariesLoadEvent event,
    Emitter<SummariesState> emit,
  ) async {
    try {
      emit(SummariesState());
      final entries = await CallLog.query();
      if (entries.isEmpty) {
        emit(const SummariesState(status: Status.complete));
        return;
      }

      final callSummaries = <String, List<CallLogEntry>>{};

      final timestamps = entries.map((e) => e.timestamp!).toList();
      final firstCallYear =
          DateTime.fromMillisecondsSinceEpoch(
            timestamps.reduce((a, b) => a < b ? a : b),
          ).year;
      final lastCallYear =
          DateTime.fromMillisecondsSinceEpoch(
            timestamps.reduce((a, b) => a > b ? a : b),
          ).year;

      final yearsToProcess = List.generate(
        lastCallYear - firstCallYear + 1,
        (i) => firstCallYear + i,
      );

      for (final year in yearsToProcess) {
        for (int month = 1; month <= 12; month++) {
          final startOfMonth = DateTime(year, month);
          final endOfMonth = DateTime(year, month + 1);

          final callsOfMonth = await CallLog.query(
            dateFrom: startOfMonth.millisecondsSinceEpoch,
            dateTo: endOfMonth.millisecondsSinceEpoch,
          );

          if (callsOfMonth.isNotEmpty) {
            final monthName = TimeUtils.getMonthName(startOfMonth);
            final summaryKey = "$monthName $year";
            callSummaries
                .putIfAbsent(summaryKey, () => [])
                .addAll(callsOfMonth);
          }
        }
      }

      emit(SummariesState(status: Status.complete, summaries: callSummaries));
    } catch (e) {
      debugPrint('Error fetching summaries: $e');
      emit(const SummariesState(status: Status.error));
    }
  }
}
