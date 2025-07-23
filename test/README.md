# FitTrack Pro - Testing Guide

This document provides comprehensive information about testing in the FitTrack Pro application.

## Test Structure

The project follows a comprehensive testing strategy with three types of tests:

### 1. Unit Tests (`test/`)
- **Domain Entity Tests**: Test business logic and data models
- **Bloc/Cubit Tests**: Test state management logic
- **Repository Tests**: Test data layer implementations
- **Use Case Tests**: Test business logic use cases

### 2. Widget Tests (`test/`)
- **Page Tests**: Test complete page widgets
- **Component Tests**: Test individual UI components
- **Integration Widget Tests**: Test widget interactions

### 3. Integration Tests (`integration_test/`)
- **App Flow Tests**: Test complete user journeys
- **Navigation Tests**: Test app navigation
- **State Persistence Tests**: Test app state management

## Test Coverage

### Features Tested

#### Workout Feature
- ✅ Workout entity and domain logic
- ✅ WorkoutBloc state management
- ✅ Workout data models and JSON serialization
- ✅ Workout UI components

#### Dashboard Feature
- ✅ Dashboard cubit state management
- ✅ Dashboard page widget
- ✅ Dashboard data models
- ✅ User profile management

#### Shared Components
- ✅ Custom progress ring widget
- ✅ Animated widgets
- ✅ Chart components

## Running Tests

### Prerequisites
```bash
flutter pub get
```

### Run All Tests
```bash
# Run all unit and widget tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

### Run Specific Test Categories

#### Unit Tests Only
```bash
flutter test test/features/*/domain/
flutter test test/features/*/data/
```

#### Widget Tests Only
```bash
flutter test test/features/*/presentation/
flutter test test/shared/
```

#### Bloc/Cubit Tests Only
```bash
flutter test test/features/*/presentation/bloc/
flutter test test/features/*/presentation/cubit/
```

#### Integration Tests Only
```bash
flutter test integration_test/app_test.dart
```

### Run Tests for Specific Features
```bash
# Workout feature tests
flutter test test/features/workout/

# Dashboard feature tests
flutter test test/features/dashboard/

# Shared widget tests
flutter test test/shared/
```

## Test Utilities

### Test Helpers (`test/helpers/test_helpers.dart`)
Common test data and utilities:
- Mock workout entities
- Mock user profiles
- Mock workout statistics
- Test data generators
- Common test constants

### Mock Classes
The tests use `mocktail` for mocking dependencies:
- Repository mocks
- Use case mocks
- External service mocks

## Test Patterns

### Bloc Testing Pattern
```dart
blocTest<WorkoutBloc, WorkoutState>(
  'should emit correct states when event is added',
  build: () {
    // Setup mocks
    when(() => mockUseCase()).thenAnswer((_) async => Right(result));
    return bloc;
  },
  act: (bloc) => bloc.add(SomeEvent()),
  expect: () => [
    LoadingState(),
    SuccessState(result),
  ],
  verify: (_) {
    verify(() => mockUseCase()).called(1);
  },
);
```

### Widget Testing Pattern
```dart
testWidgets('should display correct content', (WidgetTester tester) async {
  // Arrange
  await tester.pumpWidget(createTestWidget());
  
  // Act
  await tester.tap(find.byType(Button));
  await tester.pumpAndSettle();
  
  // Assert
  expect(find.text('Expected Text'), findsOneWidget);
});
```

### Integration Testing Pattern
```dart
testWidgets('complete user flow', (WidgetTester tester) async {
  // Setup app
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();
  
  // Test user journey
  await tester.tap(find.text('Start Workout'));
  await tester.pumpAndSettle();
  
  // Verify results
  expect(find.byType(WorkoutPage), findsOneWidget);
});
```

## Test Data Management

### Mock Data
- All test data is centralized in `test/helpers/test_helpers.dart`
- Consistent test entities across all tests
- Reusable mock data generators

### Test Isolation
- Each test is isolated and independent
- Mocks are reset between tests
- No shared state between tests

## Continuous Integration

### GitHub Actions (Recommended)
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter test integration_test/
```

## Coverage Goals

- **Unit Tests**: >90% coverage for business logic
- **Widget Tests**: >80% coverage for UI components
- **Integration Tests**: Cover all major user flows

## Best Practices

### Test Organization
- Group related tests using `group()`
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)

### Mock Management
- Use `setUp()` and `tearDown()` for mock lifecycle
- Register fallback values for complex objects
- Verify mock interactions

### Widget Testing
- Use `pumpAndSettle()` for animations
- Test both success and error states
- Verify user interactions

### Performance
- Keep tests fast and focused
- Avoid unnecessary widget rebuilds
- Use `pumpWidget()` efficiently

## Troubleshooting

### Common Issues

#### Mock Registration
```dart
// Register fallback values for complex objects
registerFallbackValue(MyComplexObject());
```

#### Widget Not Found
```dart
// Wait for animations and async operations
await tester.pumpAndSettle();
```

#### State Management
```dart
// Provide proper bloc/cubit context
BlocProvider.value(
  value: mockBloc,
  child: WidgetUnderTest(),
)
```

## Contributing

When adding new features:
1. Write tests first (TDD approach)
2. Ensure >80% test coverage
3. Add integration tests for user flows
4. Update this documentation

## Test Commands Reference

```bash
# Basic test commands
flutter test                              # Run all tests
flutter test --coverage                   # Run with coverage
flutter test test/features/workout/       # Run specific feature
flutter test --name "should start workout" # Run specific test

# Integration tests
flutter test integration_test/            # All integration tests
flutter drive --target=integration_test/app_test.dart # Drive tests

# Coverage analysis
genhtml coverage/lcov.info -o coverage/html  # Generate HTML coverage report
open coverage/html/index.html                # View coverage report
```