import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:ttt_alarm/core/services/notification_service.dart';
import 'package:ttt_alarm/features/alarm/domain/entities/alarm_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AlarmSchedulerService {
  AlarmSchedulerService();

  Future<void> scheduleAlarm(AlarmEntity alarm) async {
    final int alarmId = alarm.id.hashCode;

    // Save difficulty to SharedPreferences for retrieval in background callback
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('alarm_diff_$alarmId', alarm.difficulty.index);

    // Schedule using Android Alarm Manager
    await AndroidAlarmManager.oneShotAt(
      alarm.time,
      alarmId,
      alarmCallback,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
    );
  }

  Future<void> cancelAlarm(AlarmEntity alarm) async {
    final int alarmId = alarm.id.hashCode;
    await AndroidAlarmManager.cancel(alarmId);

    // Clean up prefs
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('alarm_diff_$alarmId');
  }
}

// Top-level callback
@pragma('vm:entry-point')
void alarmCallback(int id) async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('Alarm Callback Fired for ID: $id');

  final notificationPlugin = NotificationService();
  try {
    await notificationPlugin.init();
    debugPrint('Notification Service Initialized in Background');

    // Retrieve difficulty from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // Ensure fresh data
    final diffIndex = prefs.getInt('alarm_diff_$id');

    // Construct payload: id|difficultyIndex
    String payload = id.toString();
    if (diffIndex != null) {
      payload = '$id|$diffIndex';
    }

    await notificationPlugin.showAlarmNotification(
      id: id,
      title: 'Alarm!',
      body: 'Tap to stop',
      payload: payload,
    );
    debugPrint('Notification Shown with Payload: $payload');
  } catch (e) {
    debugPrint('Error in Alarm Callback: $e');
  }
}
