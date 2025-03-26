import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const String _notificationEnabledKey = 'notification_enabled';
  static const String _channelId = 'weekly_channel_id';
  static const String _channelName = 'Weekly Notifications';
  static const String _channelDescription = 'Weekly notifications channel';

  final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidInitializationSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _notificationPlugin.initialize(initializationSettings);
    _isInitialized = true;
  }

  Future<PermissionStatus> requestPermissions() async {
    return await Permission.notification.request();
  }

  Future<bool> checkPermissions() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<bool> isPermanentlyDenied() async {
    final status = await Permission.notification.status;
    return status.isPermanentlyDenied;
  }

  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  Future<bool> scheduleNotification() async {
    if (!_isInitialized) await initialize();

    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_notificationEnabledKey) ?? false)) return false;

    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        final status = await requestPermissions();
        if (!status.isGranted) return false;
      }

      final now = tz.TZDateTime.now(tz.local);

      int weekday = now.weekday;
      int daysToAdd = DateTime.sunday - weekday;
      final endDayOfWeek = now
          .add(Duration(days: daysToAdd))
          .copyWith(hour: 23, minute: 59, second: 59, millisecond: 999);

      tz.TZDateTime scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        endDayOfWeek.day,
        20,
        0,
      );

      await _notificationPlugin.zonedSchedule(
        0,
        'Reminder',
        'Click here to see your call history',
        scheduledTime,
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exact,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> enableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, true);
  }

  Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationEnabledKey) ?? false;
  }

  Future<void> cancelAllNotifications() async {
    await _notificationPlugin.cancelAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, false);
  }
}
