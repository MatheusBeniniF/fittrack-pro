import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_chart.dart';
import '../../domain/entities/workout_stats.dart';

class WeeklyChart extends StatefulWidget {
  final WorkoutStats stats;

  const WeeklyChart({super.key, required this.stats});

  @override
  State<WeeklyChart> createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> {
  String _selectedType = 'Calories';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: AppColors.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          gradient: AppColors.cardGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildChartToggle(),
              ],
            ),
            const SizedBox(height: AppSizes.paddingL),
            CustomChart(
              data: _buildChartData(),
              title: '',
              yAxisLabel: _selectedType,
              height: 200,
              lineColor: AppColors.primary,
              fillColor: AppColors.primary,
              animated: true,
            ),
            const SizedBox(height: AppSizes.paddingM),
            _buildWeeklyStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ChartToggleButton(
            label: 'Calories',
            isSelected: _selectedType == 'Calories',
            onTap: () {
              setState(() {
                _selectedType = 'Calories';
              });
            },
          ),
          _ChartToggleButton(
            label: 'Duration',
            isSelected: _selectedType == 'Duration',
            onTap: () {
              setState(() {
                _selectedType = 'Duration';
              });
            },
          ),
        ],
      ),
    );
  }

  List<ChartDataPoint> _buildChartData() {
    final weekData = <ChartDataPoint>[];
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStats = widget.stats.dailyStats.where(
        (s) => s.date.day == date.day && s.date.month == date.month,
      ).firstOrNull;
      double yValue;
      if (_selectedType == 'Calories') {
        yValue = dayStats?.calories ?? (i * 50 + 100).toDouble();
      } else {
        yValue = dayStats?.duration.inMinutes.toDouble() ?? (i * 10 + 30).toDouble();
      }
      weekData.add(ChartDataPoint(
        x: (6 - i).toDouble(),
        y: yValue,
        label: _getDayLabel(date),
        date: date,
      ));
    }
    return weekData;
  }

  String _getDayLabel(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  Widget _buildWeeklyStats() {
    final weeklyData = widget.stats.weeklyStats.isNotEmpty 
        ? widget.stats.weeklyStats.first 
        : WeeklyStats(
            weekStart: DateTime.now().subtract(const Duration(days: 7)),
            workouts: 5,
            duration: const Duration(hours: 4, minutes: 30),
            calories: 1250,
            distance: 15000,
          );

    return Row(
      children: [
        Expanded(
          child: _WeeklyStatItem(
            label: 'Workouts',
            value: weeklyData.workouts.toString(),
            icon: Icons.fitness_center,
          ),
        ),
        Expanded(
          child: _WeeklyStatItem(
            label: 'Duration',
            value: '${weeklyData.duration.inHours}h ${weeklyData.duration.inMinutes % 60}m',
            icon: Icons.timer,
          ),
        ),
        Expanded(
          child: _WeeklyStatItem(
            label: 'Calories',
            value: '${weeklyData.calories.toInt()}',
            icon: Icons.local_fire_department,
          ),
        ),
      ],
    );
  }
}

class _ChartToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChartToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.onPrimary : AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _WeeklyStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _WeeklyStatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSizes.iconS,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSizes.paddingXS),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingXS),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
