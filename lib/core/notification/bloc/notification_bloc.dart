import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_recap/core/services/services.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService notificationService;

  NotificationBloc({required this.notificationService})
    : super(NotificationState()) {
    on<CheckPermission>(_handleCheckPermission);
    on<RequestPermission>(_handleRequestPermission);
    on<OpenSettings>(_handleOpenSettings);
    on<ScheduleNotification>(_handleScheduleNotification);
    on<CancelAllNotifications>(_handleCancelAllNotifications);
  }

  Future<void> _handleCheckPermission(
    CheckPermission event,
    Emitter<NotificationState> emit,
  ) async {
    final hasPermission = await notificationService.checkPermissions();
    final isPermanentlyDenied = await notificationService.isPermanentlyDenied();
    final isNotificationEnabled =
        await notificationService.isNotificationEnabled();
    emit(
      NotificationState(
        hasPermission: hasPermission,
        isPermanentlyDenied: isPermanentlyDenied,
        isEnabled: isNotificationEnabled,
      ),
    );
  }

  Future<void> _handleRequestPermission(
    RequestPermission event,
    Emitter<NotificationState> emit,
  ) async {
    final status = await notificationService.requestPermissions();
    final isEnabled = await notificationService.isNotificationEnabled();

    emit(
      NotificationState(
        hasPermission: status.isGranted,
        isPermanentlyDenied: status.isPermanentlyDenied,
        isEnabled: isEnabled,
      ),
    );
  }

  Future<void> _handleOpenSettings(
    OpenSettings event,
    Emitter<NotificationState> emit,
  ) async {
    final opened = await notificationService.openSettings();
    if (opened) {
      add(CheckPermission());
    }
  }

  Future<void> _handleScheduleNotification(
    ScheduleNotification event,
    Emitter<NotificationState> emit,
  ) async {
    await notificationService.enableNotifications();
    await notificationService.scheduleNotification();
    add(CheckPermission());
  }

  Future<void> _handleCancelAllNotifications(
    CancelAllNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    await notificationService.cancelAllNotifications();
    add(CheckPermission());
  }
}
