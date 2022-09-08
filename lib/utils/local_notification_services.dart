import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;
import 'package:to_do_list/utils/time_helper_service.dart';

class LocalNotificationService {
  static final localNotificationService = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();
  static final timeHelper = TimeHelperService();

  static Future<void> initialize() async {
    timeHelper.setup();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
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
    print(title);
    final details = await _notificationDetails();
    await localNotificationService.show(id, title, body, details);
  }

  static Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
  }) async {
    final details = await _notificationDetails();
    await localNotificationService.zonedSchedule(
      id,
      title,
      body,
      await _scheduleDaily(Time(hour)),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id : $id');
  }

  void onSelectNotification(String? payload) {
    print('payload : $payload');
  }

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
    print(now);
    print(scheduledDate);
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }

  static deleteNotification() {
    localNotificationService.cancelAll();
  }
}
