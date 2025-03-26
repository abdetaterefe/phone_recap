class Utils {
  static String persent(int value, int total) {
    final persent = (value / total) * 100;
    return persent.toStringAsFixed(2);
  }
}
