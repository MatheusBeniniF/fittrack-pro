import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/workout_stats.dart';
import '../entities/user_profile.dart';

abstract class DashboardRepository {
  Future<Either<Failure, WorkoutStats>> getWorkoutStats();
  Future<Either<Failure, UserProfile>> getUserProfile();
  Future<Either<Failure, void>> updateUserProfile(UserProfile profile);
  Future<Either<Failure, List<WeeklyStats>>> getWeeklyStats(DateTime startDate);
  Future<Either<Failure, List<WorkoutStats>>> getMonthlyStats(DateTime startDate);
  Stream<WorkoutStats> getWorkoutStatsStream();
}
