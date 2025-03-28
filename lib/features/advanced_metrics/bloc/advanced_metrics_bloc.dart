import 'package:call_log/call_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'advanced_metrics_event.dart';
part 'advanced_metrics_state.dart';

class AdvancedMetricsBloc
    extends Bloc<AdvancedMetricsEvent, AdvancedMetricsState> {
  AdvancedMetricsBloc() : super(const AdvancedMetricsState()) {
    on<AdvancedMetricsLoadEvent>(_onLoad);
  }

  Future<void> _onLoad(
    AdvancedMetricsLoadEvent event,
    Emitter<AdvancedMetricsState> emit,
  ) async {
    try {
      emit(const AdvancedMetricsState());
      final Iterable<CallLogEntry> entries = await CallLog.query();
      if (entries.isEmpty) {
        emit(const AdvancedMetricsState(status: Status.complete));
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
        AdvancedMetricsState(
          status: Status.complete,
          missedCalls: missedCalls.length,
          rejectedCalls: rejectedCalls.length,
          blockedCalls: blockedCalls.length,
        ),
      );
    } catch (e) {
      emit(const AdvancedMetricsState(status: Status.error));
    }
  }
}
