class CallStatistics {
  final int totalCalls;
  final int totalDuration;
  final double averageDuration;
  final String dayOfWeekPreference;
  final String timePreference;
  final int incomingCalls;
  final int outgoingCalls;

  const CallStatistics({
    this.totalCalls = 0,
    this.totalDuration = 0,
    this.averageDuration = 0,
    this.dayOfWeekPreference = '',
    this.timePreference = '',
    this.incomingCalls = 0,
    this.outgoingCalls = 0,
  });
}
