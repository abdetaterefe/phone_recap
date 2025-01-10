part of 'home_bloc.dart';

enum Status { loading, complete, error }

class HomeState extends Equatable {
  const HomeState({
    this.yearsListStatus = Status.loading,
    this.yearsList = const [],
  });

  final Status yearsListStatus;
  final List<int> yearsList;

  @override
  List<Object> get props => [yearsListStatus, yearsList];
}
