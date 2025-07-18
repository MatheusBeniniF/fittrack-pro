// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutModel _$WorkoutModelFromJson(Map<String, dynamic> json) => WorkoutModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$WorkoutTypeEnumMap, json['type']),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      caloriesBurned: (json['caloriesBurned'] as num).toDouble(),
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      averageHeartRate: (json['averageHeartRate'] as num).toInt(),
      maxHeartRate: (json['maxHeartRate'] as num).toInt(),
      status: $enumDecode(_$WorkoutStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      points: (json['points'] as List<dynamic>)
          .map((e) => WorkoutPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutModelToJson(WorkoutModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$WorkoutTypeEnumMap[instance.type]!,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'duration': instance.duration.inMicroseconds,
      'caloriesBurned': instance.caloriesBurned,
      'distanceMeters': instance.distanceMeters,
      'averageHeartRate': instance.averageHeartRate,
      'maxHeartRate': instance.maxHeartRate,
      'status': _$WorkoutStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'points': instance.points.map((e) => e.toJson()).toList(),
    };

const _$WorkoutTypeEnumMap = {
  WorkoutType.running: 'running',
  WorkoutType.cycling: 'cycling',
  WorkoutType.swimming: 'swimming',
  WorkoutType.walking: 'walking',
  WorkoutType.strength: 'strength',
  WorkoutType.yoga: 'yoga',
  WorkoutType.cardio: 'cardio',
  WorkoutType.other: 'other',
};

const _$WorkoutStatusEnumMap = {
  WorkoutStatus.planned: 'planned',
  WorkoutStatus.inProgress: 'inProgress',
  WorkoutStatus.paused: 'paused',
  WorkoutStatus.completed: 'completed',
  WorkoutStatus.cancelled: 'cancelled',
};

WorkoutPointModel _$WorkoutPointModelFromJson(Map<String, dynamic> json) =>
    WorkoutPointModel(
      timestamp: DateTime.parse(json['timestamp'] as String),
      heartRate: (json['heartRate'] as num).toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      distanceFromStart: (json['distanceFromStart'] as num).toDouble(),
    );

Map<String, dynamic> _$WorkoutPointModelToJson(WorkoutPointModel instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'heartRate': instance.heartRate,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'speed': instance.speed,
      'distanceFromStart': instance.distanceFromStart,
    };
