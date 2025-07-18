import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/workout.dart';

abstract class WorkoutRepository {
  Future<Either<Failure, List<Workout>>> getWorkouts();
  Future<Either<Failure, Workout>> getWorkoutById(String id);
  Future<Either<Failure, String>> createWorkout(Workout workout);
  Future<Either<Failure, void>> updateWorkout(Workout workout);
  Future<Either<Failure, void>> deleteWorkout(String id);
  Future<Either<Failure, void>> startWorkout(Workout workout);
  Future<Either<Failure, void>> pauseWorkout(String workoutId);
  Future<Either<Failure, void>> resumeWorkout(String workoutId);
  Future<Either<Failure, void>> stopWorkout(String workoutId);
  Future<Either<Failure, void>> addWorkoutPoint(String workoutId, WorkoutPoint point);
  Stream<Workout?> getCurrentWorkoutStream();
  Stream<List<WorkoutPoint>> getWorkoutPointsStream(String workoutId);
}
