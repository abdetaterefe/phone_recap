class TimeUtils {
  static String formatDuration(int duration) {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    final seconds = duration % 60;

    final hoursStr = hours > 0 ? '$hours h ' : '';
    final minutesStr = minutes > 0 ? '$minutes min ' : '';
    final secondsStr = seconds > 0 ? '$seconds s' : '';

    return '$hoursStr$minutesStr$secondsStr';
  }

  static String getMonthName(DateTime date) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[date.month - 1];
  }

  static String getDayOfWeek(DateTime date) {
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return daysOfWeek[date.weekday - 1];
  }
}
