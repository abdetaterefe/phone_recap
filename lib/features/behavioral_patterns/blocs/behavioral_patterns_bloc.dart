import 'package:call_log/call_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'behavioral_patterns_event.dart';
part 'behavioral_patterns_state.dart';

class BehavioralPatternsBloc
    extends Bloc<BehavioralPatternsEvent, BehavioralPatternsState> {
  BehavioralPatternsBloc() : super(const BehavioralPatternsState()) {
    on<BehavioralPatternsFrequencyHeatmapEvent>(_onFrequencyHeatmapEvent);
  }

  Future<void> _onFrequencyHeatmapEvent(
    BehavioralPatternsFrequencyHeatmapEvent event,
    Emitter<BehavioralPatternsState> emit,
  ) async {
    try {
      emit(const BehavioralPatternsState());

      final entries = await CallLog.query();
      final validEntries =
          entries
              .where((entry) => entry.timestamp != null && entry.timestamp! > 0)
              .where((entry) {
                if (event.callType == CallType.incoming.name) {
                  return entry.callType == CallType.incoming;
                } else if (event.callType == CallType.outgoing.name) {
                  return entry.callType == CallType.outgoing;
                } else {
                  return true;
                }
              })
              .toList();

      if (validEntries.isEmpty) {
        emit(const BehavioralPatternsState(status: Status.complete));
        return;
      }

      final heatmap = <int, Map<int, int>>{};
      for (int day = DateTime.monday; day <= DateTime.sunday; day++) {
        heatmap[day] = {for (int hour = 0; hour < 24; hour++) hour: 0};
      }
      for (final entry in validEntries) {
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

      emit(
        BehavioralPatternsState(
          status: Status.complete,
          frequencyHeatmap: heatmap,
        ),
      );
    } catch (e) {
      emit(const BehavioralPatternsState(status: Status.error));
    }
  }
}
