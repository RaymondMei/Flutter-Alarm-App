import 'dart:ffi';

import 'package:flutter/material.dart';

class AlarmInfo {
  late DateTime dateTime;
  late String title;
  late String description;
  late int gradientColor;
  late bool active;
  late bool repeat;
  late List<bool> days;
  late bool vibrate;
  late String alarmId;

  AlarmInfo(DateTime dateTime, String title, String description,
      int gradientColor, bool active, bool repeat, List days, bool vibrate,
      {this.alarmId = ""}) {
    this.dateTime = dateTime;
    this.title = title;
    this.description = description;
    this.gradientColor = gradientColor;
    this.active = active;
    this.repeat = repeat;
    this.days = days.cast<bool>();
    this.vibrate = vibrate;
  }
}
