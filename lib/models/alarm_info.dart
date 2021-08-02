import 'package:flutter/material.dart';

class AlarmInfo {
  late String title;
  late String description;
  late DateTime dateTime;
  late List<Color> gradientColor;

  AlarmInfo(String title, String description, DateTime dateTime,
      List<Color> gradientColor) {
    this.title = title;
    this.description = description;
    this.dateTime = dateTime;
    this.gradientColor = gradientColor;
  }
}
