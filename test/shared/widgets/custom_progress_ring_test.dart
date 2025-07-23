import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fittrack_pro/shared/widgets/custom_progress_ring.dart';

void main() {
  group('CustomProgressRing Widget Tests', () {
    testWidgets('should render with child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomProgressRing(
              progress: 0.75,
              child: Text('75%'),
            ),
          ),
        ),
      );

      expect(find.byType(CustomProgressRing), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('should handle zero progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomProgressRing(progress: 0.0),
          ),
        ),
      );

      expect(find.byType(CustomProgressRing), findsOneWidget);
    });

    testWidgets('should handle full progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomProgressRing(progress: 1.0),
          ),
        ),
      );

      expect(find.byType(CustomProgressRing), findsOneWidget);
    });

    testWidgets('should respect custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomProgressRing(
              progress: 0.5,
              size: 150,
            ),
          ),
        ),
      );

      final progressRing = tester.widget<CustomProgressRing>(
        find.byType(CustomProgressRing),
      );
      expect(progressRing.size, 150);
    });

    testWidgets('should respect custom stroke width',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomProgressRing(
              progress: 0.5,
              strokeWidth: 8,
            ),
          ),
        ),
      );

      final progressRing = tester.widget<CustomProgressRing>(
        find.byType(CustomProgressRing),
      );
      expect(progressRing.strokeWidth, 8);
    });

    testWidgets('should respect custom colors', (WidgetTester tester) async {
      const customColors = [Colors.red, Colors.blue];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomProgressRing(
              progress: 0.5,
              colors: customColors,
            ),
          ),
        ),
      );

      final progressRing = tester.widget<CustomProgressRing>(
        find.byType(CustomProgressRing),
      );
      expect(progressRing.colors, customColors);
    });

    testWidgets('should animate progress changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomProgressRing(progress: 0.5),
          ),
        ),
      );

      // Let animation start
      await tester.pump();

      expect(find.byType(CustomProgressRing), findsOneWidget);

      // Complete animation
      await tester.pumpAndSettle();

      expect(find.byType(CustomProgressRing), findsOneWidget);
    });

    testWidgets('should handle edge case progress values',
        (WidgetTester tester) async {
      // Test negative progress
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomProgressRing(progress: -0.5),
          ),
        ),
      );
      expect(find.byType(CustomProgressRing), findsOneWidget);

      // Test progress > 1.0
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomProgressRing(progress: 1.5),
          ),
        ),
      );
      expect(find.byType(CustomProgressRing), findsOneWidget);
    });
  });
}
