import 'package:equatable/equatable.dart';

class WorkoutStats extends Equatable {
  final int totalWorkouts;
  final Duration totalDuration;
  final double totalCalories;
  final double totalDistance;
  final int averageHeartRate;
  final DateTime lastWorkoutDate;
  final List<DailyStats> dailyStats;
  final List<WeeklyStats> weeklyStats;
  final Map<String, double> workoutTypeDistribution;

  const WorkoutStats({
    required this.totalWorkouts,
    required this.totalDuration,
    required this.totalCalories,
    required this.totalDistance,
    required this.averageHeartRate,
    required this.lastWorkoutDate,
    required this.dailyStats,
    required this.weeklyStats,
    required this.workoutTypeDistribution,
  });

  @override
  List<Object> get props => [
        totalWorkouts,
        totalDuration,
        totalCalories,
        totalDistance,
        averageHeartRate,
        lastWorkoutDate,
        dailyStats,
        weeklyStats,
        workoutTypeDistribution,
      ];
}

class DailyStats extends Equatable {
  final DateTime date;
  final int workouts;
  final Duration duration;
  final double calories;
  final double distance;

  const DailyStats({
    required this.date,
    required this.workouts,
    required this.duration,
    required this.calories,
    required this.distance,
  });

  @override
  List<Object> get props => [date, workouts, duration, calories, distance];
}

class WeeklyStats extends Equatable {
  final DateTime weekStart;
  final int workouts;
  final Duration duration;
  final double calories;
  final double distance;

  const WeeklyStats({
    required this.weekStart,
    required this.workouts,
    required this.duration,
    required this.calories,
    required this.distance,
  });

  @override
  List<Object> get props => [weekStart, workouts, duration, calories, distance];
}
