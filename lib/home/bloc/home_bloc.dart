import 'package:call_log/call_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeGetCallYears>(_onGetCallYears);
  }

  Future<void> _onGetCallYears(
    HomeGetCallYears event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final result = await CallLog.query();
      if (result.isEmpty) {
        emit(
          const HomeState(
            yearsListStatus: Status.complete,
          ),
        );
      }

      final timestamps = result.map((e) => e.timestamp!).toList();
      final firstYear = DateTime.fromMillisecondsSinceEpoch(
          timestamps.reduce((a, b) => a < b ? a : b)).year;
      final lastYear = DateTime.fromMillisecondsSinceEpoch(
          timestamps.reduce((a, b) => a > b ? a : b)).year;

      final years =
          List.generate(lastYear - firstYear + 1, (i) => firstYear + i);

      emit(
        HomeState(
          yearsListStatus: Status.complete,
          yearsList: years,
        ),
      );
    } catch (e) {
      debugPrint('Error fetching call years: $e');
      emit(
        const HomeState(
          yearsListStatus: Status.error,
        ),
      );
    }
  }
}
