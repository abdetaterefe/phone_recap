part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final bool hasPermission;
  final bool isPermanentlyDenied;
  final bool isEnabled;

  const NotificationState({
    this.hasPermission = false,
    this.isPermanentlyDenied = false,
    this.isEnabled = false,
  });

  @override
  List<Object> get props => [hasPermission, isPermanentlyDenied, isEnabled];
}
