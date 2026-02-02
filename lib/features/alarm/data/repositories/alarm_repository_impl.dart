import 'package:injectable/injectable.dart';
import 'package:ttt_alarm/features/alarm/data/datasources/alarm_local_data_source.dart';
import 'package:ttt_alarm/features/alarm/data/models/alarm_model.dart';
import 'package:ttt_alarm/features/alarm/domain/entities/alarm_entity.dart';
import 'package:ttt_alarm/features/alarm/domain/repositories/alarm_repository.dart';

@LazySingleton(as: AlarmRepository)
class AlarmRepositoryImpl implements AlarmRepository {
  final AlarmLocalDataSource _localDataSource;

  AlarmRepositoryImpl(this._localDataSource);

  @override
  Future<List<AlarmEntity>> getAlarms() async {
    return await _localDataSource.getAlarms();
  }

  @override
  Future<void> saveAlarm(AlarmEntity alarm) async {
    await _localDataSource.saveAlarm(AlarmModel.fromEntity(alarm));
  }

  @override
  Future<void> deleteAlarm(String id) async {
    await _localDataSource.deleteAlarm(id);
  }

  @override
  Future<void> toggleAlarm(String id, bool isEnabled) async {
    final alarms = await _localDataSource.getAlarms();
    final index = alarms.indexWhere((element) => element.id == id);
    if (index != -1) {
      final alarm = alarms[index];
      await _localDataSource.saveAlarm(
        AlarmModel.fromEntity(alarm.copyWith(isEnabled: isEnabled)),
      );
    }
  }
}
