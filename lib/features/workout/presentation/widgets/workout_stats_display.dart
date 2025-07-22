import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_utils.dart';

class WorkoutStatsDisplay extends StatelessWidget {
  final Duration duration;
  final double calories;
  final double distance;

  const WorkoutStatsDisplay({
    super.key,
    required this.duration,
    required this.calories,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: AppColors.onPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            icon: Icons.local_fire_department,
            value: AppUtils.formatCalories(calories),
            label: 'Calories',
            color: Colors.orange,
          ),
          if (distance > 0) ...[
            _buildDivider(),
            _StatItem(
              icon: Icons.straighten,
              value: AppUtils.formatDistance(distance),
              label: 'Distance',
              color: Colors.blue,
            ),
          ],
          _buildDivider(),
          _StatItem(
            icon: Icons.speed,
            value: _calculatePace(),
            label: 'Pace',
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.onPrimary.withOpacity(0.2),
    );
  }

  String _calculatePace() {
    if (distance <= 0 || duration.inMinutes == 0) {
      return '--';
    }

    final distanceKm = distance / 1000;
    final paceMinutesPerKm = duration.inMinutes / distanceKm;

    if (paceMinutesPerKm.isInfinite || paceMinutesPerKm.isNaN) {
      return '--';
    }

    final minutes = paceMinutesPerKm.floor();
    final seconds = ((paceMinutesPerKm - minutes) * 60).floor();
    return '$minutes:${seconds.toString().padLeft(2, '0')}/km';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: AppSizes.iconM,
        ),
        const SizedBox(height: AppSizes.paddingS),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.onPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.paddingXS),
        Text(
          label,
          style: TextStyle(
            color: AppColors.onPrimary.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
