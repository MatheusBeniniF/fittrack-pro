import 'package:flutter_test/flutter_test.dart';
import 'package:fittrack_pro/features/workout/domain/entities/workout.dart';

void main() {
  group('Workout Entity Tests', () {
    late DateTime testStartTime;

    setUp(() {
      testStartTime = DateTime(2024, 1, 15, 10, 0);
    });

    test('should create workout with required properties', () {
      final workout = Workout(
        id: 'test-workout-1',
        name: 'Morning Run',
        type: WorkoutType.running,
        startTime: testStartTime,
        duration: const Duration(hours: 1),
        caloriesBurned: 300.0,
        distanceMeters: 5000.0,
        averageHeartRate: 145,
        maxHeartRate: 180,
        status: WorkoutStatus.completed,
        points: const [],
      );

      expect(workout.id, 'test-workout-1');
      expect(workout.name, 'Morning Run');
      expect(workout.type, WorkoutType.running);
      expect(workout.startTime, testStartTime);
      expect(workout.duration, const Duration(hours: 1));
      expect(workout.caloriesBurned, 300.0);
      expect(workout.distanceMeters, 5000.0);
      expect(workout.averageHeartRate, 145);
      expect(workout.maxHeartRate, 180);
      expect(workout.status, WorkoutStatus.completed);
      expect(workout.points, isEmpty);
    });

    test('should support equality comparison', () {
      final workout1 = Workout(
        id: 'test-1',
        name: 'Test',
        type: WorkoutType.running,
        startTime: testStartTime,
        duration: const Duration(minutes: 30),
        caloriesBurned: 200.0,
        distanceMeters: 3000.0,
        averageHeartRate: 140,
        maxHeartRate: 170,
        status: WorkoutStatus.completed,
        points: const [],
      );

      final workout2 = Workout(
        id: 'test-1',
        name: 'Test',
        type: WorkoutType.running,
        startTime: testStartTime,
        duration: const Duration(minutes: 30),
        caloriesBurned: 200.0,
        distanceMeters: 3000.0,
        averageHeartRate: 140,
        maxHeartRate: 170,
        status: WorkoutStatus.completed,
        points: const [],
      );

      expect(workout1, equals(workout2));
    });

    test('should create copy with updated properties', () {
      final originalWorkout = Workout(
        id: 'test-1',
        name: 'Original',
        type: WorkoutType.running,
        startTime: testStartTime,
        duration: const Duration(minutes: 30),
        caloriesBurned: 200.0,
        distanceMeters: 3000.0,
        averageHeartRate: 140,
        maxHeartRate: 170,
        status: WorkoutStatus.inProgress,
        points: const [],
      );

      final updatedWorkout = originalWorkout.copyWith(
        name: 'Updated',
        status: WorkoutStatus.completed,
        caloriesBurned: 250.0,
      );

      expect(updatedWorkout.id, originalWorkout.id);
      expect(updatedWorkout.name, 'Updated');
      expect(updatedWorkout.status, WorkoutStatus.completed);
      expect(updatedWorkout.caloriesBurned, 250.0);
      expect(updatedWorkout.type, originalWorkout.type);
      expect(updatedWorkout.startTime, originalWorkout.startTime);
    });

    test('should handle optional properties', () {
      final workout = Workout(
        id: 'test-1',
        name: 'Test',
        type: WorkoutType.running,
        startTime: testStartTime,
        duration: const Duration(minutes: 30),
        caloriesBurned: 200.0,
        distanceMeters: 3000.0,
        averageHeartRate: 140,
        maxHeartRate: 170,
        status: WorkoutStatus.completed,
        points: const [],
        // endTime and notes are optional
      );

      expect(workout.endTime, isNull);
      expect(workout.notes, isNull);
    });
  });

  group('WorkoutPoint Entity Tests', () {
    late DateTime testTimestamp;

    setUp(() {
      testTimestamp = DateTime(2024, 1, 15, 10, 30);
    });

    test('should create workout point with required properties', () {
      final workoutPoint = WorkoutPoint(
        timestamp: testTimestamp,
        heartRate: 155,
        distanceFromStart: 2500.0,
      );

      expect(workoutPoint.timestamp, testTimestamp);
      expect(workoutPoint.heartRate, 155);
      expect(workoutPoint.distanceFromStart, 2500.0);
    });

    test('should handle optional location properties', () {
      final workoutPoint = WorkoutPoint(
        timestamp: testTimestamp,
        heartRate: 155,
        latitude: 37.7749,
        longitude: -122.4194,
        altitude: 150.0,
        speed: 6.0,
        distanceFromStart: 2500.0,
      );

      expect(workoutPoint.latitude, 37.7749);
      expect(workoutPoint.longitude, -122.4194);
      expect(workoutPoint.altitude, 150.0);
      expect(workoutPoint.speed, 6.0);
    });

    test('should support equality comparison', () {
      final point1 = WorkoutPoint(
        timestamp: testTimestamp,
        heartRate: 155,
        distanceFromStart: 2500.0,
      );

      final point2 = WorkoutPoint(
        timestamp: testTimestamp,
        heartRate: 155,
        distanceFromStart: 2500.0,
      );

      expect(point1, equals(point2));
    });
  });

  group('WorkoutType Enum Tests', () {
    test('should contain all expected workout types', () {
      expect(WorkoutType.values, contains(WorkoutType.running));
      expect(WorkoutType.values, contains(WorkoutType.cycling));
      expect(WorkoutType.values, contains(WorkoutType.swimming));
      expect(WorkoutType.values, contains(WorkoutType.walking));
      expect(WorkoutType.values, contains(WorkoutType.strength));
      expect(WorkoutType.values, contains(WorkoutType.yoga));
      expect(WorkoutType.values, contains(WorkoutType.cardio));
      expect(WorkoutType.values, contains(WorkoutType.other));
    });
  });

  group('WorkoutStatus Enum Tests', () {
    test('should contain all expected workout statuses', () {
      expect(WorkoutStatus.values, contains(WorkoutStatus.planned));
      expect(WorkoutStatus.values, contains(WorkoutStatus.inProgress));
      expect(WorkoutStatus.values, contains(WorkoutStatus.paused));
      expect(WorkoutStatus.values, contains(WorkoutStatus.completed));
      expect(WorkoutStatus.values, contains(WorkoutStatus.cancelled));
    });
  });
}
