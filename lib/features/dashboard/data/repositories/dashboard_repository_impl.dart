import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/workout_stats.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/dashboard_repository.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<Either<Failure, WorkoutStats>> getWorkoutStats() async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final stats = WorkoutStats(
        totalWorkouts: 24,
        totalDuration: const Duration(hours: 18, minutes: 30),
        totalCalories: 3250.0,
        totalDistance: 45600.0, // meters
        averageHeartRate: 142,
        lastWorkoutDate: DateTime.now().subtract(const Duration(days: 1)),
        dailyStats: _generateDailyStats(),
        weeklyStats: _generateWeeklyStats(),
        workoutTypeDistribution: const {
          'Running': 40.0,
          'Strength': 30.0,
          'Cycling': 20.0,
          'Yoga': 10.0,
        },
      );
      
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure('Failed to get workout stats: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      final profile = UserProfile(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        birthDate: DateTime(1990, 5, 15),
        heightCm: 175.0,
        weightKg: 70.0,
        profileImageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
        preferences: const UserPreferences(
          notificationsEnabled: true,
          soundEnabled: true,
          vibrationEnabled: true,
          distanceUnit: 'km',
          weightUnit: 'kg',
          darkModeEnabled: false,
          dailyCalorieGoal: 500,
          dailyWorkoutGoal: Duration(minutes: 30),
        ),
      );
      
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure('Failed to get user profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(UserProfile profile) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update user profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<WeeklyStats>>> getWeeklyStats(DateTime startDate) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      final weeklyStats = _generateWeeklyStats();
      return Right(weeklyStats);
    } catch (e) {
      return Left(ServerFailure('Failed to get weekly stats: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutStats>>> getMonthlyStats(DateTime startDate) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      final monthlyStats = <WorkoutStats>[];
      return Right(monthlyStats);
    } catch (e) {
      return Left(ServerFailure('Failed to get monthly stats: ${e.toString()}'));
    }
  }

  @override
  Stream<WorkoutStats> getWorkoutStatsStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 30));
      
      final statsResult = await getWorkoutStats();
      yield statsResult.fold(
        (failure) => throw Exception(failure.message),
        (stats) => stats,
      );
    }
  }

  List<DailyStats> _generateDailyStats() {
    final List<DailyStats> stats = [];
    final now = DateTime.now();
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      stats.add(DailyStats(
        date: date,
        workouts: (i % 3 == 0) ? 0 : 1 + (i % 2),
        duration: Duration(minutes: 30 + (i * 15) % 90),
        calories: 150 + (i * 50.0) % 300,
        distance: 2000 + (i * 1000.0) % 5000,
      ));
    }
    
    return stats;
  }

  List<WeeklyStats> _generateWeeklyStats() {
    final List<WeeklyStats> stats = [];
    final now = DateTime.now();
    for (int i = 3; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: i * 7));
      stats.add(WeeklyStats(
        weekStart: weekStart,
        workouts: 4 + (i % 3),
        duration: Duration(hours: 3 + i, minutes: 30),
        calories: 800 + (i * 200.0),
        distance: 15000 + (i * 5000.0),
      ));
    }
    return stats;
  }
}
