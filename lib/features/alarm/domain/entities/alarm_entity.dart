import 'package:equatable/equatable.dart';
import 'package:ttt_alarm/features/game/domain/game_enums.dart';

class AlarmEntity extends Equatable {
  final String id;
  final DateTime time;
  final String label;
  final bool isEnabled;
  final Difficulty difficulty;
  final String? audioPath;

  const AlarmEntity({
    required this.id,
    required this.time,
    required this.label,
    required this.isEnabled,
    required this.difficulty,
    this.audioPath,
  });

  AlarmEntity copyWith({
    String? id,
    DateTime? time,
    String? label,
    bool? isEnabled,
    Difficulty? difficulty,
    String? audioPath,
  }) {
    return AlarmEntity(
      id: id ?? this.id,
      time: time ?? this.time,
      label: label ?? this.label,
      isEnabled: isEnabled ?? this.isEnabled,
      difficulty: difficulty ?? this.difficulty,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  List<Object?> get props => [
    id,
    time,
    label,
    isEnabled,
    difficulty,
    audioPath,
  ];
}
