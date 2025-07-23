import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fittrack_pro/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:fittrack_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart';

// Mock classes
class MockDashboardCubit extends Mock implements DashboardCubit {}

void main() {
  late MockDashboardCubit mockDashboardCubit;

  setUp(() {
    mockDashboardCubit = MockDashboardCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<DashboardCubit>.value(
        value: mockDashboardCubit,
        child: const DashboardPage(),
      ),
    );
  }

  group('DashboardPage Widget Tests', () {
    testWidgets('should display loading indicator when state is loading',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockDashboardCubit.state).thenReturn(DashboardLoading());
      when(() => mockDashboardCubit.stream)
          .thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle initial state correctly',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockDashboardCubit.state).thenReturn(DashboardInitial());
      when(() => mockDashboardCubit.stream)
          .thenAnswer((_) => const Stream.empty());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      // Should show some default content or loading state
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
