import 'package:ttt_alarm/features/alarm/domain/entities/alarm_entity.dart';

abstract class AlarmRepository {
  Future<List<AlarmEntity>> getAlarms();
  Future<void> saveAlarm(AlarmEntity alarm);
  Future<void> deleteAlarm(String id);
  Future<void> toggleAlarm(String id, bool isEnabled);
}
