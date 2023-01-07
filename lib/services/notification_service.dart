import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  String title;
  String body;

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;


  NotificationService({required this.title, required this.body}){

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('icon');
    var initializationSettingsIOs = DarwinInitializationSettings();

    var initSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin!.initialize(initSettings);

  }

  showNotification() async {
    var android = AndroidNotificationDetails('0', 'event_posted ', subText: 'Event Posted');
    var iOS = DarwinNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin!.show(0, title, body, platform,);
  }
}
