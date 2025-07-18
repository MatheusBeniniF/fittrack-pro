import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/app_constants.dart';

class ChartDataPoint {
  final double x;
  final double y;
  final String label;
  final DateTime? date;

  const ChartDataPoint({
    required this.x,
    required this.y,
    required this.label,
    this.date,
  });
}

class CustomChart extends StatefulWidget {
  final List<ChartDataPoint> data;
  final String title;
  final String yAxisLabel;
  final double height;
  final Color lineColor;
  final Color fillColor;
  final bool showGrid;
  final bool animated;
  final Duration animationDuration;

  const CustomChart({
    super.key,
    required this.data,
    required this.title,
    required this.yAxisLabel,
    this.height = 200,
    this.lineColor = AppColors.primary,
    this.fillColor = AppColors.primary,
    this.showGrid = true,
    this.animated = true,
    this.animationDuration = AppDurations.slow,
  });

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    if (widget.animated) {
      _animationController = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );

      _animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));

      _animationController.forward();
    } else {
      _animationController = AnimationController(
        duration: Duration.zero,
        vsync: this,
      );
      _animation = AlwaysStoppedAnimation(1.0);
    }
  }

  @override
  void didUpdateWidget(CustomChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data && widget.animated) {
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
    if (widget.data.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: Text('No data available'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSizes.paddingM),
        Container(
          height: widget.height,
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: ChartPainter(
                  data: widget.data,
                  lineColor: widget.lineColor,
                  fillColor: widget.fillColor.withOpacity(0.2),
                  showGrid: widget.showGrid,
                  animationProgress: _animation.value,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final Color lineColor;
  final Color fillColor;
  final bool showGrid;
  final double animationProgress;

  ChartPainter({
    required this.data,
    required this.lineColor,
    required this.fillColor,
    required this.showGrid,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1.0;

    final minX = data.map((p) => p.x).reduce(math.min);
    final maxX = data.map((p) => p.x).reduce(math.max);
    final minY = data.map((p) => p.y).reduce(math.min);
    final maxY = data.map((p) => p.y).reduce(math.max);

    final padding = 20.0;
    final chartWidth = size.width - 2 * padding;
    final chartHeight = size.height - 2 * padding;

    if (showGrid) {
      const gridLines = 4;
      for (int i = 0; i <= gridLines; i++) {
        final y = padding + (chartHeight / gridLines) * i;
        canvas.drawLine(
          Offset(padding, y),
          Offset(size.width - padding, y),
          gridPaint,
        );
      }
    }

    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final point = data[i];
      final x = padding + (point.x - minX) / (maxX - minX) * chartWidth;
      final y = padding + (maxY - point.y) / (maxY - minY) * chartHeight;
      
      final animatedIndex = (data.length - 1) * animationProgress;
      if (i <= animatedIndex) {
        points.add(Offset(x, y));
      }
    }

    if (points.length < 2) return;

    final path = Path();
    final fillPath = Path();

    path.moveTo(points.first.dx, points.first.dy);
    fillPath.moveTo(points.first.dx, size.height - padding);
    fillPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      final current = points[i];
      final previous = points[i - 1];
      
      final controlPoint1 = Offset(
        previous.dx + (current.dx - previous.dx) * 0.3,
        previous.dy,
      );
      final controlPoint2 = Offset(
        current.dx - (current.dx - previous.dx) * 0.3,
        current.dy,
      );

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        current.dx,
        current.dy,
      );

      fillPath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        current.dx,
        current.dy,
      );
    }

    fillPath.lineTo(points.last.dx, size.height - padding);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);

    canvas.drawPath(path, paint);

    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4.0, pointPaint);
      canvas.drawCircle(
        point,
        4.0,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        point,
        2.0,
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is ChartPainter &&
        (oldDelegate.data != data ||
            oldDelegate.animationProgress != animationProgress ||
            oldDelegate.lineColor != lineColor ||
            oldDelegate.fillColor != fillColor);
  }
}
