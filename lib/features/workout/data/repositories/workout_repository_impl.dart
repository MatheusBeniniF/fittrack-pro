import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/workout.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/workout_local_data_source.dart';
import '../models/workout_model.dart';

@LazySingleton(as: WorkoutRepository)
class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutLocalDataSource localDataSource;

  const WorkoutRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Workout>>> getWorkouts() async {
    try {
      final workoutModels = await localDataSource.getWorkouts();
      final workouts = workoutModels.map((model) => model.toEntity()).toList();
      return Right(workouts);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get workouts: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Workout>> getWorkoutById(String id) async {
    try {
      final workoutModel = await localDataSource.getWorkoutById(id);
      return Right(workoutModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get workout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> createWorkout(Workout workout) async {
    try {
      final workoutModel = WorkoutModel.fromEntity(workout);
      final id = await localDataSource.createWorkout(workoutModel);
      return Right(id);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to create workout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateWorkout(Workout workout) async {
    try {
      final workoutModel = WorkoutModel.fromEntity(workout);
      await localDataSource.updateWorkout(workoutModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to update workout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkout(String id) async {
    try {
      await localDataSource.deleteWorkout(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to delete workout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> startWorkout(Workout workout) async {
    try {
      final workoutModel = WorkoutModel.fromEntity(workout.copyWith(
        status: WorkoutStatus.inProgress,
        startTime: DateTime.now(),
      ));
      await localDataSource.setCurrentWorkout(workoutModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to start workout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> pauseWorkout(String workoutId) async {
    try {
      await localDataSource.pauseCurrentWorkout();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to pause workout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> resumeWorkout(String workoutId) async {
    try {
      await localDataSource.resumeCurrentWorkout();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to resume workout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> stopWorkout(String workoutId) async {
    try {
      await localDataSource.stopCurrentWorkout();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to stop workout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addWorkoutPoint(
    String workoutId,
    WorkoutPoint point,
  ) async {
    try {
      final pointModel = WorkoutPointModel.fromEntity(point);
      await localDataSource.addWorkoutPoint(workoutId, pointModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to add workout point: ${e.toString()}'));
    }
  }

  @override
  Stream<Workout?> getCurrentWorkoutStream() {
    return localDataSource.getCurrentWorkoutStream().map(
      (workoutModel) => workoutModel?.toEntity(),
    );
  }

  @override
  Stream<List<WorkoutPoint>> getWorkoutPointsStream(String workoutId) {
    return localDataSource.getWorkoutPointsStream(workoutId).map(
      (pointModels) => pointModels.map((model) => model.toEntity()).toList(),
    );
  }
}
