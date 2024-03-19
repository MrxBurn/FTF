import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

var initializationSettingsIOS = const DarwinInitializationSettings();
var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
