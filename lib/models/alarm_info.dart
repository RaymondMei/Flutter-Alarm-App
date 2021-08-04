import 'package:flutter/material.dart';

class AlarmInfo {
  late DateTime dateTime;
  late String title;
  late String description;
  late int gradientColor;
  late bool isActive;
  late String alarmId;

  AlarmInfo(DateTime dateTime, String title, String description,
      int gradientColor, bool isActive,
      {this.alarmId = ""}) {
    this.dateTime = dateTime;
    this.title = title;
    this.description = description;
    this.gradientColor = gradientColor;
    this.isActive = isActive;
  }
}
