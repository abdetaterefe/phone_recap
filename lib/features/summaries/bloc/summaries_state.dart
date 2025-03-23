part of 'summaries_bloc.dart';

enum Status { loading, complete, error }

class SummariesState extends Equatable {
  const SummariesState({
    this.status = Status.loading,
    this.summaries = const {},
  });

  final Status status;
  final Map<String, List<CallLogEntry>> summaries;

  @override
  List<Object?> get props => [status, summaries];
}
