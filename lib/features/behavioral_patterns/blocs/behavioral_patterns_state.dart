part of 'behavioral_patterns_bloc.dart';

enum Status { loading, complete, error }

class BehavioralPatternsState extends Equatable {
  const BehavioralPatternsState({
    this.status = Status.loading,
    this.frequencyHeatmap = const {},
  });

  final Status status;
  final Map<int, Map<int, int>> frequencyHeatmap;

  @override
  List<Object> get props => [status, frequencyHeatmap];
}
