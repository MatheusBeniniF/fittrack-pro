part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final WorkoutStats stats;
  final UserProfile userProfile;
  final bool isRefreshing;

  const DashboardLoaded({
    required this.stats,
    required this.userProfile,
    this.isRefreshing = false,
  });

  DashboardLoaded copyWith({
    WorkoutStats? stats,
    UserProfile? userProfile,
    bool? isRefreshing,
  }) {
    return DashboardLoaded(
      stats: stats ?? this.stats,
      userProfile: userProfile ?? this.userProfile,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object> get props => [stats, userProfile, isRefreshing];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
