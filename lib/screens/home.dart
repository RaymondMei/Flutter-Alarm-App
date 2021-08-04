import 'dart:math';
import 'package:alarm_app/models/alarm_info.dart';
import 'package:alarm_app/screens/alarm_list.dart';
import 'package:alarm_app/services/database.dart';
import 'package:alarm_app/services/schedule_alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:alarm_app/constants/theme.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDarkMode = true;
  int nextGradientColor = (alarms.length == 0 ? 0 : alarms.length - 1) % 5;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<AlarmInfo>>.value(
      value: DatabaseService().retrieveAlarms,
      initialData: [],
      child: Scaffold(
        backgroundColor: isDarkMode ? backgroundTheme : Colors.white,
        appBar: AppBar(
          backgroundColor: backgroundTheme[900],
          title: Text("Alarm App"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                },
                child: isDarkMode
                    ? Icon(Icons.wb_sunny)
                    : Icon(Icons.brightness_2_outlined),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  shape: CircleBorder(),
                  splashFactory: InkSplash.splashFactory,
                  minimumSize: Size.fromRadius(20),
                ))
          ],
        ),
        body: AlarmList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            DateTime? newAlarmDateTime = await setDateTime(context);
            if (newAlarmDateTime != null) {
              AlarmInfo newAlarm = new AlarmInfo(
                newAlarmDateTime,
                "Title",
                "Description",
                nextGradientColor,
                true,
              );
              await DatabaseService()
                  .createAlarm(newAlarm)
                  .then((alarmId) => newAlarm.alarmId = alarmId);
              print(newAlarm.alarmId);
              nextGradientColor++;
              nextGradientColor %= 5;
              // nextGradientColor = new Random().nextInt(5);
              setState(() {
                alarms.add(newAlarm);
              });
            }
          },
          child: Icon(Icons.add),
          backgroundColor: backgroundTheme[900],
        ),
      ),
    );
  }
}
