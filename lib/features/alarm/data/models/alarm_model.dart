import 'package:ttt_alarm/features/alarm/domain/entities/alarm_entity.dart';
import 'package:ttt_alarm/features/game/domain/game_enums.dart';

class AlarmModel extends AlarmEntity {
  const AlarmModel({
    required super.id,
    required super.time,
    required super.label,
    required super.isEnabled,
    required super.difficulty,
    super.audioPath,
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'],
      time: DateTime.parse(json['time']),
      label: json['label'],
      isEnabled: json['isEnabled'],
      difficulty: Difficulty.values[json['difficulty']],
      audioPath: json['audioPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'label': label,
      'isEnabled': isEnabled,
      'difficulty': difficulty.index,
      'audioPath': audioPath,
    };
  }

  factory AlarmModel.fromEntity(AlarmEntity entity) {
    return AlarmModel(
      id: entity.id,
      time: entity.time,
      label: entity.label,
      isEnabled: entity.isEnabled,
      difficulty: entity.difficulty,
      audioPath: entity.audioPath,
    );
  }
}
