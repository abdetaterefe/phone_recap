part of 'recap_bloc.dart';

sealed class RecapEvent extends Equatable {
  const RecapEvent();

  @override
  List<Object> get props => [];
}

class RecapGetCallRecap extends RecapEvent {
  const RecapGetCallRecap({required this.year});
  final int year;
}
