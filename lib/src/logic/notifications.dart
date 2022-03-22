import 'dart:math';
import 'globals.dart' as globals;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:mobile_cdv/src/logic/time_operations.dart';
import 'package:mobile_cdv/src/logic/structures/schedule.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService
{
  // Singleton pattern
  static final NotificationService _notificationService = NotificationService._internal();
  factory NotificationService()
  {
    return _notificationService;
  }
  NotificationService._internal();

  // Instance of NotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialization
  Future<void> init() async
  {
    // Timezone initialization
    tz.initializeTimeZones();

    // Android settings
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('notifications_icon');

    // iOS settings
    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      // TODO IDK if needed (iOS < 10.0) and how it works. Needs testing
      // onDidReceiveLocalNotification: (int id, String title, String body, String payload) async
      //   {
      //
      //   }
    );

    // Initializes settings for both android and iOS
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification(int id, String title, String body, int seconds) async
  {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'Main Channel',
            'Main Channel',
            importance: Importance.max,
            priority: Priority.max,
            icon: 'notifications_icon',
          ),
          iOS: IOSNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelAllNotifications() async
  {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> setNotificationQueue(int secondsOffset, int queueSize) async
  {
    cancelAllNotifications();

    List<ScheduleTableItem> schedule = globals.schedule.list();
    int slice = 0;

    // Slices schedule to set only valid notifications
    while (slice < schedule.length - 1)
    {
      if (DateTime.now().difference(schedule[slice].startDate).inSeconds < 0)
      {
        break;
      }
      slice++;
    }
    schedule = schedule.sublist(slice);

    DateTime scheduledTime;
    int? notificationTime;
    for (int i = 0; i < min(schedule.length, queueSize); i++)
    {
      // Sets notification for evening if lesson is in the morning
      scheduledTime = schedule[i].startDate;
      if (scheduledTime.hour <= 9)
      {
        notificationTime = getSecondsUntilScheduledDate(DateTime(scheduledTime.year, scheduledTime.month, scheduledTime.day - 1, 21));
      }
      else
      {
        notificationTime = getSecondsUntilScheduledDate(scheduledTime) - secondsOffset;
      }

      // Sets notification
      showNotification
      (
          i,
          '${schedule[i].subjectName} [${schedule[i].room}]',
          '${formatScheduleTime(schedule[i].startDate)}-${formatScheduleTime(schedule[i].endDate)}',
          notificationTime,
      );
    }
  }

  // TODO IDK if needed. Needs testing
  // // Needs a call in main
  // // Call to ask for permissions for IOS,
  // void requestIOSPermission(
  //     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  //   flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //       IOSFlutterLocalNotificationsPlugin>()
  //       ?.requestPermissions
  //     (
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  // }
}