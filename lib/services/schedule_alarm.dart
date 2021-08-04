import 'package:alarm_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
Future<DateTime?> setDateTime(context) async {
  final TimeOfDay? alarmDateTime = await showTimePicker(
    context: context,
    initialTime: _time,
  );

  if (alarmDateTime != null) {
    DateTime _now = new DateTime.now();
    return new DateTime(_now.year, _now.month, _now.day, alarmDateTime.hour,
        alarmDateTime.minute);
  } else {
    return null;
  }
}

// Future scheduleAlarm() async {
//   var androidDetails = new AndroidNotificationDetails(
//       "channelID", "Local Notification", "Description",
//       importance: Importance.max);
//   var iosDetails = new IOSNotificationDetails();
//   var generalNotificationDetails =
//       new NotificationDetails(android: androidDetails, iOS: iosDetails);

//   DateTime scheduledTime = DateTime.now().toLocal().add(Duration(seconds: 2));

//   // await flutterLocalNotificationsPlugin.show(0, "Notif Title", "Notif Body",
//   //     scheduledTime, generalNotificationDetails);
//   // ignore: deprecated_member_use
//   flutterLocalNotificationsPlugin.schedule(0, "Task", "Scheduled Notification",
//       scheduledTime, generalNotificationDetails);

//   //TZDateTime scheduledTime = TZDateTime.now(getLocation('America/Detroidt'))
//   //     .add(Duration(seconds: 2));
//   // flutterLocalNotificationsPlugin.zonedSchedule(0, "Task",
//   //     "Scheduled Notification", scheduledTime, generalNotificationDetails,
//   //     uiLocalNotificationDateInterpretation:
//   //         UILocalNotificationDateInterpretation.absoluteTime,
//   //     androidAllowWhileIdle: true);
// }