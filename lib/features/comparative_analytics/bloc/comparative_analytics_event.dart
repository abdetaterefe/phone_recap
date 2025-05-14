part of 'comparative_analytics_bloc.dart';

sealed class ComparativeAnalyticsEvent extends Equatable {
  const ComparativeAnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class ComparativeAnalyticsLoadContactsEvent extends ComparativeAnalyticsEvent {
  const ComparativeAnalyticsLoadContactsEvent();
}

class ComparativeAnalyticsCalculateEvent extends ComparativeAnalyticsEvent {
  const ComparativeAnalyticsCalculateEvent({
    required this.firstPhoneNumber,
    required this.secondPhoneNumber,
    required this.contacts,
  });

  final String firstPhoneNumber;
  final String secondPhoneNumber;
  final List<Map<String, String>> contacts;

  @override
  List<Object?> get props => [firstPhoneNumber, secondPhoneNumber, contacts];
}
