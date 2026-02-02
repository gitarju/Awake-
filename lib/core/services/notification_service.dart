import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:ttt_alarm/core/router/app_router.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        if (details.payload != null) {
          final parts = details.payload!.split('|');
          final alarmId = parts[0];
          String? diffParam;
          if (parts.length > 1) {
            diffParam = parts[1];
          }
          if (diffParam != null) {
            appRouter.push('/ring?alarmId=$alarmId&difficulty=$diffParam');
          } else {
            appRouter.push('/ring?alarmId=$alarmId');
          }
        }
      },
    );
  }

  Future<void> requestPermissions() async {
    // Request Notification Permission (Android 13+)
    await Permission.notification.request();

    // Request Schedule Exact Alarm Permission (Android 12+)
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }

    // Request System Alert Window Permission (For overlays on lock screen)
    if (await Permission.systemAlertWindow.isDenied) {
      await Permission.systemAlertWindow.request();
    }
  }

  Future<void> showAlarmNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Channel',
          channelDescription: 'Channel for Alarm Notifications',
          importance: Importance.max,
          priority: Priority.max,
          category: AndroidNotificationCategory.alarm,
          audioAttributesUsage: AudioAttributesUsage.alarm,
          visibility: NotificationVisibility.public,
          fullScreenIntent: true, // Important for Alarm
          sound: RawResourceAndroidNotificationSound(
            'alarm_sound',
          ), // Need resource
          playSound: true,
        );

    // Note: 'alarm_sound' needs to be in android/app/src/main/res/raw

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload,
    );
  }
}
