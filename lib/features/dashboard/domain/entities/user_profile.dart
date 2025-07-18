import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final DateTime birthDate;
  final double heightCm;
  final double weightKg;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserPreferences preferences;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.heightCm,
    required this.weightKg,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.preferences,
  });

  int get age {
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      return age - 1;
    }
    return age;
  }

  double get bmi => weightKg / ((heightCm / 100) * (heightCm / 100));

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? birthDate,
    double? heightCm,
    double? weightKg,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserPreferences? preferences,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        birthDate,
        heightCm,
        weightKg,
        profileImageUrl,
        createdAt,
        updatedAt,
        preferences,
      ];
}

class UserPreferences extends Equatable {
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String distanceUnit; // 'km' or 'miles'
  final String weightUnit; // 'kg' or 'lbs'
  final bool darkModeEnabled;
  final int dailyCalorieGoal;
  final Duration dailyWorkoutGoal;

  const UserPreferences({
    required this.notificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.distanceUnit,
    required this.weightUnit,
    required this.darkModeEnabled,
    required this.dailyCalorieGoal,
    required this.dailyWorkoutGoal,
  });

  UserPreferences copyWith({
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? distanceUnit,
    String? weightUnit,
    bool? darkModeEnabled,
    int? dailyCalorieGoal,
    Duration? dailyWorkoutGoal,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      weightUnit: weightUnit ?? this.weightUnit,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      dailyWorkoutGoal: dailyWorkoutGoal ?? this.dailyWorkoutGoal,
    );
  }

  @override
  List<Object> get props => [
        notificationsEnabled,
        soundEnabled,
        vibrationEnabled,
        distanceUnit,
        weightUnit,
        darkModeEnabled,
        dailyCalorieGoal,
        dailyWorkoutGoal,
      ];
}
