import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/workout.dart';

part 'workout_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkoutModel extends Workout {
  const WorkoutModel({
    required super.id,
    required super.name,
    required super.type,
    required super.startTime,
    super.endTime,
    required super.duration,
    required super.caloriesBurned,
    required super.distanceMeters,
    required super.averageHeartRate,
    required super.maxHeartRate,
    required super.status,
    super.notes,
    required List<WorkoutPointModel> points,
  }) : super(points: points);

  factory WorkoutModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutModelToJson(this);

  factory WorkoutModel.fromEntity(Workout workout) {
    return WorkoutModel(
      id: workout.id,
      name: workout.name,
      type: workout.type,
      startTime: workout.startTime,
      endTime: workout.endTime,
      duration: workout.duration,
      caloriesBurned: workout.caloriesBurned,
      distanceMeters: workout.distanceMeters,
      averageHeartRate: workout.averageHeartRate,
      maxHeartRate: workout.maxHeartRate,
      status: workout.status,
      notes: workout.notes,
      points: workout.points.map(WorkoutPointModel.fromEntity).toList(),
    );
  }

  Workout toEntity() {
    return Workout(
      id: id,
      name: name,
      type: type,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      caloriesBurned: caloriesBurned,
      distanceMeters: distanceMeters,
      averageHeartRate: averageHeartRate,
      maxHeartRate: maxHeartRate,
      status: status,
      notes: notes,
      points: (points as List<WorkoutPointModel>).map((p) => p.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class WorkoutPointModel extends WorkoutPoint {
  const WorkoutPointModel({
    required super.timestamp,
    required super.heartRate,
    super.latitude,
    super.longitude,
    super.altitude,
    super.speed,
    required super.distanceFromStart,
  });

  factory WorkoutPointModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutPointModelToJson(this);

  factory WorkoutPointModel.fromEntity(WorkoutPoint point) {
    return WorkoutPointModel(
      timestamp: point.timestamp,
      heartRate: point.heartRate,
      latitude: point.latitude,
      longitude: point.longitude,
      altitude: point.altitude,
      speed: point.speed,
      distanceFromStart: point.distanceFromStart,
    );
  }

  WorkoutPoint toEntity() {
    return WorkoutPoint(
      timestamp: timestamp,
      heartRate: heartRate,
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      speed: speed,
      distanceFromStart: distanceFromStart,
    );
  }
}
