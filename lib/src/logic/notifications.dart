import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Singleton
class NotificationService
{
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService()
  {
    return _notificationService;
  }

  NotificationService._internal();
}