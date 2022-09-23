import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do_list/utils/sharedpref_helper.dart';
import 'package:to_do_list/utils/time_helper_service.dart';

import '../models/todo_operation.dart';

class LocalNotificationService {
  static final localNotificationService = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();
  static final timeHelper = TimeHelperService();

  static Future<void> initialize() async {
    timeHelper.setup();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    IOSInitializationSettings iosInitializationSettings =
        const IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await localNotificationService.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload!);
    });
  }

  static Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'description',
      importance: Importance.max,
      playSound: true,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();
    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await localNotificationService.show(id, title, body, details);
  }

  static Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    var dailyHour = await SharedPrefHelper.getDailyNotificationHour();
    var dailyMinutes = await SharedPrefHelper.getDailyNotificationMinutes();
    await localNotificationService.zonedSchedule(
      id,
      title,
      body,
      await _scheduleDaily(Time(dailyHour, dailyMinutes)),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  void onSelectNotification(String? payload) {}

  static Future<tz.TZDateTime> _scheduleDaily(Time time) async {
    final now = await timeHelper.getTimeNow();
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  static setScheduledNotification({required BuildContext context}) {
    int totalTodos = Provider.of<TodoOperation>(
      context,
      listen: false,
    ).unDoneTodoCount;
    showScheduledNotification(
      id: 0,
      title: 'You have $totalTodos Unfinished To Do(s)',
      body: 'Let\'s finish it all!',
    );
  }

  static deleteNotification() {
    localNotificationService.cancelAll();
  }
}
