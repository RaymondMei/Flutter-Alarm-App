import 'package:alarm_app/view/constants/theme.dart';
import 'package:alarm_app/controller/main.dart';
import 'package:alarm_app/model/alarm_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> updateNoti(AlarmInfo alarm) async {
  if (!alarm.repeat) {
    await flutterLocalNotificationsPlugin.cancel(alarm.alarmId.hashCode,
        tag: alarm.alarmId);
    if (DateTime.now().isAfter(alarm.dateTime)) {
      alarm.dateTime = alarm.dateTime.add(Duration(days: 1));
    }
    if (alarm.active) {
      scheduleAlarm(alarm);
    }
  } else {
    for (var i = 0; i < 7; i++) {
      await flutterLocalNotificationsPlugin.cancel(alarm.alarmId.hashCode + i,
          tag: alarm.alarmId);
    }
    if (alarm.active) {
      scheduleAlarm(alarm);
    }
  }
}

Future scheduleAlarm(AlarmInfo alarm) async {
  var androidDetails = new AndroidNotificationDetails(
    "channelID",
    "Local Notification",
    "Description",
    icon: "@drawable/codex_logo",
    importance: Importance.max,
    priority: Priority.max,
    tag: alarm.alarmId,
    usesChronometer: true,
  );
  var iosDetails = new IOSNotificationDetails();
  var generalNotificationDetails =
      new NotificationDetails(android: androidDetails, iOS: iosDetails);

  if (!alarm.repeat) {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        alarm.alarmId.hashCode,
        alarm.title.length != 0 ? alarm.title : "Alarm",
        alarm.description.length != 0
            ? alarm.description
            : DateFormat.jm().format(alarm.dateTime),
        tz.TZDateTime.from(alarm.dateTime, tz.getLocation('America/Toronto')),
        generalNotificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);

    print("ALARM SCHEDULED: ${alarm.dateTime}");
  } else {
    int distToSunday = DateTime.sunday - alarm.dateTime.weekday;
    for (var i = 0; i < 7; i++) {
      if (alarm.days[i] &&
          DateTime.now()
              .isBefore(alarm.dateTime.add(Duration(days: distToSunday + i)))) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
            alarm.alarmId.hashCode + i,
            alarm.title.length != 0 ? alarm.title : "Alarm",
            alarm.description.length != 0
                ? alarm.description
                : DateFormat.jm().format(alarm.dateTime),
            tz.TZDateTime.from(
                alarm.dateTime.add(Duration(days: distToSunday + i)),
                tz.getLocation('America/Toronto')),
            generalNotificationDetails,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
        print(
            "$i ALARM SCHEDULED: ${alarm.dateTime.add(Duration(days: distToSunday + i))}");
      }
    }
  }
}

Future<DateTime?> setDateTime(context, [AlarmInfo? alarm]) async {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  if (alarm != null) {
    _time = TimeOfDay(hour: alarm.dateTime.hour, minute: alarm.dateTime.minute);
  }
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

Future<String> setTitle(context, String oldTitle) async {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  String newLabel = "";
  await showDialog(
    context: context,
    builder: (context) {
      String label = "";
      return AlertDialog(
        title: Text(
          "Label",
          style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.06),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7))),
        content: TextFormField(
          initialValue: oldTitle,
          onChanged: (val) {
            label = val;
          },
          style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05),
          cursorColor: Colors.white,
          cursorHeight: screenHeight * 0.04,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Cancel",
              style:
                  TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              "OK",
              style:
                  TextStyle(color: Colors.white, fontSize: screenWidth * 0.045),
            ),
            onPressed: () {
              newLabel = label;
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
    useSafeArea: true,
  );
  return newLabel;
}

String setDesc(List<bool> alarmDays) {
  if (alarmDays.every((day) => day == true)) {
    return "Every day";
  }
  String result = "";
  if (alarmDays[0]) {
    result += "Sun., ";
  }
  if (alarmDays[1]) {
    result += "Mon., ";
  }
  if (alarmDays[2]) {
    result += "Tue., ";
  }
  if (alarmDays[3]) {
    result += "Wed., ";
  }
  if (alarmDays[4]) {
    result += "Thu., ";
  }
  if (alarmDays[5]) {
    result += "Fri., ";
  }
  if (alarmDays[6]) {
    result += "Sat., ";
  }
  return result;
}
