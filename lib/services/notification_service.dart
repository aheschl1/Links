import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  String title;
  String body;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


  NotificationService({this.title, this.body}){

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('icon');
    var initializationSettingsIOs = IOSInitializationSettings();

    var initSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSettings);

  }

  showNotification() async {
    var android = AndroidNotificationDetails('0', 'event_posted ', 'New event posted');
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform,);
  }
}
