part of 'advanced_metrics_bloc.dart';

sealed class AdvancedMetricsEvent extends Equatable {
  const AdvancedMetricsEvent();

  @override
  List<Object> get props => [];
}

class AdvancedMetricsLoadEvent extends AdvancedMetricsEvent {}
