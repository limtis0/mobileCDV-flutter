import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

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
    // TODO Test whether icon shows correctly, change icon
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

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
            icon: 'app_icon' // TODO Test whether icon shows correctly, change icon
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

  // TODO IDK if needed. Needs testing
  // // Needs a call in main
  // // Call to ask for permissions,
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