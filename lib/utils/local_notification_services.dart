import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do_list/utils/sharedpref_helper.dart';
import 'package:to_do_list/utils/time_helper_service.dart';

import '../controller/todo_operation.dart';
import '../models/todo.dart';

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
      'daily',
      'dailyNotification',
      channelDescription: 'Deliver daily notification for you to do list',
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

  static Future<NotificationDetails> _notificationDetailsDueDate() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Due Date',
      'To Do List Due Date',
      channelDescription: 'Alerting when you to do list on due date',
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

  static Future<void> showDueDateNotification({
    required int id,
    required String title,
    required String body,
    required Time time,
    required DateTime date,
  }) async {
    final details = await _notificationDetailsDueDate();
    await localNotificationService.zonedSchedule(
      id,
      title,
      body,
      await _setSchedule(time, date),
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

  static Future<tz.TZDateTime> _setSchedule(Time time, DateTime date) async {
    final scheduledDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
    );
    return scheduledDate;
  }

  static setScheduledNotification({required BuildContext context}) {
    int totalTodos = Provider.of<TodoOperation>(
      context,
      listen: false,
    ).unFinishedTodoCount;
    String title = 'You have $totalTodos Unfinished To Do(s)';
    String body = 'Let\'s finish it all!';
    if (totalTodos == 0) {
      title = 'You don\'t have any Unfinished To Do(s)';
      body = 'Why not start create 1 today?';
    }
    showScheduledNotification(
      id: 0,
      title: title,
      body: body,
    );
  }

  static setDueDateNotification(
      {required BuildContext context, required ToDo td}) async {
    String title = 'One of Your To Do List on Due Date';
    String body = 'Have you done ${td.todoName} yet?';
    String dateOnly = td.dueDate.substring(0, 10);
    String timeOnly = td.dueDate.substring(11);
    DateTime tempDate = DateFormat("MM/dd/yyyy").parse(dateOnly);
    late int hour;
    late int minute;
    if (timeOnly.length == 8) {
      String indicator = timeOnly.substring(6);
      hour = int.parse(timeOnly.substring(0, 2));
      minute = int.parse(timeOnly.substring(3, 5));
      if (indicator == 'PM' && hour != 12) {
        hour += 12;
      }
    } else {
      String indicator = timeOnly.substring(5);
      hour = int.parse(timeOnly.substring(0, 1));
      minute = int.parse(timeOnly.substring(2, 4));
      if (indicator == 'PM' && hour != 12) {
        hour += 12;
      }
    }
    Time newTime = Time(
      hour,
      minute,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late int notifId;
    if (prefs.containsKey('due_date_count')) {
      int? notifCount = prefs.getInt('due_date_count');
      if (notifCount != null) {
        if (notifCount == 32) {
          notifCount = 1;
        }
        notifCount += 1;
        notifId = notifCount;
        prefs.setInt('due_date_count', notifCount);
      }
    } else {
      notifId = 1;
      prefs.setInt('due_date_count', notifId);
    }
    showDueDateNotification(
      id: notifId,
      title: title,
      body: body,
      date: tempDate,
      time: newTime,
    );
  }

  static deleteNotification() {
    localNotificationService.cancelAll();
  }
}
