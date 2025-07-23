import 'package:flutter_test/flutter_test.dart';
import 'package:fittrack_pro/features/workout/data/models/workout_model.dart';
import 'package:fittrack_pro/features/workout/domain/entities/workout.dart';

void main() {
  group('WorkoutModel', () {
    late WorkoutModel testWorkoutModel;
    late Workout testWorkoutEntity;
    late DateTime testStartTime;
    late DateTime testEndTime;

    setUp(() {
      testStartTime = DateTime(2024, 1, 15, 10, 0);
      testEndTime = DateTime(2024, 1, 15, 11, 0);

      testWorkoutModel = WorkoutModel(
        id: 'test-workout-1',
        name: 'Morning Run',
        type: WorkoutType.running,
        startTime: testStartTime,
        endTime: testEndTime,
        duration: const Duration(hours: 1),
        caloriesBurned: 300.0,
        distanceMeters: 5000.0,
        averageHeartRate: 145,
        maxHeartRate: 180,
        status: WorkoutStatus.completed,
        notes: 'Great workout!',
        points: [
          WorkoutPointModel(
            timestamp: testStartTime.add(const Duration(minutes: 30)),
            heartRate: 150,
            latitude: 37.7749,
            longitude: -122.4194,
            altitude: 100.0,
            speed: 5.5,
            distanceFromStart: 2500.0,
          ),
        ],
      );

      testWorkoutEntity = Workout(
        id: 'test-workout-1',
        name: 'Morning Run',
        type: WorkoutType.running,
        startTime: testStartTime,
        endTime: testEndTime,
        duration: const Duration(hours: 1),
        caloriesBurned: 300.0,
        distanceMeters: 5000.0,
        averageHeartRate: 145,
        maxHeartRate: 180,
        status: WorkoutStatus.completed,
        notes: 'Great workout!',
        points: [
          WorkoutPoint(
            timestamp: testStartTime.add(const Duration(minutes: 30)),
            heartRate: 150,
            latitude: 37.7749,
            longitude: -122.4194,
            altitude: 100.0,
            speed: 5.5,
            distanceFromStart: 2500.0,
          ),
        ],
      );
    });

    test('should create WorkoutModel with all properties', () {
      expect(testWorkoutModel.id, 'test-workout-1');
      expect(testWorkoutModel.name, 'Morning Run');
      expect(testWorkoutModel.type, WorkoutType.running);
      expect(testWorkoutModel.startTime, testStartTime);
      expect(testWorkoutModel.endTime, testEndTime);
      expect(testWorkoutModel.duration, const Duration(hours: 1));
      expect(testWorkoutModel.caloriesBurned, 300.0);
      expect(testWorkoutModel.distanceMeters, 5000.0);
      expect(testWorkoutModel.averageHeartRate, 145);
      expect(testWorkoutModel.maxHeartRate, 180);
      expect(testWorkoutModel.status, WorkoutStatus.completed);
      expect(testWorkoutModel.notes, 'Great workout!');
      expect(testWorkoutModel.points.length, 1);
    });

    test('should serialize to and from JSON correctly', () {
      // Arrange
      final json = testWorkoutModel.toJson();

      // Act
      final fromJson = WorkoutModel.fromJson(json);

      // Assert
      expect(fromJson.id, testWorkoutModel.id);
      expect(fromJson.name, testWorkoutModel.name);
      expect(fromJson.type, testWorkoutModel.type);
      expect(fromJson.startTime, testWorkoutModel.startTime);
      expect(fromJson.endTime, testWorkoutModel.endTime);
      expect(fromJson.duration, testWorkoutModel.duration);
      expect(fromJson.caloriesBurned, testWorkoutModel.caloriesBurned);
      expect(fromJson.distanceMeters, testWorkoutModel.distanceMeters);
      expect(fromJson.averageHeartRate, testWorkoutModel.averageHeartRate);
      expect(fromJson.maxHeartRate, testWorkoutModel.maxHeartRate);
      expect(fromJson.status, testWorkoutModel.status);
      expect(fromJson.notes, testWorkoutModel.notes);
      expect(fromJson.points.length, testWorkoutModel.points.length);
    });

    test('should create WorkoutModel from Workout entity', () {
      // Act
      final workoutModel = WorkoutModel.fromEntity(testWorkoutEntity);

      // Assert
      expect(workoutModel.id, testWorkoutEntity.id);
      expect(workoutModel.name, testWorkoutEntity.name);
      expect(workoutModel.type, testWorkoutEntity.type);
      expect(workoutModel.startTime, testWorkoutEntity.startTime);
      expect(workoutModel.endTime, testWorkoutEntity.endTime);
      expect(workoutModel.duration, testWorkoutEntity.duration);
      expect(workoutModel.caloriesBurned, testWorkoutEntity.caloriesBurned);
      expect(workoutModel.distanceMeters, testWorkoutEntity.distanceMeters);
      expect(workoutModel.averageHeartRate, testWorkoutEntity.averageHeartRate);
      expect(workoutModel.maxHeartRate, testWorkoutEntity.maxHeartRate);
      expect(workoutModel.status, testWorkoutEntity.status);
      expect(workoutModel.notes, testWorkoutEntity.notes);
      expect(workoutModel.points.length, testWorkoutEntity.points.length);
    });

    test('should convert WorkoutModel to Workout entity', () {
      // Act
      final workoutEntity = testWorkoutModel.toEntity();

      // Assert
      expect(workoutEntity.id, testWorkoutModel.id);
      expect(workoutEntity.name, testWorkoutModel.name);
      expect(workoutEntity.type, testWorkoutModel.type);
      expect(workoutEntity.startTime, testWorkoutModel.startTime);
      expect(workoutEntity.endTime, testWorkoutModel.endTime);
      expect(workoutEntity.duration, testWorkoutModel.duration);
      expect(workoutEntity.caloriesBurned, testWorkoutModel.caloriesBurned);
      expect(workoutEntity.distanceMeters, testWorkoutModel.distanceMeters);
      expect(workoutEntity.averageHeartRate, testWorkoutModel.averageHeartRate);
      expect(workoutEntity.maxHeartRate, testWorkoutModel.maxHeartRate);
      expect(workoutEntity.status, testWorkoutModel.status);
      expect(workoutEntity.notes, testWorkoutModel.notes);
      expect(workoutEntity.points.length, testWorkoutModel.points.length);
    });

    test('should handle JSON with missing optional fields', () {
      // Arrange
      final jsonWithoutOptionalFields = {
        'id': 'test-workout-2',
        'name': 'Simple Run',
        'type': 'running',
        'startTime': testStartTime.toIso8601String(),
        'duration': 3600000000, // 1 hour in microseconds
        'caloriesBurned': 250.0,
        'distanceMeters': 4000.0,
        'averageHeartRate': 140,
        'maxHeartRate': 170,
        'status': 'completed',
        'points': [],
      };

      // Act
      final workoutModel = WorkoutModel.fromJson(jsonWithoutOptionalFields);

      // Assert
      expect(workoutModel.id, 'test-workout-2');
      expect(workoutModel.name, 'Simple Run');
      expect(workoutModel.endTime, isNull);
      expect(workoutModel.notes, isNull);
      expect(workoutModel.points, isEmpty);
    });

    test('should maintain equality with same data', () {
      // Arrange
      final workoutModel1 = WorkoutModel(
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

      final workoutModel2 = WorkoutModel(
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

      // Assert
      expect(workoutModel1, equals(workoutModel2));
    });
  });

  group('WorkoutPointModel', () {
    late WorkoutPointModel testWorkoutPointModel;
    late WorkoutPoint testWorkoutPointEntity;
    late DateTime testTimestamp;

    setUp(() {
      testTimestamp = DateTime(2024, 1, 15, 10, 30);

      testWorkoutPointModel = WorkoutPointModel(
        timestamp: testTimestamp,
        heartRate: 155,
        latitude: 37.7749,
        longitude: -122.4194,
        altitude: 150.0,
        speed: 6.0,
        distanceFromStart: 2500.0,
      );

      testWorkoutPointEntity = WorkoutPoint(
        timestamp: testTimestamp,
        heartRate: 155,
        latitude: 37.7749,
        longitude: -122.4194,
        altitude: 150.0,
        speed: 6.0,
        distanceFromStart: 2500.0,
      );
    });

    test('should create WorkoutPointModel with all properties', () {
      expect(testWorkoutPointModel.timestamp, testTimestamp);
      expect(testWorkoutPointModel.heartRate, 155);
      expect(testWorkoutPointModel.latitude, 37.7749);
      expect(testWorkoutPointModel.longitude, -122.4194);
      expect(testWorkoutPointModel.altitude, 150.0);
      expect(testWorkoutPointModel.speed, 6.0);
      expect(testWorkoutPointModel.distanceFromStart, 2500.0);
    });

    test('should serialize to and from JSON correctly', () {
      // Arrange
      final json = testWorkoutPointModel.toJson();

      // Act
      final fromJson = WorkoutPointModel.fromJson(json);

      // Assert
      expect(fromJson.timestamp, testWorkoutPointModel.timestamp);
      expect(fromJson.heartRate, testWorkoutPointModel.heartRate);
      expect(fromJson.latitude, testWorkoutPointModel.latitude);
      expect(fromJson.longitude, testWorkoutPointModel.longitude);
      expect(fromJson.altitude, testWorkoutPointModel.altitude);
      expect(fromJson.speed, testWorkoutPointModel.speed);
      expect(fromJson.distanceFromStart, testWorkoutPointModel.distanceFromStart);
    });

    test('should create WorkoutPointModel from WorkoutPoint entity', () {
      // Act
      final workoutPointModel = WorkoutPointModel.fromEntity(testWorkoutPointEntity);

      // Assert
      expect(workoutPointModel.timestamp, testWorkoutPointEntity.timestamp);
      expect(workoutPointModel.heartRate, testWorkoutPointEntity.heartRate);
      expect(workoutPointModel.latitude, testWorkoutPointEntity.latitude);
      expect(workoutPointModel.longitude, testWorkoutPointEntity.longitude);
      expect(workoutPointModel.altitude, testWorkoutPointEntity.altitude);
      expect(workoutPointModel.speed, testWorkoutPointEntity.speed);
      expect(workoutPointModel.distanceFromStart, testWorkoutPointEntity.distanceFromStart);
    });

    test('should convert WorkoutPointModel to WorkoutPoint entity', () {
      // Act
      final workoutPointEntity = testWorkoutPointModel.toEntity();

      // Assert
      expect(workoutPointEntity.timestamp, testWorkoutPointModel.timestamp);
      expect(workoutPointEntity.heartRate, testWorkoutPointModel.heartRate);
      expect(workoutPointEntity.latitude, testWorkoutPointModel.latitude);
      expect(workoutPointEntity.longitude, testWorkoutPointModel.longitude);
      expect(workoutPointEntity.altitude, testWorkoutPointModel.altitude);
      expect(workoutPointEntity.speed, testWorkoutPointModel.speed);
      expect(workoutPointEntity.distanceFromStart, testWorkoutPointModel.distanceFromStart);
    });

    test('should handle JSON with missing optional fields', () {
      // Arrange
      final jsonWithoutOptionalFields = {
        'timestamp': testTimestamp.toIso8601String(),
        'heartRate': 140,
        'distanceFromStart': 1000.0,
      };

      // Act
      final workoutPointModel = WorkoutPointModel.fromJson(jsonWithoutOptionalFields);

      // Assert
      expect(workoutPointModel.timestamp, testTimestamp);
      expect(workoutPointModel.heartRate, 140);
      expect(workoutPointModel.distanceFromStart, 1000.0);
      expect(workoutPointModel.latitude, isNull);
      expect(workoutPointModel.longitude, isNull);
      expect(workoutPointModel.altitude, isNull);
      expect(workoutPointModel.speed, isNull);
    });
  });
}