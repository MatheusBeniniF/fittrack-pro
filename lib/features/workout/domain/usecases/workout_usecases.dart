import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

@injectable
class GetWorkouts {
  final WorkoutRepository repository;

  const GetWorkouts(this.repository);

  Future<Either<Failure, List<Workout>>> call() async {
    return await repository.getWorkouts();
  }
}

@injectable
class StartWorkout {
  final WorkoutRepository repository;

  const StartWorkout(this.repository);

  Future<Either<Failure, void>> call(Workout workout) async {
    return await repository.startWorkout(workout);
  }
}

@injectable
class PauseWorkout {
  final WorkoutRepository repository;

  const PauseWorkout(this.repository);

  Future<Either<Failure, void>> call(String workoutId) async {
    return await repository.pauseWorkout(workoutId);
  }
}

@injectable
class ResumeWorkout {
  final WorkoutRepository repository;

  const ResumeWorkout(this.repository);

  Future<Either<Failure, void>> call(String workoutId) async {
    return await repository.resumeWorkout(workoutId);
  }
}

@injectable
class StopWorkout {
  final WorkoutRepository repository;

  const StopWorkout(this.repository);

  Future<Either<Failure, void>> call(String workoutId) async {
    return await repository.stopWorkout(workoutId);
  }
}

@injectable
class GetCurrentWorkout {
  final WorkoutRepository repository;

  const GetCurrentWorkout(this.repository);

  Stream<Workout?> call() {
    return repository.getCurrentWorkoutStream();
  }
}

@injectable
class AddWorkoutPoint {
  final WorkoutRepository repository;

  const AddWorkoutPoint(this.repository);

  Future<Either<Failure, void>> call(String workoutId, WorkoutPoint point) async {
    return await repository.addWorkoutPoint(workoutId, point);
  }
}
