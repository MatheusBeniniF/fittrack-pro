import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static const String _workoutChannelId = 'workout_tracking';
  static const String _workoutChannelName = 'Workout Tracking';
  static const String _workoutChannelDescription =
      'Notifications for active workout sessions';

  static const String _generalChannelId = 'general_notifications';
  static const String _generalChannelName = 'General Notifications';
  static const String _generalChannelDescription = 'General app notifications';

  static const int _workoutNotificationId = 1001;
  static const int _pausedNotificationId = 1002;
  static const int _completedNotificationId = 1003;

  static NotificationService? _instance;
  static NotificationService get instance =>
      _instance ??= NotificationService._();

  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      );

      await _createNotificationChannels();
      await _requestPermissions();

      _isInitialized = true;

      if (kDebugMode) {
        print('NotificationService: Initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('NotificationService: Initialization failed - $e');
      }
    }
  }

  Future<void> showWorkoutNotification({
    required String workoutType,
    required Duration duration,
    required int caloriesBurned,
    required int heartRate,
  }) async {
    if (!_isInitialized) await initialize();

    final durationText = _formatDuration(duration);
    final title = '$workoutType Workout Active';
    final body = '$durationText • ${caloriesBurned}cal • ${heartRate}bpm';

    const androidDetails = AndroidNotificationDetails(
      _workoutChannelId,
      _workoutChannelName,
      channelDescription: _workoutChannelDescription,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      icon: '@drawable/ic_workout',
      color: Color(0xFF6C5CE7),
      actions: [
        AndroidNotificationAction(
          'pause_workout',
          'Pause',
          icon: DrawableResourceAndroidBitmap('@drawable/ic_pause'),
        ),
        AndroidNotificationAction(
          'stop_workout',
          'Stop',
          icon: DrawableResourceAndroidBitmap('@drawable/ic_stop'),
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
      categoryIdentifier: 'workout_category',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      _workoutNotificationId,
      title,
      body,
      details,
      payload: 'workout_active',
    );
  }

  Future<void> showWorkoutPausedNotification() async {
    if (!_isInitialized) await initialize();

    const title = 'Workout Paused';
    const body = 'Tap to resume your workout session';

    const androidDetails = AndroidNotificationDetails(
      _workoutChannelId,
      _workoutChannelName,
      channelDescription: _workoutChannelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ongoing: false,
      autoCancel: true,
      icon: '@drawable/ic_pause',
      color: Color(0xFFFF7675),
      actions: [
        AndroidNotificationAction(
          'resume_workout',
          'Resume',
          icon: DrawableResourceAndroidBitmap('@drawable/ic_play'),
        ),
        AndroidNotificationAction(
          'stop_workout',
          'Stop',
          icon: DrawableResourceAndroidBitmap('@drawable/ic_stop'),
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'workout_paused_category',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      _pausedNotificationId,
      title,
      body,
      details,
      payload: 'workout_paused',
    );
  }

  Future<void> showWorkoutCompletedNotification({
    required String workoutType,
    required Duration duration,
    required int caloriesBurned,
    required int averageHeartRate,
  }) async {
    if (!_isInitialized) await initialize();

    final durationText = _formatDuration(duration);
    final title = '$workoutType Completed! 🎉';
    final body =
        '$durationText • ${caloriesBurned}cal burned • Avg HR: ${averageHeartRate}bpm';

    final androidDetails = AndroidNotificationDetails(
      _generalChannelId,
      _generalChannelName,
      channelDescription: _generalChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ongoing: false,
      autoCancel: true,
      icon: '@drawable/ic_trophy',
      largeIcon: DrawableResourceAndroidBitmap('@drawable/ic_trophy_large'),
      styleInformation: BigTextStyleInformation(body),
      actions: [
        AndroidNotificationAction(
          'view_summary',
          'View Summary',
          icon: DrawableResourceAndroidBitmap('@drawable/ic_chart'),
        ),
        AndroidNotificationAction(
          'share_workout',
          'Share',
          icon: DrawableResourceAndroidBitmap('@drawable/ic_share'),
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'workout_completed_category',
      threadIdentifier: 'workout_completed',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      _completedNotificationId,
      title,
      body,
      details,
      payload: 'workout_completed',
    );
  }

  Future<void> showMilestoneNotification({
    required String milestone,
    required String message,
  }) async {
    if (!_isInitialized) await initialize();

    const title = 'Milestone Reached! 🏆';
    final body = '$milestone - $message';

    final androidDetails = AndroidNotificationDetails(
      _generalChannelId,
      _generalChannelName,
      channelDescription: _generalChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ongoing: false,
      autoCancel: true,
      icon: '@drawable/ic_milestone',
      largeIcon:
          const DrawableResourceAndroidBitmap('@drawable/ic_milestone_large'),
      styleInformation: BigTextStyleInformation(body),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'milestone_category',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: 'milestone_$milestone',
    );
  }

  Future<void> showHeartRateAlert({
    required int heartRate,
    required String alertType,
  }) async {
    if (!_isInitialized) await initialize();

    final title =
        alertType == 'high' ? 'High Heart Rate Alert' : 'Low Heart Rate Alert';
    final body = 'Current heart rate: ${heartRate}bpm';
    final Color color =
        alertType == 'high' ? const Color(0xFFE17055) : const Color(0xFF74B9FF);

    final androidDetails = AndroidNotificationDetails(
      _generalChannelId,
      _generalChannelName,
      channelDescription: _generalChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ongoing: false,
      autoCancel: true,
      icon: '@drawable/ic_heart_alert',
      color: color,
      largeIcon:
          const DrawableResourceAndroidBitmap('@drawable/ic_heart_large'),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'heart_rate_alert_category',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: 'heart_rate_alert_$alertType',
    );
  }

  Future<void> cancelWorkoutNotification() async {
    await _notifications.cancel(_workoutNotificationId);
    await _notifications.cancel(_pausedNotificationId);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      const workoutChannel = AndroidNotificationChannel(
        _workoutChannelId,
        _workoutChannelName,
        description: _workoutChannelDescription,
        importance: Importance.low,
        enableLights: true,
        enableVibration: false,
        showBadge: true,
      );

      const generalChannel = AndroidNotificationChannel(
        _generalChannelId,
        _generalChannelName,
        description: _generalChannelDescription,
        importance: Importance.high,
        enableLights: true,
        enableVibration: true,
        showBadge: true,
      );

      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(workoutChannel);

      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(generalChannel);
    }

    if (Platform.isIOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  static void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    if (kDebugMode) {
      print('iOS Local Notification: $title - $body');
    }
  }

  static void _onDidReceiveNotificationResponse(
      NotificationResponse response) async {
    final payload = response.payload;
    final actionId = response.actionId;

    if (kDebugMode) {
      print('Notification Response: $actionId - $payload');
    }

    switch (actionId) {
      case 'pause_workout':
        await _handlePauseWorkout();
        break;
      case 'resume_workout':
        await _handleResumeWorkout();
        break;
      case 'stop_workout':
        await _handleStopWorkout();
        break;
      case 'view_summary':
        await _handleViewSummary();
        break;
      case 'share_workout':
        await _handleShareWorkout();
        break;
      default:
        await _handleNotificationTap(payload);
        break;
    }
  }

  static Future<void> _handlePauseWorkout() async {
    print('Pause workout requested from notification');
  }

  static Future<void> _handleResumeWorkout() async {
    print('Resume workout requested from notification');
  }

  static Future<void> _handleStopWorkout() async {
    print('Stop workout requested from notification');
  }

  static Future<void> _handleViewSummary() async {
    print('View summary requested from notification');
  }

  static Future<void> _handleShareWorkout() async {
    print('Share workout requested from notification');
  }

  static Future<void> _handleNotificationTap(String? payload) async {
    print('Notification tapped with payload: $payload');
  }
}
