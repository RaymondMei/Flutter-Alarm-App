import 'package:alarm_app/models/alarm_info.dart';
import 'package:alarm_app/models/dark_mode.dart';
import 'package:alarm_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:alarm_app/constants/theme.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    // required this.isExpanded,
    // required this.expandedChild,
    // required this.collapsedChild})
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDarkMode = false;

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  Future<DateTime> createAlarm() async {
    final TimeOfDay? alarmDateTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (alarmDateTime != null) {
      DateTime _now = new DateTime.now();
      return new DateTime(_now.year, _now.month, _now.day, alarmDateTime.hour,
          alarmDateTime.minute);
    } else {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF2D2F41),
      backgroundColor: isDarkMode ? Color(0xFF2D2F41) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text("Alarm App :)"),
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: alarms.map<Widget>((alarm) {
                  List<Color> defaultGradientColor = alarm.gradientColor;
                  // SEPARATE ALARMS
                  return Container(
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
                    margin: EdgeInsets.fromLTRB(12, 12, 12, 2),
                    child: ExpansionTile(
                      tilePadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      backgroundColor: Colors.transparent,
                      collapsedIconColor: Colors.white,
                      iconColor: Color(0xFF2D2F41),
                      title: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: Text(
                                  DateFormat.jm()
                                      .format(alarm.dateTime.toLocal()),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    // backgroundColor: Colors.white30,
                                  ),
                                ),
                                onPressed: () async {
                                  DateTime newDateTime = await createAlarm();
                                  setState(() {
                                    alarm.dateTime = newDateTime;
                                  });
                                },
                                style: ButtonStyle(
                                  splashFactory: InkRipple.splashFactory,
                                  // enableFeedback: true,
                                ),
                              ),
                              Switch(
                                value: alarm.isActive,
                                onChanged: (bool val) {
                                  setState(() {
                                    alarm.isActive = !alarm.isActive;
                                    print(alarm.isActive);
                                    if (alarm.isActive) {
                                      alarm.gradientColor = GradientColors.sky;
                                    } else {
                                      alarm.gradientColor =
                                          GradientColors.disabled;
                                    }
                                  });
                                },
                                activeColor: Colors.white,
                              ),
                            ],
                          ),
                          Row(
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
                                  SizedBox(width: 10),
                                  // Text(
                                  //   alarm.description,
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: 12,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  TextButton.icon(
                                    icon: Icon(Icons.check_box_outline_blank),
                                    label: Text("Repeat"),
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    icon: Icon(Icons.notifications_on_outlined),
                                    label: Text("Alarm Sound"),
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                  TextButton.icon(
                                    icon: Icon(Icons.check_box_outline_blank),
                                    label: Text("Vibrate"),
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  TextButton.icon(
                                    icon: Icon(Icons.label_outline),
                                    label: Text("Label"),
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(thickness: 0.5, color: Colors.white),
                              Row(
                                children: <Widget>[
                                  TextButton.icon(
                                    icon: Icon(Icons.delete_outline),
                                    label: Text("Delete"),
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
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
