import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workout.g.dart';

enum WorkoutType {
  running,
  cycling,
  swimming,
  walking,
  strength,
  yoga,
  cardio,
  other,
}

enum WorkoutStatus {
  planned,
  inProgress,
  paused,
  completed,
  cancelled,
}

@JsonSerializable(explicitToJson: true)
class Workout extends Equatable {
  final String id;
  final String name;
  final WorkoutType type;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration duration;
  final double caloriesBurned;
  final double distanceMeters;
  final int averageHeartRate;
  final int maxHeartRate;
  final WorkoutStatus status;
  final String? notes;
  final List<WorkoutPoint> points;

  const Workout({
    required this.id,
    required this.name,
    required this.type,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.caloriesBurned,
    required this.distanceMeters,
    required this.averageHeartRate,
    required this.maxHeartRate,
    required this.status,
    this.notes,
    required this.points,
  });

  Workout copyWith({
    String? id,
    String? name,
    WorkoutType? type,
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
    double? caloriesBurned,
    double? distanceMeters,
    int? averageHeartRate,
    int? maxHeartRate,
    WorkoutStatus? status,
    String? notes,
    List<WorkoutPoint>? points,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      averageHeartRate: averageHeartRate ?? this.averageHeartRate,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      points: points ?? this.points,
    );
  }

  factory Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        startTime,
        endTime,
        duration,
        caloriesBurned,
        distanceMeters,
        averageHeartRate,
        maxHeartRate,
        status,
        notes,
        points,
      ];
}

@JsonSerializable()
class WorkoutPoint extends Equatable {
  final DateTime timestamp;
  final int heartRate;
  final double? latitude;
  final double? longitude;
  final double? altitude;
  final double? speed;
  final double distanceFromStart;

  const WorkoutPoint({
    required this.timestamp,
    required this.heartRate,
    this.latitude,
    this.longitude,
    this.altitude,
    this.speed,
    required this.distanceFromStart,
  });

  factory WorkoutPoint.fromJson(Map<String, dynamic> json) => _$WorkoutPointFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutPointToJson(this);

  @override
  List<Object?> get props => [
        timestamp,
        heartRate,
        latitude,
        longitude,
        altitude,
        speed,
        distanceFromStart,
      ];
}
