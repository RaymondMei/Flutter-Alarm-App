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
