part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class CheckPermission extends NotificationEvent {}

class RequestPermission extends NotificationEvent {}

class OpenSettings extends NotificationEvent {}

class ScheduleNotification extends NotificationEvent {}

class CancelAllNotifications extends NotificationEvent {}
