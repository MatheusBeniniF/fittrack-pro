import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/workout_model.dart';
import 'package:fittrack_pro/features/workout/domain/entities/workout.dart';

abstract class WorkoutLocalDataSource {
  Future<List<WorkoutModel>> getWorkouts();
  Future<WorkoutModel> getWorkoutById(String id);
  Future<String> createWorkout(WorkoutModel workout);
  Future<void> updateWorkout(WorkoutModel workout);
  Future<void> deleteWorkout(String id);
  Future<void> setCurrentWorkout(WorkoutModel workout);
  Future<WorkoutModel?> getCurrentWorkout();
  Future<void> pauseCurrentWorkout();
  Future<void> resumeCurrentWorkout();
  Future<void> stopCurrentWorkout();
  Future<void> addWorkoutPoint(String workoutId, WorkoutPointModel point);
  Stream<WorkoutModel?> getCurrentWorkoutStream();
  Stream<List<WorkoutPointModel>> getWorkoutPointsStream(String workoutId);
}

@LazySingleton(as: WorkoutLocalDataSource)
class WorkoutLocalDataSourceImpl implements WorkoutLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  static const String _workoutsKey = 'cached_workouts';
  static const String _currentWorkoutKey = 'current_workout';
  static const String _workoutPointsKey = 'workout_points_';

  final StreamController<WorkoutModel?> _currentWorkoutController =
      StreamController<WorkoutModel?>.broadcast();
  final Map<String, StreamController<List<WorkoutPointModel>>> _pointsControllers = {};

  WorkoutLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<WorkoutModel>> getWorkouts() async {
    try {
      final jsonString = sharedPreferences.getString(_workoutsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => WorkoutModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get workouts from cache: ${e.toString()}');
    }
  }

  @override
  Future<WorkoutModel> getWorkoutById(String id) async {
    try {
      final workouts = await getWorkouts();
      final workout = workouts.firstWhere(
        (w) => w.id == id,
        orElse: () => throw CacheException('Workout not found'),
      );
      return workout;
    } catch (e) {
      throw CacheException('Failed to get workout by id: ${e.toString()}');
    }
  }

  @override
  Future<String> createWorkout(WorkoutModel workout) async {
    try {
      final workouts = await getWorkouts();
      workouts.add(workout);
      await _saveWorkouts(workouts);
      return workout.id;
    } catch (e) {
      throw CacheException('Failed to create workout: ${e.toString()}');
    }
  }

  @override
  Future<void> updateWorkout(WorkoutModel workout) async {
    try {
      final workouts = await getWorkouts();
      final index = workouts.indexWhere((w) => w.id == workout.id);
      if (index != -1) {
        workouts[index] = workout;
        await _saveWorkouts(workouts);
      } else {
        throw CacheException('Workout not found for update');
      }
    } catch (e) {
      throw CacheException('Failed to update workout: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteWorkout(String id) async {
    try {
      final workouts = await getWorkouts();
      workouts.removeWhere((w) => w.id == id);
      await _saveWorkouts(workouts);
    } catch (e) {
      throw CacheException('Failed to delete workout: ${e.toString()}');
    }
  }

  @override
  Future<void> setCurrentWorkout(WorkoutModel workout) async {
    try {
      final jsonString = json.encode(workout.toJson());
      await sharedPreferences.setString(_currentWorkoutKey, jsonString);
      _currentWorkoutController.add(workout);
    } catch (e) {
      throw CacheException('Failed to set current workout: ${e.toString()}');
    }
  }

  @override
  Future<WorkoutModel?> getCurrentWorkout() async {
    try {
      final jsonString = sharedPreferences.getString(_currentWorkoutKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return WorkoutModel.fromJson(json);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get current workout: ${e.toString()}');
    }
  }

  @override
  Future<void> pauseCurrentWorkout() async {
    try {
      final currentWorkout = await getCurrentWorkout();
      if (currentWorkout != null) {
        final pausedWorkout = WorkoutModel.fromEntity(
          currentWorkout.copyWith(status: WorkoutStatus.paused),
        );
        await setCurrentWorkout(pausedWorkout);
      }
    } catch (e) {
      throw CacheException('Failed to pause current workout: ${e.toString()}');
    }
  }

  @override
  Future<void> resumeCurrentWorkout() async {
    try {
      final currentWorkout = await getCurrentWorkout();
      if (currentWorkout != null) {
        final resumedWorkout = WorkoutModel.fromEntity(
          currentWorkout.copyWith(status: WorkoutStatus.inProgress),
        );
        await setCurrentWorkout(resumedWorkout);
      }
    } catch (e) {
      throw CacheException('Failed to resume current workout: ${e.toString()}');
    }
  }

  @override
  Future<void> stopCurrentWorkout() async {
    try {
      final currentWorkout = await getCurrentWorkout();
      if (currentWorkout != null) {
        final completedWorkout = WorkoutModel.fromEntity(
          currentWorkout.copyWith(
            status: WorkoutStatus.completed,
            endTime: DateTime.now(),
          ),
        );
        
        // Save to workouts list
        await createWorkout(completedWorkout);
        
        // Clear current workout
        await sharedPreferences.remove(_currentWorkoutKey);
        _currentWorkoutController.add(null);
      }
    } catch (e) {
      throw CacheException('Failed to stop current workout: ${e.toString()}');
    }
  }

  @override
  Future<void> addWorkoutPoint(String workoutId, WorkoutPointModel point) async {
    try {
      final points = await _getWorkoutPoints(workoutId);
      points.add(point);
      await _saveWorkoutPoints(workoutId, points);
      
      // Notify stream listeners
      final controller = _pointsControllers[workoutId];
      controller?.add(points);
    } catch (e) {
      throw CacheException('Failed to add workout point: ${e.toString()}');
    }
  }

  @override
  Stream<WorkoutModel?> getCurrentWorkoutStream() {
    // Initialize with current workout
    getCurrentWorkout().then((workout) {
      _currentWorkoutController.add(workout);
    });
    
    return _currentWorkoutController.stream;
  }

  @override
  Stream<List<WorkoutPointModel>> getWorkoutPointsStream(String workoutId) {
    if (!_pointsControllers.containsKey(workoutId)) {
      _pointsControllers[workoutId] = StreamController<List<WorkoutPointModel>>.broadcast();
      
      // Initialize with existing points
      _getWorkoutPoints(workoutId).then((points) {
        _pointsControllers[workoutId]?.add(points);
      });
    }
    
    return _pointsControllers[workoutId]!.stream;
  }

  Future<void> _saveWorkouts(List<WorkoutModel> workouts) async {
    final jsonString = json.encode(workouts.map((w) => w.toJson()).toList());
    await sharedPreferences.setString(_workoutsKey, jsonString);
  }

  Future<List<WorkoutPointModel>> _getWorkoutPoints(String workoutId) async {
    try {
      final jsonString = sharedPreferences.getString('$_workoutPointsKey$workoutId');
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => WorkoutPointModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get workout points: ${e.toString()}');
    }
  }

  Future<void> _saveWorkoutPoints(String workoutId, List<WorkoutPointModel> points) async {
    final jsonString = json.encode(points.map((p) => p.toJson()).toList());
    await sharedPreferences.setString('$_workoutPointsKey$workoutId', jsonString);
  }
}
