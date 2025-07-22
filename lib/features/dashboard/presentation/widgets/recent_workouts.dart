import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../shared/widgets/animated_widgets.dart';
import '../../domain/entities/workout_stats.dart';
import '../../../workout/domain/entities/workout.dart';

class RecentWorkouts extends StatelessWidget {
  final WorkoutStats stats;

  const RecentWorkouts({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final recentWorkouts = _generateSampleWorkouts();

    return StaggeredAnimationWrapper(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Workouts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingM),
        ...recentWorkouts.map((workout) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.paddingM),
              child: _WorkoutCard(workout: workout),
            )),
      ],
    );
  }

  List<Workout> _generateSampleWorkouts() {
    final now = DateTime.now();
    return [
      Workout(
        id: '1',
        name: 'Morning Run',
        type: WorkoutType.running,
        startTime: now.subtract(const Duration(days: 1)),
        endTime: now.subtract(const Duration(days: 1, hours: -1)),
        duration: const Duration(hours: 1),
        caloriesBurned: 350,
        distanceMeters: 5000,
        averageHeartRate: 145,
        maxHeartRate: 165,
        status: WorkoutStatus.completed,
        points: const [],
      ),
      Workout(
        id: '2',
        name: 'Strength Training',
        type: WorkoutType.strength,
        startTime: now.subtract(const Duration(days: 2)),
        endTime: now.subtract(const Duration(days: 2, hours: -1)),
        duration: const Duration(minutes: 45),
        caloriesBurned: 280,
        distanceMeters: 0,
        averageHeartRate: 120,
        maxHeartRate: 155,
        status: WorkoutStatus.completed,
        points: const [],
      ),
      Workout(
        id: '3',
        name: 'Yoga Session',
        type: WorkoutType.yoga,
        startTime: now.subtract(const Duration(days: 3)),
        endTime: now.subtract(const Duration(days: 3, hours: -1)),
        duration: const Duration(minutes: 60),
        caloriesBurned: 180,
        distanceMeters: 0,
        averageHeartRate: 85,
        maxHeartRate: 110,
        status: WorkoutStatus.completed,
        points: const [],
      ),
    ];
  }
}

class _WorkoutCard extends StatelessWidget {
  final Workout workout;

  const _WorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    final workoutIcon = _getWorkoutIcon(workout.type);
    final workoutColor = AppColors
        .chartColors[workout.type.index % AppColors.chartColors.length];

    return Card(
      elevation: 4,
      shadowColor: workoutColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: InkWell(
        onTap: () {
          AppUtils.hapticFeedback();
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: workoutColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Icon(
                  workoutIcon,
                  color: workoutColor,
                  size: AppSizes.iconM,
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSizes.paddingXS),
                    Text(
                      '${AppUtils.formatDuration(workout.duration)} • ${AppUtils.formatCalories(workout.caloriesBurned)} cal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppUtils.formatDate(workout.startTime),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                  ),
                  const SizedBox(height: AppSizes.paddingXS),
                  if (workout.distanceMeters > 0)
                    Text(
                      AppUtils.formatDistance(workout.distanceMeters),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: workoutColor,
                          ),
                    ),
                ],
              ),
              const SizedBox(width: AppSizes.paddingS),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
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
