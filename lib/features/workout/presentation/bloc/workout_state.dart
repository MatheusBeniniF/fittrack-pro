part of 'workout_bloc.dart';

abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutInProgress extends WorkoutState {
  final Workout workout;
  final Duration elapsed;
  final int currentHeartRate;
  final double currentDistance;
  final double currentCalories;
  final bool isPaused;
  final List<WorkoutPoint> points;

  const WorkoutInProgress({
    required this.workout,
    required this.elapsed,
    required this.currentHeartRate,
    required this.currentDistance,
    required this.currentCalories,
    required this.isPaused,
    required this.points,
  });

  WorkoutInProgress copyWith({
    Workout? workout,
    Duration? elapsed,
    int? currentHeartRate,
    double? currentDistance,
    double? currentCalories,
    bool? isPaused,
    List<WorkoutPoint>? points,
  }) {
    return WorkoutInProgress(
      workout: workout ?? this.workout,
      elapsed: elapsed ?? this.elapsed,
      currentHeartRate: currentHeartRate ?? this.currentHeartRate,
      currentDistance: currentDistance ?? this.currentDistance,
      currentCalories: currentCalories ?? this.currentCalories,
      isPaused: isPaused ?? this.isPaused,
      points: points ?? this.points,
    );
  }

  @override
  List<Object> get props => [
        workout,
        elapsed,
        currentHeartRate,
        currentDistance,
        currentCalories,
        isPaused,
        points,
      ];
}

class WorkoutCompleted extends WorkoutState {
  final Workout workout;

  const WorkoutCompleted(this.workout);

  @override
  List<Object> get props => [workout];
}

class WorkoutError extends WorkoutState {
  final String message;

  const WorkoutError(this.message);

  @override
  List<Object> get props => [message];
}
