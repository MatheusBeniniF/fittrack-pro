import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/workout_stats.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/dashboard_usecases.dart';
import '../../../workout/domain/usecases/workout_usecases.dart';
import '../../../workout/domain/entities/workout.dart';

part 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final GetWorkoutStats _getWorkoutStats;
  final GetWorkoutStatsStream _getWorkoutStatsStream;
  final GetUserProfile _getUserProfile;
  final UpdateUserProfile _updateUserProfile;
  final StartWorkout _startWorkout;

  StreamSubscription<WorkoutStats>? _statsSubscription;

  DashboardCubit(
    this._getWorkoutStats,
    this._getWorkoutStatsStream,
    this._getUserProfile,
    this._updateUserProfile,
    this._startWorkout,
  ) : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());

    print('Loading dashboard...');

    try {
      print('Calling _getWorkoutStats...');
      final statsResult = await _getWorkoutStats();
      print('Stats result: $statsResult');
      final profileResult = await _getUserProfile();
      print('Profile result: $profileResult');

      statsResult.fold(
        (failure) {
          print('Stats failure: ${failure.message}');
          emit(DashboardError(failure.message));
        },
        (stats) {
          profileResult.fold(
            (failure) {
              print('Profile failure: ${failure.message}');
              emit(DashboardError(failure.message));
            },
            (profile) {
              print('Dashboard loaded successfully');
              emit(DashboardLoaded(stats: stats, userProfile: profile));
              _startListeningToStats();
            },
          );
        },
      );
    } catch (e) {
      print('Exception in loadDashboard: $e');
      emit(DashboardError('Failed to load dashboard: ${e.toString()}'));
    }
  }

  void _startListeningToStats() {
    _statsSubscription?.cancel();
    _statsSubscription = _getWorkoutStatsStream().listen(
      (stats) {
        final currentState = state;
        if (currentState is DashboardLoaded) {
          emit(currentState.copyWith(stats: stats));
        }
      },
      onError: (error) {
        emit(DashboardError('Failed to update stats: ${error.toString()}'));
      },
    );
  }

  Future<void> refreshDashboard() async {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }

    try {
      final statsResult = await _getWorkoutStats();
      final profileResult = await _getUserProfile();

      statsResult.fold(
        (failure) => emit(DashboardError(failure.message)),
        (stats) {
          profileResult.fold(
            (failure) => emit(DashboardError(failure.message)),
            (profile) {
              emit(DashboardLoaded(
                stats: stats,
                userProfile: profile,
                isRefreshing: false,
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(DashboardError('Failed to refresh dashboard: ${e.toString()}'));
    }
  }

  Future<void> startWorkout(Workout workout) async {
    final result = await _startWorkout(workout);
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (_) {
        // Navigate to workout screen will be handled by the UI
      },
    );
  }

  Future<void> updateProfile(UserProfile profile) async {
    final result = await _updateUserProfile(profile);
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (_) {
        final currentState = state;
        if (currentState is DashboardLoaded) {
          emit(currentState.copyWith(userProfile: profile));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _statsSubscription?.cancel();
    return super.close();
  }
}
