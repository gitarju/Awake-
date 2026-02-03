import 'package:flutter_test/flutter_test.dart';
import 'package:ttt_alarm/features/alarm/data/models/alarm_model.dart';
import 'package:ttt_alarm/features/alarm/domain/entities/alarm_entity.dart';
import 'package:ttt_alarm/features/game/domain/game_enums.dart';

void main() {
  final tTime = DateTime(2023, 1, 1, 8, 30);
  final tAlarmModelWithTime = AlarmModel(
      id: '1',
      time: tTime,
      label: 'Test',
      isEnabled: true,
      difficulty: Difficulty.easy,
      audioPath: 'path/to/audio',
  );

  group('AlarmModel', () {
    test('should be a subclass of AlarmEntity', () {
      expect(tAlarmModelWithTime, isA<AlarmEntity>());
    });

    test('fromJson returns a valid model', () {
      final Map<String, dynamic> jsonMap = {
        'id': '1',
        'time': '2023-01-01T08:30:00.000',
        'label': 'Test',
        'isEnabled': true,
        'difficulty': 0, // Easy
        'audioPath': 'path/to/audio',
      };

      final result = AlarmModel.fromJson(jsonMap);
      expect(result.id, tAlarmModelWithTime.id);
      expect(result.time, tAlarmModelWithTime.time);
      expect(result.label, tAlarmModelWithTime.label);
      expect(result.isEnabled, tAlarmModelWithTime.isEnabled);
      expect(result.difficulty, tAlarmModelWithTime.difficulty);
      expect(result.audioPath, tAlarmModelWithTime.audioPath);
    });

    test('toJson returns a JSON map', () {
      final result = tAlarmModelWithTime.toJson();
      final expectedMap = {
        'id': '1',
        'time': '2023-01-01T08:30:00.000',
        'label': 'Test',
        'isEnabled': true,
        'difficulty': 0,
        'audioPath': 'path/to/audio',
      };
      expect(result, expectedMap);
    });

    test('fromEntity returns a valid model', () {
      final entity = AlarmEntity(
        id: '1',
        time: tTime,
        label: 'Test',
        isEnabled: true,
        difficulty: Difficulty.easy,
        audioPath: 'path/to/audio',
      );

      final result = AlarmModel.fromEntity(entity);
      expect(result.id, entity.id);
      expect(result.time, entity.time);
    });
  });
}
