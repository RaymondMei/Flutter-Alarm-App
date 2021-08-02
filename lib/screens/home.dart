import 'package:alarm_app/constants/theme.dart';
import 'package:alarm_app/services/database.dart';
import 'package:alarm_app/services/schedule_alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  Future<void> createAlarm() async {
    final TimeOfDay? alarmDateTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (alarmDateTime != null) {
      setState(() {
        _time = alarmDateTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2F41),
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text("Alarm App :)"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: alarms.map<Widget>((alarm) {
                  // SEPARATE ALARMS
                  return Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: alarm.gradientColor),
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      boxShadow: [
                        BoxShadow(
                          color: alarm.gradientColor.last.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 4,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.label,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  alarm.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: true,
                              onChanged: (bool value) {},
                              activeColor: Colors.white,
                            ),
                          ],
                        ),
                        Text(
                          alarm.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat.jm().format(alarm.dateTime.toLocal()),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 25,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: CircleBorder(),
                                minimumSize: Size.fromRadius(20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await createAlarm();
          print("TIME is : " + _time.toString());
          // scheduleAlarm();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}
