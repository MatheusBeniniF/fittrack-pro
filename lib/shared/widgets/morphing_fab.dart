import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

enum FABState { collapsed, expanded, loading }

class MorphingFAB extends StatefulWidget {
  final FABState state;
  final VoidCallback? onPressed;
  final String text;
  final IconData icon;
  final Duration animationDuration;

  const MorphingFAB({
    super.key,
    required this.state,
    this.onPressed,
    required this.text,
    required this.icon,
    this.animationDuration = AppDurations.medium,
  });

  @override
  State<MorphingFAB> createState() => _MorphingFABState();
}

class _MorphingFABState extends State<MorphingFAB>
    with TickerProviderStateMixin {
  late AnimationController _sizeController;
  late AnimationController _rotationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _sizeController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(
      begin: 56.0,
      end: 200.0,
    ).animate(CurvedAnimation(
      parent: _sizeController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _updateAnimation();
  }

  @override
  void didUpdateWidget(MorphingFAB oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    switch (widget.state) {
      case FABState.collapsed:
        _sizeController.reverse();
        _rotationController.stop();
        break;
      case FABState.expanded:
        _sizeController.forward();
        _rotationController.stop();
        break;
      case FABState.loading:
        _sizeController.reverse();
        _rotationController.repeat();
        break;
    }
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_sizeAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Container(
          width: _sizeAnimation.value,
          height: 56.0,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(28.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                offset: const Offset(0, 8),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(28.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.state == FABState.loading)
                      RotationTransition(
                        turns: _rotationAnimation,
                        child: Icon(
                          Icons.refresh,
                          color: AppColors.onPrimary,
                          size: AppSizes.iconM,
                        ),
                      )
                    else
                      Icon(
                        widget.icon,
                        color: AppColors.onPrimary,
                        size: AppSizes.iconM,
                      ),
                    if (widget.state == FABState.expanded) ...[
                      const SizedBox(width: AppSizes.paddingS),
                      Flexible(
                        child: Text(
                          widget.text,
                          style: const TextStyle(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
