import 'package:fittrack_pro/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fittrack_pro/main.dart';
import 'package:fittrack_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fittrack_pro/features/workout/presentation/bloc/workout_bloc.dart';

// Mock classes
class MockDashboardCubit extends Mock implements DashboardCubit {}

class MockWorkoutBloc extends Mock implements WorkoutBloc {}

void main() {
  late MockDashboardCubit mockDashboardCubit;
  late MockWorkoutBloc mockWorkoutBloc;

  setUp(() {
    mockDashboardCubit = MockDashboardCubit();
    mockWorkoutBloc = MockWorkoutBloc();

    // Setup GetIt for testing
    if (GetIt.instance.isRegistered<DashboardCubit>()) {
      GetIt.instance.unregister<DashboardCubit>();
    }
    if (GetIt.instance.isRegistered<WorkoutBloc>()) {
      GetIt.instance.unregister<WorkoutBloc>();
    }

    GetIt.instance.registerFactory<DashboardCubit>(() => mockDashboardCubit);
    GetIt.instance.registerFactory<WorkoutBloc>(() => mockWorkoutBloc);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('FitTrackProApp', () {
    group('MainScreen', () {
      testWidgets('should display dashboard page by default',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockDashboardCubit.stream)
            .thenAnswer((_) => const Stream.empty());
        when(() => mockDashboardCubit.state).thenReturn(DashboardInitial());
        when(() => mockWorkoutBloc.stream)
            .thenAnswer((_) => const Stream.empty());
        when(() => mockWorkoutBloc.state).thenReturn(WorkoutInitial());

        // Act
        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<DashboardCubit>.value(value: mockDashboardCubit),
              BlocProvider<WorkoutBloc>.value(value: mockWorkoutBloc),
            ],
            child: const MaterialApp(home: MainScreen()),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(DashboardPage), findsOneWidget);
      });
    });

    group('PlaceholderPage', () {
      testWidgets('should display correct title and content',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: PlaceholderPage(title: 'Test Page'),
          ),
        );

        // Assert
        expect(find.text('Test Page'), findsOneWidget);
        expect(find.text('Test Page Page'), findsOneWidget);
        expect(find.text('Coming Soon!'), findsOneWidget);
        expect(find.byIcon(Icons.construction), findsOneWidget);
      });
    });
  });
}
