part of 'workout_bloc.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => [];
}

class StartWorkoutEvent extends WorkoutEvent {
  final Workout workout;

  const StartWorkoutEvent(this.workout);

  @override
  List<Object> get props => [workout];
}

class PauseWorkoutEvent extends WorkoutEvent {
  final String workoutId;

  const PauseWorkoutEvent(this.workoutId);

  @override
  List<Object> get props => [workoutId];
}

class ResumeWorkoutEvent extends WorkoutEvent {
  final String workoutId;

  const ResumeWorkoutEvent(this.workoutId);

  @override
  List<Object> get props => [workoutId];
}

class StopWorkoutEvent extends WorkoutEvent {
  final String workoutId;

  const StopWorkoutEvent(this.workoutId);

  @override
  List<Object> get props => [workoutId];
}

class UpdateHeartRateEvent extends WorkoutEvent {
  final int heartRate;

  const UpdateHeartRateEvent(this.heartRate);

  @override
  List<Object> get props => [heartRate];
}

class UpdateLocationEvent extends WorkoutEvent {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? speed;

  const UpdateLocationEvent({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.speed,
  });

  @override
  List<Object?> get props => [latitude, longitude, altitude, speed];
}

class WorkoutTimerTickEvent extends WorkoutEvent {}

class LoadCurrentWorkoutEvent extends WorkoutEvent {}
