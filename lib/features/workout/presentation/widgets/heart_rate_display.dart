import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class HeartRateDisplay extends StatefulWidget {
  final int heartRate;
  final bool isPaused;

  const HeartRateDisplay({
    super.key,
    required this.heartRate,
    required this.isPaused,
  });

  @override
  State<HeartRateDisplay> createState() => _HeartRateDisplayState();
}

class _HeartRateDisplayState extends State<HeartRateDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _startPulseAnimation();
  }

  @override
  void didUpdateWidget(HeartRateDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPaused != widget.isPaused) {
      if (widget.isPaused) {
        _animationController.stop();
      } else {
        _startPulseAnimation();
      }
    }
  }

  void _startPulseAnimation() {
    if (!widget.isPaused) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isPaused ? 1.0 : _pulseAnimation.value,
                child: Icon(
                  Icons.favorite,
                  color: _getHeartRateColor(),
                  size: AppSizes.iconL,
                ),
              );
            },
          ),
          const SizedBox(width: AppSizes.paddingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.heartRate}',
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'BPM',
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHeartRateColor() {
    if (widget.heartRate < 60) {
      return Colors.blue; // Resting
    } else if (widget.heartRate < 100) {
      return Colors.green; // Light activity
    } else if (widget.heartRate < 140) {
      return Colors.orange; // Moderate activity
    } else if (widget.heartRate < 180) {
      return Colors.red; // Vigorous activity
    } else {
      return Colors.deepPurple; // Maximum effort
    }
  }
}
