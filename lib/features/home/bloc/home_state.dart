part of 'home_bloc.dart';

enum Status { loading, complete, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = Status.loading,
    this.totalDuration = 0,
    this.averageDuration = 0,
    this.topContactsByDuration = const [
      MapEntry("A", 0),
      MapEntry("A", 0),
      MapEntry("A", 0),
    ],
    this.callVolumeChartData = const [],
    this.frequencyHeatmap = const {},
    this.missedCalls = 0,
    this.rejectedCalls = 0,
    this.blockedCalls = 0,
  });

  final Status status;
  final int totalDuration;
  final double averageDuration;
  final List<MapEntry<String, int>> topContactsByDuration;
  final List<FlSpot> callVolumeChartData;
  final Map<int, Map<int, int>> frequencyHeatmap;
  final int missedCalls;
  final int rejectedCalls;
  final int blockedCalls;

  @override
  List<Object> get props => [
    status,
    totalDuration,
    averageDuration,
    topContactsByDuration,
    callVolumeChartData,
    frequencyHeatmap,
    missedCalls,
    rejectedCalls,
    blockedCalls,
  ];
}
