import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/app_constants.dart';

class CustomProgressRing extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final List<Color> colors;
  final Widget? child;
  final Duration animationDuration;

  const CustomProgressRing({
    super.key,
    required this.progress,
    this.size = 200,
    this.strokeWidth = 12,
    this.colors = AppColors.chartColors,
    this.child,
    this.animationDuration = AppDurations.medium,
  });

  @override
  State<CustomProgressRing> createState() => _CustomProgressRingState();
}

class _CustomProgressRingState extends State<CustomProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(CustomProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: ProgressRingPainter(
                  progress: _progressAnimation.value,
                  strokeWidth: widget.strokeWidth,
                  colors: widget.colors,
                ),
              );
            },
          ),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> colors;

  ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      if (colors.length > 1) {
        final gradient = SweepGradient(
          colors: colors,
          startAngle: -math.pi / 2,
          endAngle: -math.pi / 2 + 2 * math.pi * progress,
        );

        final rect = Rect.fromCircle(center: center, radius: radius);
        progressPaint.shader = gradient.createShader(rect);
      } else {
        progressPaint.color = colors.first;
      }

      const startAngle = -math.pi / 2; // Start from top
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is ProgressRingPainter &&
        (oldDelegate.progress != progress ||
            oldDelegate.strokeWidth != strokeWidth ||
            oldDelegate.colors != colors);
  }
}
