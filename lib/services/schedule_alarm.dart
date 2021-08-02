import 'package:alarm_app/main.dart';
import 'package:alarm_app/models/alarm_info.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

Future scheduleAlarm() async {
  var androidDetails = new AndroidNotificationDetails(
      "channelID", "Local Notification", "Description",
      importance: Importance.max);
  var iosDetails = new IOSNotificationDetails();
  var generalNotificationDetails =
      new NotificationDetails(android: androidDetails, iOS: iosDetails);

  DateTime scheduledTime = DateTime.now().toLocal().add(Duration(seconds: 2));

  // await flutterLocalNotificationsPlugin.show(0, "Notif Title", "Notif Body",
  //     scheduledTime, generalNotificationDetails);
  flutterLocalNotificationsPlugin.schedule(0, "Task", "Scheduled Notification",
      scheduledTime, generalNotificationDetails);

  //TZDateTime scheduledTime = TZDateTime.now(getLocation('America/Detroidt'))
  //     .add(Duration(seconds: 2));
  // flutterLocalNotificationsPlugin.zonedSchedule(0, "Task",
  //     "Scheduled Notification", scheduledTime, generalNotificationDetails,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     androidAllowWhileIdle: true);
}



// void scheduleAlarm(
//     DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo) async {
// void scheduleAlarm() async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'alarm_notif',
//     'alarm_notif',
//     'Channel for Alarm notification',
//     icon: 'codex_logo',
//     sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
//     largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
//   );

//   var iOSPlatformChannelSpecifics = IOSNotificationDetails(
//       sound: 'a_long_cold_sting.wav',
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true);
//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics);

//   await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Office :)',
//       'EXAMPLE DESC',
//       tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime);
//   // await flutterLocalNotificationsPlugin.zonedSchedule(0, 'Office',
//   //     alarmInfo.title, scheduledNotificationDateTime, platformChannelSpecifics, androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
// }
