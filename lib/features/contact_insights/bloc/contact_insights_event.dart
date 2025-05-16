part of 'contact_insights_bloc.dart';

sealed class ContactInsightsEvent extends Equatable {
  const ContactInsightsEvent();

  @override
  List<Object?> get props => [];
}

class ContactInsightsLoadContactsEvent extends ContactInsightsEvent {
  const ContactInsightsLoadContactsEvent();
}

class ContactInsightsCalculateEvent extends ContactInsightsEvent {
  const ContactInsightsCalculateEvent({
    required this.contacts,
    required this.phoneNumber,
    required this.displayName,
  });
  final String phoneNumber;
  final String displayName;
  final List<Map<String, String>> contacts;

  @override
  List<Object?> get props => [phoneNumber, displayName, contacts];
}
