import 'package:call_log/call_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recap_event.dart';
part 'recap_state.dart';

class RecapBloc extends Bloc<RecapEvent, RecapState> {
  RecapBloc() : super(const RecapState()) {
    on<RecapGetCallRecap>(_onGetCallRecap);
  }

  Future<void> _onGetCallRecap(
    RecapGetCallRecap event,
    Emitter<RecapState> emit,
  ) async {
    try {
      emit(const RecapState());
      final startingDate = DateTime(event.year);
      final endingDate = DateTime(event.year + 1);
      final result = await CallLog.query(
        dateFrom: startingDate.millisecondsSinceEpoch,
        dateTo: endingDate.millisecondsSinceEpoch,
      );

      if (result.isEmpty) {
        emit(
          const RecapState(
            recapListStatus: Status.complete,
          ),
        );
      }

      final monthlyEntries = <String, List<CallLogEntry>>{};

      for (final entry in result) {
        final timestamp = entry.timestamp ?? 0;
        final monthName = _getMonthName(
          DateTime.fromMillisecondsSinceEpoch(timestamp),
        );

        monthlyEntries.putIfAbsent(monthName, () => []).add(entry);
      }
      emit(
        RecapState(
          recapListStatus: Status.complete,
          recapList: monthlyEntries,
        ),
      );
    } catch (e) {
      debugPrint('Error fetching call recap: $e');
      emit(
        const RecapState(
          recapListStatus: Status.error,
        ),
      );
    }
  }

  String _getMonthName(DateTime dateTime) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[dateTime.month - 1];
  }
}
