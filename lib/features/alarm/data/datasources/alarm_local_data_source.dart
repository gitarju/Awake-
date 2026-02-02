import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttt_alarm/features/alarm/data/models/alarm_model.dart';

abstract class AlarmLocalDataSource {
  Future<List<AlarmModel>> getAlarms();
  Future<void> saveAlarm(AlarmModel alarm);
  Future<void> deleteAlarm(String id);
  Future<void> updateAlarm(AlarmModel alarm);
}

@LazySingleton(as: AlarmLocalDataSource)
class AlarmLocalDataSourceImpl implements AlarmLocalDataSource {
  final SharedPreferences _prefs;
  static const String keyAlarms = 'alarms';

  AlarmLocalDataSourceImpl(this._prefs);

  @override
  Future<List<AlarmModel>> getAlarms() async {
    final jsonString = _prefs.getString(keyAlarms);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => AlarmModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveAlarm(AlarmModel alarm) async {
    final alarms = await getAlarms();
    // Check if exists, update if so
    final index = alarms.indexWhere((element) => element.id == alarm.id);
    if (index != -1) {
      alarms[index] = alarm;
    } else {
      alarms.add(alarm);
    }
    await _saveList(alarms);
  }

  @override
  Future<void> updateAlarm(AlarmModel alarm) async {
    await saveAlarm(alarm);
  }

  @override
  Future<void> deleteAlarm(String id) async {
    final alarms = await getAlarms();
    alarms.removeWhere((element) => element.id == id);
    await _saveList(alarms);
  }

  Future<void> _saveList(List<AlarmModel> alarms) async {
    final jsonList = alarms.map((e) => e.toJson()).toList();
    await _prefs.setString(keyAlarms, jsonEncode(jsonList));
  }
}

// Need to register SharedPreferences in DI
@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
