part of 'home_bloc.dart';

enum Status { loading, complete, error }

class HomeState extends Equatable {
  const HomeState({
    this.totalDuration = 0,
    this.averageDuration = 0,
    this.topContactsByDuration = const [
      MapEntry("A", 0),
      MapEntry("A", 0),
      MapEntry("A", 0),
    ],
    this.callVolumeChartData = const [],
    this.status = Status.loading,
  });

  final Status status;
  final int totalDuration;
  final double averageDuration;
  final List<MapEntry<String, int>> topContactsByDuration;
  final List<FlSpot> callVolumeChartData;

  @override
  List<Object> get props => [
    status,
    totalDuration,
    averageDuration,
    topContactsByDuration,
    callVolumeChartData,
  ];
}
