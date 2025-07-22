import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_theme.dart';
import 'core/injection/injection.dart';
import 'features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/workout/presentation/bloc/workout_bloc.dart';
import 'features/workout/presentation/pages/workout_page.dart';
import 'features/workout/domain/entities/workout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await configureDependencies();

  runApp(const FitTrackProApp());
}

class FitTrackProApp extends StatelessWidget {
  const FitTrackProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<DashboardCubit>()..loadDashboard(),
        ),
        BlocProvider(
          create: (context) => getIt<WorkoutBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'FitTrack Pro',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const MainScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/workout':
              final workout = settings.arguments as Workout;
              return MaterialPageRoute(
                builder: (context) => WorkoutPage(workout: workout),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const MainScreen(),
              );
          }
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const DashboardPage(),
    const PlaceholderPage(title: 'Workouts'),
    const PlaceholderPage(title: 'Statistics'),
    const PlaceholderPage(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              '$title Page',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming Soon!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
