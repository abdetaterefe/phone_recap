part of 'behavioral_patterns_bloc.dart';

sealed class BehavioralPatternsEvent extends Equatable {
  const BehavioralPatternsEvent();

  @override
  List<Object> get props => [];
}

class BehavioralPatternsFrequencyHeatmapEvent extends BehavioralPatternsEvent {
  const BehavioralPatternsFrequencyHeatmapEvent({required this.callType});
  final String callType;

  @override
  List<Object> get props => [callType];
}
