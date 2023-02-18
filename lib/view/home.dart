import 'package:alarm_app/model/alarm_info.dart';
import 'package:alarm_app/view/alarm_list.dart';
import 'package:alarm_app/model/database.dart';
import 'package:alarm_app/controller/schedule_alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alarm_app/view/constants/theme.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDarkMode = true;
  int nextGradientColor = 0;

  var dbg = false;
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
              ),
            ),
          ],
        ),
        body: AlarmList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            DateTime? newAlarmDateTime = await setDateTime(context);
            if (newAlarmDateTime != null) {
              AlarmInfo newAlarm = new AlarmInfo(
                newAlarmDateTime,
                "",
                "",
                nextGradientColor,
                true,
                false,
                List.filled(7, false),
                false,
              );
              await DatabaseService()
                  .createAlarm(newAlarm)
                  .then((alarmId) => newAlarm.alarmId = alarmId);
              nextGradientColor = (nextGradientColor + 1) % 5;
            }
          },
          child: Icon(Icons.add),
          backgroundColor: backgroundTheme[900],
        ),
      ),
    );
  }
}
