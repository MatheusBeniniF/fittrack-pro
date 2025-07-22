import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../shared/widgets/animated_widgets.dart';
import '../../../../shared/widgets/morphing_fab.dart';
import '../cubit/dashboard_cubit.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/stats_grid.dart';
import '../widgets/weekly_chart.dart';
import '../widgets/recent_workouts.dart';
import '../../../workout/domain/entities/workout.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  FABState _fabState = FABState.collapsed;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && _fabState == FABState.collapsed) {
      setState(() {
        _fabState = FABState.expanded;
      });
    } else if (_scrollController.offset <= 100 &&
        _fabState == FABState.expanded) {
      setState(() {
        _fabState = FABState.collapsed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DashboardCubit, DashboardState>(
        listener: (context, state) {
          if (state is DashboardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardCubit>().refreshDashboard();
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: true,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      background: DashboardHeader(
                        userProfile: state.userProfile,
                        greeting: AppUtils.getTimeOfDayGreeting(),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        StatsGrid(stats: state.stats),
                        const SizedBox(height: AppSizes.paddingL),
                        WeeklyChart(stats: state.stats),
                        const SizedBox(height: AppSizes.paddingM),
                        RecentWorkouts(stats: state.stats),
                        const SizedBox(height: 100),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
      floatingActionButton: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return MorphingFAB(
            state: _fabState,
            icon: Icons.play_arrow,
            text: 'Start Workout',
            onPressed: () => _showWorkoutTypeSelection(context),
          );
        },
      ),
    );
  }

  void _showWorkoutTypeSelection(BuildContext context) {
    AppUtils.hapticFeedback();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusL),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: AppSizes.paddingM),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Text(
                'Choose Workout Type',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(AppSizes.paddingM),
                crossAxisSpacing: AppSizes.paddingM,
                mainAxisSpacing: AppSizes.paddingM,
                children: WorkoutType.values.map((type) {
                  return _WorkoutTypeCard(
                    type: type,
                    onTap: () {
                      Navigator.pop(context);
                      _startWorkout(context, type);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startWorkout(BuildContext context, WorkoutType type) {
    final workout = Workout(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${type.name.capitalize()} Workout',
      type: type,
      startTime: DateTime.now(),
      duration: Duration.zero,
      caloriesBurned: 0,
      distanceMeters: 0,
      averageHeartRate: 0,
      maxHeartRate: 0,
      status: WorkoutStatus.planned,
      points: const [],
    );

    context.read<DashboardCubit>().startWorkout(workout);

    Navigator.pushNamed(context, '/workout', arguments: workout);
  }
}

class _WorkoutTypeCard extends StatelessWidget {
  final WorkoutType type;
  final VoidCallback onTap;

  const _WorkoutTypeCard({
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = _getWorkoutIcon(type);
    final color =
        AppColors.chartColors[type.index % AppColors.chartColors.length];

    return AnimatedStatsCard(
      title: type.name.capitalize(),
      value: '',
      icon: icon,
      color: color,
      onTap: onTap,
      animationDelay: type.index * 100,
    );
  }

  IconData _getWorkoutIcon(WorkoutType type) {
    switch (type) {
      case WorkoutType.running:
        return Icons.directions_run;
      case WorkoutType.cycling:
        return Icons.directions_bike;
      case WorkoutType.swimming:
        return Icons.pool;
      case WorkoutType.walking:
        return Icons.directions_walk;
      case WorkoutType.strength:
        return Icons.fitness_center;
      case WorkoutType.yoga:
        return Icons.self_improvement;
      case WorkoutType.cardio:
        return Icons.favorite;
      case WorkoutType.other:
        return Icons.sports;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
