part of 'advanced_metrics_bloc.dart';

enum Status { loading, complete, error }

class AdvancedMetricsState extends Equatable {
  const AdvancedMetricsState({
    this.status = Status.loading,
    this.missedCalls = 0,
    this.rejectedCalls = 0,
    this.blockedCalls = 0,
  });

  final Status status;
  final int missedCalls;
  final int rejectedCalls;
  final int blockedCalls;

  @override
  List<Object> get props => [status, missedCalls, rejectedCalls, blockedCalls];
}
