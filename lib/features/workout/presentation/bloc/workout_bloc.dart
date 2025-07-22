import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/workout.dart';
import '../../domain/usecases/workout_usecases.dart';
import '../../../../core/utils/background_service.dart';

part 'workout_event.dart';
part 'workout_state.dart';

@injectable
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  static const double earthRadius = 6371000.0; // meters
  final StartWorkout _startWorkout;
  final PauseWorkout _pauseWorkout;
  final ResumeWorkout _resumeWorkout;
  final StopWorkout _stopWorkout;
  final GetCurrentWorkout _getCurrentWorkout;
  final AddWorkoutPoint _addWorkoutPoint;

  Timer? _timer;
  Timer? _heartRateTimer;
  StreamSubscription<Workout?>? _currentWorkoutSubscription;
  DateTime? _workoutStartTime;
  DateTime? _pauseStartTime;
  Duration _totalPausedDuration = Duration.zero;
  ReceivePort? _receivePort;
  bool _isBackgroundServiceActive = false;

  WorkoutBloc(
    this._startWorkout,
    this._pauseWorkout,
    this._resumeWorkout,
    this._stopWorkout,
    this._getCurrentWorkout,
    this._addWorkoutPoint,
  ) : super(WorkoutInitial()) {
    on<StartWorkoutEvent>(_onStartWorkout);
    on<PauseWorkoutEvent>(_onPauseWorkout);
    on<ResumeWorkoutEvent>(_onResumeWorkout);
    on<StopWorkoutEvent>(_onStopWorkout);
    on<UpdateHeartRateEvent>(_onUpdateHeartRate);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<WorkoutTimerTickEvent>(_onWorkoutTimerTick);
    on<LoadCurrentWorkoutEvent>(_onLoadCurrentWorkout);

    _startListeningToCurrentWorkout();
    _setupBackgroundCommunication();
  }

  void _startListeningToCurrentWorkout() {
    _currentWorkoutSubscription?.cancel();
    _currentWorkoutSubscription = _getCurrentWorkout().listen(
      (workout) {
        if (workout != null && workout.status == WorkoutStatus.inProgress) {
          _workoutStartTime = workout.startTime;
          _startTimers();
          _startBackgroundService();

          final elapsed = DateTime.now().difference(_workoutStartTime!) -
              _totalPausedDuration;
          emit(WorkoutInProgress(
            workout: workout,
            elapsed: elapsed,
            currentHeartRate: 75,
            currentDistance: 0.0,
            currentCalories: 0.0,
            isPaused: false,
            points: const [],
          ));
        } else if (workout != null &&
            workout.status == WorkoutStatus.completed) {
          _stopTimers();
          _stopBackgroundService();
          emit(WorkoutCompleted(workout));
        }
      },
    );
  }

  Future<void> _onStartWorkout(
      StartWorkoutEvent event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());

    final result = await _startWorkout(event.workout);
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (_) {
        _workoutStartTime = DateTime.now();
        _totalPausedDuration = Duration.zero;
        _startTimers();

        emit(WorkoutInProgress(
          workout: event.workout.copyWith(
            startTime: _workoutStartTime!,
            status: WorkoutStatus.inProgress,
          ),
          elapsed: Duration.zero,
          currentHeartRate: 75,
          currentDistance: 0.0,
          currentCalories: 0.0,
          isPaused: false,
          points: const [],
        ));
      },
    );
  }

  Future<void> _onPauseWorkout(
      PauseWorkoutEvent event, Emitter<WorkoutState> emit) async {
    final currentState = state;
    if (currentState is WorkoutInProgress && !currentState.isPaused) {
      _pauseStartTime = DateTime.now();
      _stopTimers();

      final result = await _pauseWorkout(event.workoutId);
      result.fold(
        (failure) => emit(WorkoutError(failure.message)),
        (_) => emit(currentState.copyWith(isPaused: true)),
      );
    }
  }

  Future<void> _onResumeWorkout(
      ResumeWorkoutEvent event, Emitter<WorkoutState> emit) async {
    final currentState = state;
    if (currentState is WorkoutInProgress && currentState.isPaused) {
      if (_pauseStartTime != null) {
        _totalPausedDuration += DateTime.now().difference(_pauseStartTime!);
        _pauseStartTime = null;
      }
      _startTimers();

      final result = await _resumeWorkout(event.workoutId);
      result.fold(
        (failure) => emit(WorkoutError(failure.message)),
        (_) => emit(currentState.copyWith(isPaused: false)),
      );
    }
  }

  Future<void> _onStopWorkout(
      StopWorkoutEvent event, Emitter<WorkoutState> emit) async {
    _stopTimers();

    final currentState = state;
    if (currentState is WorkoutInProgress) {
      final result = await _stopWorkout(event.workoutId);
      result.fold(
        (failure) => emit(WorkoutError(failure.message)),
        (_) {
          final completedWorkout = currentState.workout.copyWith(
            endTime: DateTime.now(),
            duration: currentState.elapsed,
            status: WorkoutStatus.completed,
            caloriesBurned: currentState.currentCalories,
            distanceMeters: currentState.currentDistance,
            averageHeartRate: _calculateAverageHeartRate(currentState.points),
            maxHeartRate: _calculateMaxHeartRate(currentState.points),
            points: currentState.points,
          );
          emit(WorkoutCompleted(completedWorkout));
        },
      );
    }
  }

  void _onUpdateHeartRate(
      UpdateHeartRateEvent event, Emitter<WorkoutState> emit) {
    final currentState = state;
    if (currentState is WorkoutInProgress && !currentState.isPaused) {
      emit(currentState.copyWith(currentHeartRate: event.heartRate));
    }
  }

  void _onUpdateLocation(
      UpdateLocationEvent event, Emitter<WorkoutState> emit) {
    final currentState = state;
    if (currentState is WorkoutInProgress && !currentState.isPaused) {
      final newPoint = WorkoutPoint(
        timestamp: DateTime.now(),
        heartRate: currentState.currentHeartRate,
        latitude: event.latitude,
        longitude: event.longitude,
        altitude: event.altitude,
        speed: event.speed,
        distanceFromStart: currentState.currentDistance,
      );

      final updatedPoints = [...currentState.points, newPoint];
      final distance = _calculateTotalDistance(updatedPoints);

      emit(currentState.copyWith(
        points: updatedPoints,
        currentDistance: distance,
      ));

      _addWorkoutPoint(currentState.workout.id, newPoint);
    }
  }

  void _onWorkoutTimerTick(
      WorkoutTimerTickEvent event, Emitter<WorkoutState> emit) {
    final currentState = state;
    if (currentState is WorkoutInProgress &&
        !currentState.isPaused &&
        _workoutStartTime != null) {
      final elapsed =
          DateTime.now().difference(_workoutStartTime!) - _totalPausedDuration;
      final calories =
          _calculateCalories(elapsed, currentState.currentHeartRate);

      emit(currentState.copyWith(
        elapsed: elapsed,
        currentCalories: calories,
      ));
    }
  }

  void _onLoadCurrentWorkout(
      LoadCurrentWorkoutEvent event, Emitter<WorkoutState> emit) {}

  void _startTimers() {
    _timer?.cancel();
    _heartRateTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(WorkoutTimerTickEvent());
    });

    _heartRateTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      final heartRate = _generateSimulatedHeartRate();
      add(UpdateHeartRateEvent(heartRate));
    });
  }

  void _stopTimers() {
    _timer?.cancel();
    _heartRateTimer?.cancel();
  }

  int _generateSimulatedHeartRate() {
    final random = Random();
    return 120 + random.nextInt(61);
  }

  double _calculateTotalDistance(List<WorkoutPoint> points) {
    if (points.length < 2) return 0.0;

    double totalDistance = 0.0;
    for (int i = 1; i < points.length; i++) {
      if (points[i - 1].latitude != null &&
          points[i - 1].longitude != null &&
          points[i].latitude != null &&
          points[i].longitude != null) {
        totalDistance += _calculateDistanceBetweenPoints(
          points[i - 1].latitude!,
          points[i - 1].longitude!,
          points[i].latitude!,
          points[i].longitude!,
        );
      }
    }
    return totalDistance;
  }

  double _calculateDistanceBetweenPoints(
      double lat1, double lon1, double lat2, double lon2) {
    final double dLat = (lat2 - lat1) * (pi / 180);
    final double dLon = (lon2 - lon1) * (pi / 180);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _calculateCalories(Duration elapsed, int heartRate) {
    final hours = elapsed.inMinutes / 60.0;
    final met = _calculateMET(heartRate);
    // Fórmula simplificada: kcal = MET * 3.5 * peso(kg) / 200 * minutos
    // Supondo peso médio de 70kg
    return met * 3.5 * 70 / 200 * hours * 60;
  }

  double _calculateMET(int heartRate) {
    if (heartRate < 100) return 2.0;
    if (heartRate < 120) return 4.0;
    if (heartRate < 140) return 6.0;
    if (heartRate < 160) return 8.0;
    return 10.0;
  }

  int _calculateAverageHeartRate(List<WorkoutPoint> points) {
    if (points.isEmpty) return 0;
    final sum = points.map((p) => p.heartRate).reduce((a, b) => a + b);
    return (sum / points.length).round();
  }

  int _calculateMaxHeartRate(List<WorkoutPoint> points) {
    if (points.isEmpty) return 0;
    return points.map((p) => p.heartRate).reduce((a, b) => a > b ? a : b);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _heartRateTimer?.cancel();
    _currentWorkoutSubscription?.cancel();
    _receivePort?.close();
    _stopBackgroundService();
    return super.close();
  }

  void _setupBackgroundCommunication() {
    _receivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(
        _receivePort!.sendPort, 'workout_control');

    _receivePort!.listen((message) {
      if (message is Map<String, dynamic>) {
        final action = message['action'] as String?;

        switch (action) {
          case 'pause':
            if (state is WorkoutInProgress) {
              final currentState = state as WorkoutInProgress;
              add(PauseWorkoutEvent(currentState.workout.id));
            }
            break;
          case 'resume':
            if (state is WorkoutInProgress) {
              final currentState = state as WorkoutInProgress;
              add(ResumeWorkoutEvent(currentState.workout.id));
            }
            break;
          case 'stop':
            if (state is WorkoutInProgress) {
              final currentState = state as WorkoutInProgress;
              add(StopWorkoutEvent(currentState.workout.id));
            }
            break;
        }
      }
    });
  }

  Future<void> _startBackgroundService() async {
    if (_isBackgroundServiceActive) return;

    final currentState = state;
    if (currentState is WorkoutInProgress) {
      await BackgroundService.instance.startWorkoutTracking(
        workoutType: currentState.workout.type.toString().split('.').last,
        duration: const Duration(hours: 1),
      );
      _isBackgroundServiceActive = true;
    }
  }

  Future<void> _stopBackgroundService() async {
    if (!_isBackgroundServiceActive) return;

    await BackgroundService.instance.stopWorkoutTracking();
    _isBackgroundServiceActive = false;
  }
}
