import 'dart:async';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@singleton
class MethodChannelService {
  static const MethodChannel _channel =
      MethodChannel('com.fittrackpro/workout');
  static const EventChannel _workoutEventChannel =
      EventChannel('com.fittrackpro/workout_events');
  static const EventChannel _heartRateEventChannel =
      EventChannel('com.fittrackpro/heart_rate');

  Stream<Map<String, dynamic>>? _workoutStream;
  Stream<int>? _heartRateStream;

  Future<bool> startWorkoutService(Map<String, dynamic> workoutData) async {
    try {
      final result =
          await _channel.invokeMethod('startWorkoutService', workoutData);
      return result as bool;
    } on PlatformException catch (e) {
      print('Failed to start workout service: ${e.message}');
      return false;
    }
  }

  Future<bool> stopWorkoutService() async {
    try {
      final result = await _channel.invokeMethod('stopWorkoutService');
      return result as bool;
    } on PlatformException catch (e) {
      print('Failed to stop workout service: ${e.message}');
      return false;
    }
  }

  Future<bool> pauseWorkout() async {
    try {
      final result = await _channel.invokeMethod('pauseWorkout');
      return result as bool;
    } on PlatformException catch (e) {
      print('Failed to pause workout: ${e.message}');
      return false;
    }
  }

  Future<bool> resumeWorkout() async {
    try {
      final result = await _channel.invokeMethod('resumeWorkout');
      return result as bool;
    } on PlatformException catch (e) {
      print('Failed to resume workout: ${e.message}');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getCurrentWorkoutData() async {
    try {
      final result = await _channel.invokeMethod('getCurrentWorkoutData');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print('Failed to get current workout data: ${e.message}');
      return null;
    }
  }

  Future<bool> requestPermissions() async {
    try {
      final result = await _channel.invokeMethod('requestPermissions');
      return result as bool;
    } on PlatformException catch (e) {
      print('Failed to request permissions: ${e.message}');
      return false;
    }
  }

  Future<bool> enableWakeLock() async {
    try {
      final result = await _channel.invokeMethod('enableWakeLock');
      return result as bool;
    } on PlatformException catch (e) {
      print('Failed to enable wake lock: ${e.message}');
      return false;
    }
  }

  Future<bool> disableWakeLock() async {
    try {
      final result = await _channel.invokeMethod('disableWakeLock');
      return result as bool;
    } on PlatformException catch (e) {
      print('Failed to disable wake lock: ${e.message}');
      return false;
    }
  }

  Future<void> triggerHapticFeedback(String type) async {
    try {
      await _channel.invokeMethod('triggerHapticFeedback', {'type': type});
    } on PlatformException catch (e) {
      print('Failed to trigger haptic feedback: ${e.message}');
    }
  }

  Stream<Map<String, dynamic>> getWorkoutDataStream() {
    _workoutStream ??= _workoutEventChannel
        .receiveBroadcastStream()
        .map((event) => Map<String, dynamic>.from(event));
    return _workoutStream!;
  }

  Stream<int> getHeartRateStream() {
    _heartRateStream ??= _heartRateEventChannel
        .receiveBroadcastStream()
        .map((event) => event as int);
    return _heartRateStream!;
  }

  Future<bool> showWorkoutNotification(
      Map<String, dynamic> notificationData) async {
    try {
      final result = await _channel.invokeMethod(
          'showWorkoutNotification', notificationData);
      return result as bool;
    } on PlatformException catch (e) {
      print('Failed to show workout notification: ${e.message}');
      return false;
    }
  }

  Future<bool> updateWorkoutNotification(
      Map<String, dynamic> notificationData) async {
    try {
      final result = await _channel.invokeMethod(
          'updateWorkoutNotification', notificationData);
      return result as bool;
    } on PlatformException catch (e) {
      print('Failed to update workout notification: ${e.message}');
      return false;
    }
  }

  Future<bool> hideWorkoutNotification() async {
    try {
      final result = await _channel.invokeMethod('hideWorkoutNotification');
      return result as bool;
    } on PlatformException catch (e) {
      print('Failed to hide workout notification: ${e.message}');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getDeviceInfo() async {
    try {
      final result = await _channel.invokeMethod('getDeviceInfo');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print('Failed to get device info: ${e.message}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSimulatedSensorData() async {
    try {
      final result = await _channel.invokeMethod('getSimulatedSensorData');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print('Failed to get simulated sensor data: ${e.message}');
      return null;
    }
  }
}
