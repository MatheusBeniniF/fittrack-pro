import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fittrack_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fittrack_pro/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:fittrack_pro/features/workout/domain/usecases/workout_usecases.dart';
import 'package:fittrack_pro/features/workout/domain/entities/workout.dart';

// Mock classes
class MockGetWorkoutStats extends Mock implements GetWorkoutStats {}

class MockGetWorkoutStatsStream extends Mock implements GetWorkoutStatsStream {}

class MockGetUserProfile extends Mock implements GetUserProfile {}

class MockUpdateUserProfile extends Mock implements UpdateUserProfile {}

class MockStartWorkout extends Mock implements StartWorkout {}

void main() {
  late DashboardCubit dashboardCubit;
  late MockGetWorkoutStats mockGetWorkoutStats;
  late MockGetWorkoutStatsStream mockGetWorkoutStatsStream;
  late MockGetUserProfile mockGetUserProfile;
  late MockUpdateUserProfile mockUpdateUserProfile;
  late MockStartWorkout mockStartWorkout;

  setUp(() {
    mockGetWorkoutStats = MockGetWorkoutStats();
    mockGetWorkoutStatsStream = MockGetWorkoutStatsStream();
    mockGetUserProfile = MockGetUserProfile();
    mockUpdateUserProfile = MockUpdateUserProfile();
    mockStartWorkout = MockStartWorkout();

    dashboardCubit = DashboardCubit(
      mockGetWorkoutStats,
      mockGetWorkoutStatsStream,
      mockGetUserProfile,
      mockUpdateUserProfile,
      mockStartWorkout,
    );

    registerFallbackValue(
      Workout(
        id: 'test',
        name: 'Test Workout',
        type: WorkoutType.running,
        startTime: DateTime.now(),
        duration: Duration.zero,
        caloriesBurned: 0,
        distanceMeters: 0,
        averageHeartRate: 0,
        maxHeartRate: 0,
        status: WorkoutStatus.planned,
        points: const [],
      ),
    );
  });

  tearDown(() {
    dashboardCubit.close();
  });

  group('DashboardCubit', () {
    test('initial state should be DashboardInitial', () {
      expect(dashboardCubit.state, equals(DashboardInitial()));
    });
  });
}
