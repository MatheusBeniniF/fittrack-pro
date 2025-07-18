import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/workout_stats.dart';
import '../entities/user_profile.dart';
import '../repositories/dashboard_repository.dart';

@injectable
class GetWorkoutStats {
  final DashboardRepository repository;

  const GetWorkoutStats(this.repository);

  Future<Either<Failure, WorkoutStats>> call() async {
    return await repository.getWorkoutStats();
  }
}

@injectable
class GetWorkoutStatsStream {
  final DashboardRepository repository;

  const GetWorkoutStatsStream(this.repository);

  Stream<WorkoutStats> call() {
    return repository.getWorkoutStatsStream();
  }
}

@injectable
class GetUserProfile {
  final DashboardRepository repository;

  const GetUserProfile(this.repository);

  Future<Either<Failure, UserProfile>> call() async {
    return await repository.getUserProfile();
  }
}

@injectable
class UpdateUserProfile {
  final DashboardRepository repository;

  const UpdateUserProfile(this.repository);

  Future<Either<Failure, void>> call(UserProfile profile) async {
    return await repository.updateUserProfile(profile);
  }
}

@injectable
class GetWeeklyStats {
  final DashboardRepository repository;

  const GetWeeklyStats(this.repository);

  Future<Either<Failure, List<WeeklyStats>>> call(DateTime startDate) async {
    return await repository.getWeeklyStats(startDate);
  }
}

@injectable
class GetMonthlyStats {
  final DashboardRepository repository;

  const GetMonthlyStats(this.repository);

  Future<Either<Failure, List<WorkoutStats>>> call(DateTime startDate) async {
    return await repository.getMonthlyStats(startDate);
  }
}
