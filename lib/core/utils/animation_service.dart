import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimationService {
  static AnimationService? _instance;
  static AnimationService get instance => _instance ??= AnimationService._();

  AnimationService._();

  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration extraSlowDuration = Duration(milliseconds: 800);

  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeOutQuart;
  static const Curve sharpCurve = Curves.easeInOutExpo;

  Widget createStaggeredList({
    required Widget child,
    required int index,
    Duration delay = const Duration(milliseconds: 100),
    Duration duration = normalDuration,
    Curve curve = defaultCurve,
    Offset slideOffset = const Offset(0, 50),
    double fadeStart = 0.0,
    double fadeEnd = 1.0,
  }) {
    return AnimationConfiguration.staggeredList(
      position: index,
      delay: delay,
      duration: duration,
      child: SlideAnimation(
        curve: curve,
        verticalOffset: slideOffset.dy,
        horizontalOffset: slideOffset.dx,
        child: FadeInAnimation(
          curve: curve,
          duration: duration,
          child: child,
        ),
      ),
    );
  }

  Widget createStaggeredGrid({
    required Widget child,
    required int index,
    int columnCount = 2,
    Duration delay = const Duration(milliseconds: 100),
    Duration duration = normalDuration,
    Curve curve = defaultCurve,
  }) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      columnCount: columnCount,
      delay: delay,
      duration: duration,
      child: ScaleAnimation(
        curve: curve,
        child: FadeInAnimation(
          curve: curve,
          child: child,
        ),
      ),
    );
  }

  Widget createPulseAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
    double minScale = 0.95,
    double maxScale = 1.05,
    bool repeat = true,
  }) {
    return _PulseAnimation(
      duration: duration,
      minScale: minScale,
      maxScale: maxScale,
      repeat: repeat,
      child: child,
    );
  }

  Widget createShakeAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    double offset = 10.0,
    int shakeCount = 3,
  }) {
    return _ShakeAnimation(
      duration: duration,
      offset: offset,
      shakeCount: shakeCount,
      child: child,
    );
  }

  Widget createBounceAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 600),
    double bounceHeight = 20.0,
  }) {
    return _BounceAnimation(
      duration: duration,
      bounceHeight: bounceHeight,
      child: child,
    );
  }

  Widget createFlipAnimation({
    required Widget child,
    Duration duration = normalDuration,
    Axis axis = Axis.horizontal,
  }) {
    return _FlipAnimation(
      duration: duration,
      axis: axis,
      child: child,
    );
  }

  Widget createMorphingContainer({
    required Widget child,
    required AnimationController controller,
    Color? startColor,
    Color? endColor,
    BorderRadius? startRadius,
    BorderRadius? endRadius,
    EdgeInsets? startPadding,
    EdgeInsets? endPadding,
    double? startWidth,
    double? endWidth,
    double? startHeight,
    double? endHeight,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final theme = Theme.of(context);
        final progress = controller.value;

        return Container(
          width: startWidth != null && endWidth != null
              ? Tween<double>(begin: startWidth, end: endWidth)
                  .transform(progress)
              : null,
          height: startHeight != null && endHeight != null
              ? Tween<double>(begin: startHeight, end: endHeight)
                  .transform(progress)
              : null,
          padding: startPadding != null && endPadding != null
              ? EdgeInsets.lerp(startPadding, endPadding, progress)
              : null,
          decoration: BoxDecoration(
            color: startColor != null && endColor != null
                ? Color.lerp(startColor, endColor, progress)
                : theme.primaryColor,
            borderRadius: startRadius != null && endRadius != null
                ? BorderRadius.lerp(startRadius, endRadius, progress)
                : BorderRadius.circular(8),
          ),
          child: child,
        );
      },
    );
  }

  Widget createShimmerLoading({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return _ShimmerAnimation(
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
      child: child,
    );
  }

  Widget createTypingAnimation({
    required String text,
    required TextStyle style,
    Duration duration = const Duration(milliseconds: 50),
    Duration delay = Duration.zero,
  }) {
    return _TypingAnimation(
      text: text,
      style: style,
      duration: duration,
      delay: delay,
    );
  }

  Widget createProgressRing({
    required double progress,
    required AnimationController controller,
    double size = 100,
    double strokeWidth = 8,
    Color? backgroundColor,
    Color? progressColor,
    Widget? child,
  }) {
    return _ProgressRingAnimation(
      progress: progress,
      controller: controller,
      size: size,
      strokeWidth: strokeWidth,
      backgroundColor: backgroundColor,
      progressColor: progressColor,
      child: child,
    );
  }

  Widget createHeartBeatAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
    double minScale = 1.0,
    double maxScale = 1.2,
  }) {
    return _HeartBeatAnimation(
      duration: duration,
      minScale: minScale,
      maxScale: maxScale,
      child: child,
    );
  }

  void triggerHapticFeedback(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }

  Animation<T> createTween<T>({
    required AnimationController controller,
    required T begin,
    required T end,
    Curve curve = defaultCurve,
  }) {
    return Tween<T>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }
}

enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}

// Custom Animation Widgets

class _PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool repeat;

  const _PulseAnimation({
    required this.child,
    required this.duration,
    required this.minScale,
    required this.maxScale,
    required this.repeat,
  });

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class _ShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final int shakeCount;

  const _ShakeAnimation({
    required this.child,
    required this.duration,
    required this.offset,
    required this.shakeCount,
  });

  @override
  State<_ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<_ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value * widget.offset, 0),
          child: widget.child,
        );
      },
    );
  }
}

class _BounceAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double bounceHeight;

  const _BounceAnimation({
    required this.child,
    required this.duration,
    required this.bounceHeight,
  });

  @override
  State<_BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<_BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -widget.bounceHeight * (1 - _animation.value)),
          child: widget.child,
        );
      },
    );
  }
}

class _FlipAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Axis axis;

  const _FlipAnimation({
    required this.child,
    required this.duration,
    required this.axis,
  });

  @override
  State<_FlipAnimation> createState() => _FlipAnimationState();
}

class _FlipAnimationState extends State<_FlipAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final isShowingFront = _animation.value < 0.5;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(
                widget.axis == Axis.horizontal ? _animation.value * 3.14159 : 0)
            ..rotateY(
                widget.axis == Axis.vertical ? _animation.value * 3.14159 : 0),
          child: isShowingFront ? widget.child : Container(),
        );
      },
    );
  }
}

class _ShimmerAnimation extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const _ShimmerAnimation({
    required this.child,
    this.baseColor,
    this.highlightColor,
    required this.duration,
  });

  @override
  State<_ShimmerAnimation> createState() => _ShimmerAnimationState();
}

class _ShimmerAnimationState extends State<_ShimmerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.baseColor ?? theme.colorScheme.surface;
    final highlightColor =
        widget.highlightColor ?? theme.colorScheme.onSurface.withOpacity(0.9);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _TypingAnimation extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;
  final Duration delay;

  const _TypingAnimation({
    required this.text,
    required this.style,
    required this.duration,
    required this.delay,
  });

  @override
  State<_TypingAnimation> createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<_TypingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration * widget.text.length,
      vsync: this,
    );
    _animation = IntTween(begin: 0, end: widget.text.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          widget.text.substring(0, _animation.value),
          style: widget.style,
        );
      },
    );
  }
}

class _ProgressRingAnimation extends StatelessWidget {
  final double progress;
  final AnimationController controller;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final Widget? child;

  const _ProgressRingAnimation({
    required this.progress,
    required this.controller,
    required this.size,
    required this.strokeWidth,
    this.backgroundColor,
    this.progressColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _ProgressRingPainter(
                  progress: progress * controller.value,
                  strokeWidth: strokeWidth,
                  backgroundColor: backgroundColor ?? theme.colorScheme.surface,
                  progressColor: progressColor ?? theme.primaryColor,
                ),
              ),
              if (child != null) child!,
            ],
          ),
        );
      },
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _HeartBeatAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const _HeartBeatAnimation({
    required this.child,
    required this.duration,
    required this.minScale,
    required this.maxScale,
  });

  @override
  State<_HeartBeatAnimation> createState() => _HeartBeatAnimationState();
}

class _HeartBeatAnimationState extends State<_HeartBeatAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.minScale, end: widget.maxScale)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.maxScale, end: widget.minScale)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.minScale, end: widget.maxScale)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.maxScale, end: widget.minScale)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(widget.minScale),
        weight: 40,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}
