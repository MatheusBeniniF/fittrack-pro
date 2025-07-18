# FitTrack Pro

A comprehensive fitness tracking mobile application built with Flutter, featuring advanced UI animations and native platform integrations.

## 🚀 Features

### Dashboard Screen
- **Interactive Stats Cards**: Animated counters showing workout progress
- **Custom Charts**: Hand-painted charts showing workout data over time  
- **Morphing FAB**: Floating action button with smooth animations
- **Pull-to-Refresh**: Custom animations for data refresh
- **Responsive Layout**: Adapts to different screen sizes and orientations
- **Real-time Updates**: Live data from background service

### Workout Session Screen
- **Immersive UI**: Full-screen workout tracking with gradient backgrounds
- **Progress Ring**: Custom painted circular progress indicator
- **Heart Rate Monitor**: Live heart rate display with pulsing animation
- **Gesture Controls**: Swipe gestures for workout control
- **Background Service**: Continues tracking when app is backgrounded
- **Custom Notifications**: Workout progress notifications

## 🏗️ Architecture

The app follows Clean Architecture principles with:

- **Domain Layer**: Business logic and entities
- **Data Layer**: Repository implementations and data sources
- **Presentation Layer**: UI components, BLoC/Cubit state management

### State Management
- **BLoC/Cubit**: For complex state management
- **Stream Controllers**: For real-time data updates
- **Repository Pattern**: Clean data access layer

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App-wide constants and themes
│   ├── error/              # Error handling
│   ├── injection/          # Dependency injection
│   └── utils/              # Utility functions
├── features/
│   ├── dashboard/
│   │   ├── data/           # Data sources and repositories
│   │   ├── domain/         # Entities, repositories, use cases
│   │   └── presentation/   # UI components, Cubit, pages
│   └── workout/
│       ├── data/           # Data sources and repositories
│       ├── domain/         # Entities, repositories, use cases
│       └── presentation/   # UI components, BLoC, pages
├── shared/
│   └── widgets/            # Reusable UI components
└── main.dart
```

## 🎨 UI Components

### Custom Widgets
- **CustomProgressRing**: Multi-segment animated progress indicator
- **MorphingFAB**: Floating action button with state-based morphing
- **StaggeredCardAnimation**: Sequential card animations
- **CustomWorkoutChart**: Hand-drawn charts with smooth transitions
- **HeartRateDisplay**: Pulsing heart rate indicator

### Animations
- **Staggered Animations**: Cards animate in sequence
- **Hero Transitions**: Smooth screen transitions
- **Custom Painters**: Hand-drawn progress rings and charts
- **Morphing Components**: Shape-changing UI elements
- **Gesture-based Interactions**: Swipe and tap animations

## 🔧 Technical Features

### Dependencies
- **flutter_bloc**: State management
- **get_it & injectable**: Dependency injection
- **shared_preferences**: Local data persistence
- **fl_chart**: Chart components
- **animations**: Enhanced animations
- **flutter_staggered_animations**: Staggered animations
- **dartz**: Functional programming patterns

### Native Integration Ready
The app is structured to support:
- **Android**: Foreground services, custom notifications
- **iOS**: Background processing, local notifications
- **Method Channels**: Flutter-native communication

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.1.0)
- Dart SDK
- Android Studio / VS Code
- iOS development tools (for iOS deployment)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd mobile-app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code**
```bash
flutter packages pub run build_runner build
```

4. **Run the app**
```bash
flutter run
```

## 🧪 Testing

The app includes comprehensive testing:

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## 📱 Platform Support

- **iOS**: 12.0+
- **Android**: API 21+ (Android 5.0)
- **Responsive Design**: Works on phones and tablets

## 🎯 Performance Features

- **Optimized Animations**: 60fps smooth animations
- **Memory Management**: Proper disposal of resources
- **Background Processing**: Efficient workout tracking
- **Lazy Loading**: On-demand data loading
- **Caching**: Local data caching for offline support

## 🔮 Future Enhancements

- **HealthKit Integration**: iOS health data sync
- **Google Fit Integration**: Android health data sync
- **GPS Tracking**: Route mapping and distance calculation
- **Social Features**: Workout sharing and challenges
- **Machine Learning**: Workout recommendations
- **Wearable Support**: Apple Watch and WearOS integration

## 📄 License

This project is part of a mobile development assignment and is intended for educational purposes.

## 🤝 Contributing

This is an assignment project. For educational purposes only.

---

**Built with ❤️ using Flutter**
# fittrack-pro
