part of 'comparative_analytics_bloc.dart';

enum Status { loading, complete, error }

class ComparativeAnalyticsState extends Equatable {
  const ComparativeAnalyticsState({
    this.status = Status.loading,
    this.errorMessage = "",
    this.isComparingMe = false,
    this.isFirstPhoneNumberMe = false,
    this.contacts = const [],
    this.firstNumber = "",
    this.secondNumber = "",
    this.firstDisplayName = "",
    this.secondDisplayName = "",
    this.comparisonResult = const ComparisonResult(),
  });

  final Status status;
  final String errorMessage;
  final bool isComparingMe;
  final bool isFirstPhoneNumberMe;
  final List<Map<String, String>> contacts;
  final String firstNumber;
  final String secondNumber;
  final String firstDisplayName;
  final String secondDisplayName;

  final ComparisonResult comparisonResult;

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    isComparingMe,
    isFirstPhoneNumberMe,
    contacts,
    firstNumber,
    secondNumber,
    firstDisplayName,
    secondDisplayName,
  ];
}
