part of 'contact_insights_bloc.dart';

enum Status { loading, complete, error, empty }

class ContactInsightsState extends Equatable {
  const ContactInsightsState({
    this.status = Status.loading,
    this.contacts = const [],
    this.averageDuration = 0.0,
    this.totalCalls = 0,
    this.totalDuration = 0,
    this.selectedContactPhoneNumber = "",
    this.answeredCalls = 0,
    this.longestStreak = const [],
  });

  final Status status;
  final String selectedContactPhoneNumber;
  final List<Map<String, String>> contacts;
  final double averageDuration;
  final int totalCalls;
  final int totalDuration;
  final int answeredCalls;
  final List<CallLogEntry> longestStreak;

  @override
  List<Object?> get props => [
    status,
    contacts,
    averageDuration,
    selectedContactPhoneNumber,
    answeredCalls,
    longestStreak,
    totalCalls,
    totalDuration,
  ];
}
