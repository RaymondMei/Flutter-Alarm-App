import 'package:alarm_app/constants/theme.dart';
import 'package:alarm_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:animations/animations.dart';

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
