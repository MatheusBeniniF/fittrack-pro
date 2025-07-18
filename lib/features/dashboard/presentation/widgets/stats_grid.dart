import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../shared/widgets/animated_widgets.dart';
import '../../domain/entities/workout_stats.dart';

class StatsGrid extends StatelessWidget {
  final WorkoutStats stats;

  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final statItems = [
      _StatItem(
        title: 'Total Workouts',
        value: stats.totalWorkouts.toString(),
        subtitle: 'This month',
        icon: Icons.fitness_center,
        color: AppColors.chartColors[0],
      ),
      _StatItem(
        title: 'Total Time',
        value: AppUtils.formatDuration(stats.totalDuration),
        subtitle: 'Hours exercised',
        icon: Icons.timer,
        color: AppColors.chartColors[1],
      ),
      _StatItem(
        title: 'Calories Burned',
        value: AppUtils.formatCalories(stats.totalCalories),
        subtitle: 'Cal burned',
        icon: Icons.local_fire_department,
        color: AppColors.chartColors[2],
      ),
      _StatItem(
        title: 'Distance',
        value: AppUtils.formatDistance(stats.totalDistance),
        subtitle: 'Total distance',
        icon: Icons.straighten,
        color: AppColors.chartColors[3],
      ),
      _StatItem(
        title: 'Avg Heart Rate',
        value: AppUtils.formatHeartRate(stats.averageHeartRate),
        subtitle: 'Average BPM',
        icon: Icons.favorite,
        color: AppColors.chartColors[4],
      ),
      _StatItem(
        title: 'Last Workout',
        value: AppUtils.formatDate(stats.lastWorkoutDate),
        subtitle: 'Most recent',
        icon: Icons.schedule,
        color: AppColors.chartColors[0],
      ),
    ];

    return StaggeredAnimationWrapper(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.paddingM,
            mainAxisSpacing: AppSizes.paddingM,
            childAspectRatio: 1.1,
          ),
          itemCount: statItems.length,
          itemBuilder: (context, index) {
            final item = statItems[index];
            return LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: AnimatedStatsCard(
                    title: item.title,
                    value: item.value,
                    subtitle: item.subtitle,
                    icon: item.icon,
                    color: item.color,
                    animationDelay: index * 100,
                    onTap: () {
                      AppUtils.hapticFeedback();
                      // Handle stat card tap
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
