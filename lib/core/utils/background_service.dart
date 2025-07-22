import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'notification_service.dart';

class BackgroundService {
  static const String _workoutTaskName = 'workout_tracking_task';
  static const String _heartRateTaskName = 'heart_rate_monitoring_task';
  static const String _progressUpdateTaskName = 'progress_update_task';

  static const String _isWorkoutActiveKey = 'is_workout_active';
  static const String _workoutStartTimeKey = 'workout_start_time';
  static const String _workoutTypeKey = 'workout_type';
  static const String _workoutDurationKey = 'workout_duration';
  static const String _caloriesBurnedKey = 'calories_burned';
  static const String _heartRateKey = 'heart_rate';

  static BackgroundService? _instance;
  static BackgroundService get instance => _instance ??= BackgroundService._();

  BackgroundService._();

  Timer? _workoutTimer;
  Timer? _heartRateTimer;
  bool _isInitialized = false;

  /// Initialize the background service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode,
      );

      await NotificationService.instance.initialize();
      _isInitialized = true;

      if (kDebugMode) {
        print('BackgroundService: Initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('BackgroundService: Initialization failed - $e');
      }
    }
  }

  /// Start workout tracking in background
  Future<void> startWorkoutTracking({
    required String workoutType,
    required Duration duration,
  }) async {
    if (!_isInitialized) await initialize();

    final prefs = await SharedPreferences.getInstance();
    final startTime = DateTime.now().millisecondsSinceEpoch;

    // Store workout data
    await prefs.setBool(_isWorkoutActiveKey, true);
    await prefs.setInt(_workoutStartTimeKey, startTime);
    await prefs.setString(_workoutTypeKey, workoutType);
    await prefs.setInt(_workoutDurationKey, duration.inSeconds);
    await prefs.setDouble(_caloriesBurnedKey, 0.0);
    await prefs.setInt(_heartRateKey, 0);

    // Register background tasks
    await _registerWorkoutTask();
    await _registerHeartRateTask();
    await _registerProgressUpdateTask();

    // Start local timers for immediate updates
    _startLocalTimers();

    // Show initial notification
    await NotificationService.instance.showWorkoutNotification(
      workoutType: workoutType,
      duration: Duration.zero,
      caloriesBurned: 0,
      heartRate: 0,
    );

    if (kDebugMode) {
      print('BackgroundService: Started tracking $workoutType workout');
    }
  }

  /// Stop workout tracking
  Future<void> stopWorkoutTracking() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear workout data
    await prefs.setBool(_isWorkoutActiveKey, false);
    await prefs.remove(_workoutStartTimeKey);
    await prefs.remove(_workoutTypeKey);
    await prefs.remove(_workoutDurationKey);

    // Cancel background tasks
    await Workmanager().cancelByUniqueName(_workoutTaskName);
    await Workmanager().cancelByUniqueName(_heartRateTaskName);
    await Workmanager().cancelByUniqueName(_progressUpdateTaskName);

    // Stop local timers
    _workoutTimer?.cancel();
    _heartRateTimer?.cancel();

    // Cancel notifications
    await NotificationService.instance.cancelWorkoutNotification();

    if (kDebugMode) {
      print('BackgroundService: Stopped workout tracking');
    }
  }

  /// Pause workout tracking
  Future<void> pauseWorkoutTracking() async {
    _workoutTimer?.cancel();
    _heartRateTimer?.cancel();

    await Workmanager().cancelByUniqueName(_workoutTaskName);
    await Workmanager().cancelByUniqueName(_heartRateTaskName);

    await NotificationService.instance.showWorkoutPausedNotification();

    if (kDebugMode) {
      print('BackgroundService: Paused workout tracking');
    }
  }

  /// Resume workout tracking
  Future<void> resumeWorkoutTracking() async {
    await _registerWorkoutTask();
    await _registerHeartRateTask();
    _startLocalTimers();

    final prefs = await SharedPreferences.getInstance();
    final workoutType = prefs.getString(_workoutTypeKey) ?? 'Workout';
    final startTime = prefs.getInt(_workoutStartTimeKey) ??
        DateTime.now().millisecondsSinceEpoch;
    final currentDuration = Duration(
        milliseconds: DateTime.now().millisecondsSinceEpoch - startTime);
    final caloriesBurned = prefs.getDouble(_caloriesBurnedKey) ?? 0.0;
    final heartRate = prefs.getInt(_heartRateKey) ?? 0;

    await NotificationService.instance.showWorkoutNotification(
      workoutType: workoutType,
      duration: currentDuration,
      caloriesBurned: caloriesBurned.toInt(),
      heartRate: heartRate,
    );

    if (kDebugMode) {
      print('BackgroundService: Resumed workout tracking');
    }
  }

  /// Check if workout is currently active
  Future<bool> isWorkoutActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isWorkoutActiveKey) ?? false;
  }

  /// Get current workout data
  Future<Map<String, dynamic>> getCurrentWorkoutData() async {
    final prefs = await SharedPreferences.getInstance();
    final startTime = prefs.getInt(_workoutStartTimeKey);

    if (startTime == null) return {};

    final currentDuration = Duration(
        milliseconds: DateTime.now().millisecondsSinceEpoch - startTime);

    return {
      'workoutType': prefs.getString(_workoutTypeKey) ?? 'Workout',
      'duration': currentDuration,
      'caloriesBurned': prefs.getDouble(_caloriesBurnedKey) ?? 0.0,
      'heartRate': prefs.getInt(_heartRateKey) ?? 0,
      'isActive': prefs.getBool(_isWorkoutActiveKey) ?? false,
    };
  }

  // Private methods

  void _startLocalTimers() {
    // Update workout progress every second
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await _updateWorkoutProgress();
    });

    // Update heart rate every 5 seconds
    _heartRateTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _updateHeartRate();
    });
  }

  Future<void> _registerWorkoutTask() async {
    await Workmanager().registerPeriodicTask(
      _workoutTaskName,
      _workoutTaskName,
      frequency: const Duration(seconds: 15),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  Future<void> _registerHeartRateTask() async {
    await Workmanager().registerPeriodicTask(
      _heartRateTaskName,
      _heartRateTaskName,
      frequency: const Duration(seconds: 30),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  Future<void> _registerProgressUpdateTask() async {
    await Workmanager().registerPeriodicTask(
      _progressUpdateTaskName,
      _progressUpdateTaskName,
      frequency: const Duration(minutes: 1),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  Future<void> _updateWorkoutProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final isActive = prefs.getBool(_isWorkoutActiveKey) ?? false;

    if (!isActive) return;

    final startTime = prefs.getInt(_workoutStartTimeKey);
    if (startTime == null) return;

    final currentDuration = Duration(
        milliseconds: DateTime.now().millisecondsSinceEpoch - startTime);
    final workoutType = prefs.getString(_workoutTypeKey) ?? 'Workout';

    // Calculate calories burned (simplified calculation)
    final caloriesPerMinute = _getCaloriesPerMinute(workoutType);
    final caloriesBurned =
        (currentDuration.inMinutes * caloriesPerMinute).toInt();

    await prefs.setDouble(_caloriesBurnedKey, caloriesBurned.toDouble());

    // Update notification
    final heartRate = prefs.getInt(_heartRateKey) ?? 0;
    await NotificationService.instance.showWorkoutNotification(
      workoutType: workoutType,
      duration: currentDuration,
      caloriesBurned: caloriesBurned.toInt(),
      heartRate: heartRate,
    );
  }

  Future<void> _updateHeartRate() async {
    final prefs = await SharedPreferences.getInstance();
    final isActive = prefs.getBool(_isWorkoutActiveKey) ?? false;

    if (!isActive) return;

    const baseHeartRate = 70;
    final workoutType = prefs.getString(_workoutTypeKey) ?? 'Workout';
    final intensity = _getWorkoutIntensity(workoutType);
    final heartRate = (baseHeartRate +
            (intensity * 50) +
            (DateTime.now().millisecond % 20 - 10))
        .round();

    await prefs.setInt(_heartRateKey, heartRate);
  }

  double _getCaloriesPerMinute(String workoutType) {
    switch (workoutType.toLowerCase()) {
      case 'running':
        return 12.0;
      case 'cycling':
        return 8.0;
      case 'swimming':
        return 10.0;
      case 'strength':
        return 6.0;
      case 'yoga':
        return 3.0;
      default:
        return 7.0;
    }
  }

  double _getWorkoutIntensity(String workoutType) {
    switch (workoutType.toLowerCase()) {
      case 'running':
        return 0.8;
      case 'cycling':
        return 0.6;
      case 'swimming':
        return 0.7;
      case 'strength':
        return 0.5;
      case 'yoga':
        return 0.2;
      default:
        return 0.5;
    }
  }
}

/// Background task callback dispatcher
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case 'workout_tracking_task':
          await _handleWorkoutTask();
          break;
        case 'heart_rate_monitoring_task':
          await _handleHeartRateTask();
          break;
        case 'progress_update_task':
          await _handleProgressUpdateTask();
          break;
      }
      return Future.value(true);
    } catch (e) {
      if (kDebugMode) {
        print('Background task failed: $task - $e');
      }
      return Future.value(false);
    }
  });
}

