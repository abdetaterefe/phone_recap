import 'package:phone_recap/features/comparative_analytics/comparative_analytics.dart';

enum ComparisonType { withMe, betweenNumbers }

class ComparisonResult {
  final CallStatistics firstStats;
  final CallStatistics secondStats;

  const ComparisonResult({
    this.firstStats = const CallStatistics(),
    this.secondStats = const CallStatistics(),
  });
}
