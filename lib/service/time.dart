class Time {
  /// Get time of last [period].
  static int getLastPeriod(int period) {
    double time = getTime() / 1000;
    time = time - (time % period);
    time *= 1000;
    return time.toInt();
  }

  /// Get the time left in current [period].
  static int getTimeLeftInPeriod(int period) {
    return period - (getTime() % period);
  }

  /// Get current time in milliseconds.
  static int getTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
