import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_constants.dart';

class StaggeredAnimationWrapper extends StatelessWidget {
  final List<Widget> children;
  final Duration delay;
  final Duration duration;
  final Axis direction;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const StaggeredAnimationWrapper({
    super.key,
    required this.children,
    this.delay = AppDurations.staggerDelay,
    this.duration = AppDurations.medium,
    this.direction = Axis.vertical,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: _buildAnimatedChildren(),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignment,
        children: _buildAnimatedChildren(),
      );
    }
  }

  List<Widget> _buildAnimatedChildren() {
    return List.generate(
      children.length,
      (index) => AnimationConfiguration.staggeredList(
        position: index,
        delay: delay,
        duration: duration,
        child: SlideAnimation(
          verticalOffset: direction == Axis.vertical ? 50.0 : 0.0,
          horizontalOffset: direction == Axis.horizontal ? 50.0 : 0.0,
          child: FadeInAnimation(
            child: children[index],
          ),
        ),
      ),
    );
  }
}

class AnimatedStatsCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final int animationDelay;

  const AnimatedStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
    this.animationDelay = 0,
  });

  @override
  State<AnimatedStatsCard> createState() => _AnimatedStatsCardState();
}

class _AnimatedStatsCardState extends State<AnimatedStatsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) {
        _controller.forward();
      }
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
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Card(
                elevation: 8,
                shadowColor: widget.color.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.paddingL),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radiusL),
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withOpacity(0.1),
                          widget.color.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                widget.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: widget.color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(AppSizes.paddingS),
                              decoration: BoxDecoration(
                                color: widget.color.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusS),
                              ),
                              child: Icon(
                                widget.icon,
                                color: widget.color,
                                size: AppSizes.iconM,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        AnimatedCounter(
                          value: widget.value,
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: AppSizes.paddingXS),
                          Text(
                            widget.subtitle!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                    ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final String value;
  final TextStyle? textStyle;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.textStyle,
    this.duration = AppDurations.medium,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _previousValue = '';
  String _currentValue = '';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _currentValue = widget.value;
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _currentValue;
      _currentValue = widget.value;
      _controller.forward(from: 0);
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
        final isNumeric = RegExp(r'^\d+(\.\d+)?').hasMatch(_currentValue);

        if (isNumeric && _previousValue.isNotEmpty) {
          final current =
              double.tryParse(_currentValue.replaceAll(RegExp(r'[^\d.]'), ''));
          final previous =
              double.tryParse(_previousValue.replaceAll(RegExp(r'[^\d.]'), ''));

          if (current != null && previous != null) {
            final animatedValue =
                previous + (current - previous) * _animation.value;
            final formattedValue = _currentValue.replaceAll(
              RegExp(r'\d+(\.\d+)?'),
              animatedValue.toStringAsFixed(current % 1 == 0 ? 0 : 1),
            );

            return Text(
              formattedValue,
              style: widget.textStyle,
            );
          }
        }

        return Opacity(
          opacity: _animation.value,
          child: Transform.scale(
            scale: 0.8 + 0.2 * _animation.value,
            child: Text(
              _currentValue,
              style: widget.textStyle,
            ),
          ),
        );
      },
    );
  }
}