Future<void> _handleWorkoutTask() async {
  final prefs = await SharedPreferences.getInstance();
  final isActive = prefs.getBool('is_workout_active') ?? false;

  if (!isActive) return;

  // Update workout progress in background
  final startTime = prefs.getInt('workout_start_time');
  if (startTime != null) {
    final currentDuration = Duration(
        milliseconds: DateTime.now().millisecondsSinceEpoch - startTime);
    final workoutType = prefs.getString('workout_type') ?? 'Workout';

    // Calculate calories
    final caloriesPerMinute =
        BackgroundService.instance._getCaloriesPerMinute(workoutType);
    final caloriesBurned =
        (currentDuration.inMinutes * caloriesPerMinute).toDouble();

    await prefs.setDouble('calories_burned', caloriesBurned);
  }
}

Future<void> _handleHeartRateTask() async {
  final prefs = await SharedPreferences.getInstance();
  final isActive = prefs.getBool('is_workout_active') ?? false;

  if (!isActive) return;

  // Simulate heart rate monitoring
  final workoutType = prefs.getString('workout_type') ?? 'Workout';
  final intensity =
      BackgroundService.instance._getWorkoutIntensity(workoutType);
  final heartRate =
      70 + (intensity * 50).toInt() + (DateTime.now().millisecond % 20 - 10);

  await prefs.setInt('heart_rate', heartRate);
}

Future<void> _handleProgressUpdateTask() async {
  final prefs = await SharedPreferences.getInstance();
  final isActive = prefs.getBool('is_workout_active') ?? false;

  if (!isActive) return;

  // Send progress update notification
  final startTime = prefs.getInt('workout_start_time');
  if (startTime != null) {
    final currentDuration = Duration(
        milliseconds: DateTime.now().millisecondsSinceEpoch - startTime);
    final workoutType = prefs.getString('workout_type') ?? 'Workout';
    final caloriesBurned = prefs.getDouble('calories_burned') ?? 0.0;
    final heartRate = prefs.getInt('heart_rate') ?? 0;

    await NotificationService.instance.showWorkoutNotification(
      workoutType: workoutType,
      duration: currentDuration,
      caloriesBurned: caloriesBurned.toInt(),
      heartRate: heartRate,
    );
  }
}
