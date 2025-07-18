import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../shared/widgets/custom_progress_ring.dart';
import '../bloc/workout_bloc.dart';
import '../widgets/heart_rate_display.dart';
import '../widgets/workout_controls.dart';
import '../widgets/workout_stats_display.dart';
import '../../domain/entities/workout.dart';

class WorkoutPage extends StatefulWidget {
  final Workout workout;

  const WorkoutPage({super.key, required this.workout});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
    
    context.read<WorkoutBloc>().add(StartWorkoutEvent(widget.workout));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<WorkoutBloc, WorkoutState>(
            listener: (context, state) {
              if (state is WorkoutCompleted) {
                Navigator.pop(context);
                _showWorkoutSummary(context, state.workout);
              } else if (state is WorkoutError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is WorkoutLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.onPrimary,
                  ),
                );
              }

              if (state is WorkoutInProgress) {
                return _buildWorkoutInterface(context, state);
              }

              return const Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(color: AppColors.onPrimary),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutInterface(BuildContext context, WorkoutInProgress state) {
    return Column(
      children: [
        _buildHeader(context, state),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProgressRing(state),
              const SizedBox(height: AppSizes.paddingXL),
              HeartRateDisplay(
                heartRate: state.currentHeartRate,
                isPaused: state.isPaused,
              ),
              const SizedBox(height: AppSizes.paddingXL),
              WorkoutStatsDisplay(
                duration: state.elapsed,
                calories: state.currentCalories,
                distance: state.currentDistance,
              ),
            ],
          ),
        ),
        WorkoutControls(
          isPaused: state.isPaused,
          onPause: () {
            AppUtils.hapticFeedback();
            context.read<WorkoutBloc>().add(PauseWorkoutEvent(state.workout.id));
          },
          onResume: () {
            AppUtils.hapticFeedback();
            context.read<WorkoutBloc>().add(ResumeWorkoutEvent(state.workout.id));
          },
          onStop: () {
            AppUtils.hapticFeedback();
            _showStopConfirmation(context, state.workout.id);
          },
        ),
        const SizedBox(height: AppSizes.paddingL),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, WorkoutInProgress state) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _showStopConfirmation(context, state.workout.id);
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.onPrimary,
              size: AppSizes.iconL,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  state.workout.name,
                  style: const TextStyle(
                    color: AppColors.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (state.isPaused)
                  Container(
                    margin: const EdgeInsets.only(top: AppSizes.paddingXS),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM,
                      vertical: AppSizes.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    ),
                    child: const Text(
                      'PAUSED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.iconL + AppSizes.paddingM),
        ],
      ),
    );
  }

  Widget _buildProgressRing(WorkoutInProgress state) {
    // Calculate progress based on target duration (e.g., 30 minutes)
    const targetDuration = Duration(minutes: 30);
    final progress = state.elapsed.inMilliseconds / targetDuration.inMilliseconds;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: state.isPaused ? 1.0 : _pulseAnimation.value,
          child: CustomProgressRing(
            progress: clampedProgress,
            size: 280,
            strokeWidth: 16,
            colors: [
              AppColors.secondary,
              AppColors.onPrimary,
            ],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppUtils.formatDuration(state.elapsed),
                  style: const TextStyle(
                    color: AppColors.onPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingS),
                Text(
                  state.isPaused ? 'Paused' : 'In Progress',
                  style: TextStyle(
                    color: AppColors.onPrimary.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStopConfirmation(BuildContext context, String workoutId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
        title: const Text('End Workout?'),
        content: const Text(
          'Are you sure you want to end this workout? Your progress will be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<WorkoutBloc>().add(StopWorkoutEvent(workoutId));
            },
            child: const Text('End Workout'),
          ),
        ],
      ),
    );
  }

  void _showWorkoutSummary(BuildContext context, Workout workout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => _WorkoutSummarySheet(workout: workout),
    );
  }
}

class _WorkoutSummarySheet extends StatelessWidget {
  final Workout workout;

  const _WorkoutSummarySheet({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusL),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Workout Complete!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
            _buildSummaryStats(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStats() {
    return Column(
      children: [
        _SummaryStatRow(
          label: 'Duration',
          value: AppUtils.formatDuration(workout.duration),
          icon: Icons.timer,
        ),
        _SummaryStatRow(
          label: 'Calories Burned',
          value: AppUtils.formatCalories(workout.caloriesBurned),
          icon: Icons.local_fire_department,
        ),
        if (workout.distanceMeters > 0)
          _SummaryStatRow(
            label: 'Distance',
            value: AppUtils.formatDistance(workout.distanceMeters),
            icon: Icons.straighten,
          ),
        _SummaryStatRow(
          label: 'Average Heart Rate',
          value: AppUtils.formatHeartRate(workout.averageHeartRate),
          icon: Icons.favorite,
        ),
        _SummaryStatRow(
          label: 'Max Heart Rate',
          value: AppUtils.formatHeartRate(workout.maxHeartRate),
          icon: Icons.trending_up,
        ),
      ],
    );
  }
}

class _SummaryStatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryStatRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: AppSizes.iconM,
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
