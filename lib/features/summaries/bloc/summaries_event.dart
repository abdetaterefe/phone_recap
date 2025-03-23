part of 'summaries_bloc.dart';

sealed class SummariesEvent extends Equatable {
  const SummariesEvent();

  @override
  List<Object?> get props => [];
}

class SummariesLoadEvent extends SummariesEvent {}