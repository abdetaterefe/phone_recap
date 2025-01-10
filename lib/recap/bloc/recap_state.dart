part of 'recap_bloc.dart';

enum Status { loading, complete, error }

class RecapState extends Equatable {
  const RecapState({
    this.recapListStatus = Status.loading,
    this.recapList = const {},
  });

  final Status recapListStatus;
  final Map<String, List<CallLogEntry>> recapList;

  @override
  List<Object> get props => [recapListStatus, recapList];
}
