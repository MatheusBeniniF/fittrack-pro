import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  static String formatCalories(double calories) {
    if (calories >= 1000) {
      return '${(calories / 1000).toStringAsFixed(1)}k';
    }
    return calories.toStringAsFixed(0);
  }

  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters >= 1000) {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
    return '${distanceInMeters.toStringAsFixed(0)} m';
  }

  static String formatHeartRate(int bpm) {
    return '$bpm BPM';
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static void hapticFeedback() {
    HapticFeedback.lightImpact();
  }

  static void hapticSuccess() {
    HapticFeedback.heavyImpact();
  }

  static void hapticError() {
    HapticFeedback.vibrate();
  }

  static double calculateBMI(double weightKg, double heightM) {
    return weightKg / (heightM * heightM);
  }

  static double calculateCaloriesBurned({
    required double met,
    required double weightKg,
    required Duration duration,
  }) {
    final hours = duration.inMinutes / 60.0;
    return met * weightKg * hours;
  }

  static String getTimeOfDayGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  static List<T> shuffleList<T>(List<T> list) {
    final newList = List<T>.from(list);
    newList.shuffle();
    return newList;
  }

  static T? safeParseEnum<T extends Enum>(
    List<T> values,
    String? value, [
    T? defaultValue,
  ]) {
    if (value == null) return defaultValue;
    try {
      return values.firstWhere(
        (e) => e.toString().split('.').last == value,
        orElse: () => defaultValue!,
      );
    } catch (_) {
      return defaultValue;
    }
  }
}
