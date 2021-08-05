import 'package:alarm_app/constants/theme.dart';
import 'package:alarm_app/models/alarm_info.dart';
import 'package:alarm_app/services/database.dart';
import 'package:alarm_app/services/schedule_alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AlarmList extends StatefulWidget {
  const AlarmList({Key? key}) : super(key: key);

  @override
  _AlarmListState createState() => _AlarmListState();
}

class _AlarmListState extends State<AlarmList> {
  @override
  Widget build(BuildContext context) {
    final alarms = Provider.of<List<AlarmInfo>>(context);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                AlarmInfo alarm = alarms[index];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: gradientTemplate[alarm.gradientColor]),
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    boxShadow: [
                      BoxShadow(
                        color: alarm.active
                            ? gradientTemplate[alarm.gradientColor]
                                .last
                                .withOpacity(0.4)
                            : Colors.transparent,
                        blurRadius: 8,
                        spreadRadius: 4,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(12, 12, 12, 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: alarm.active ? Colors.transparent : Colors.black45,
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
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
                                    color: alarm.active
                                        ? Colors.white
                                        : Colors.black54,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  DateTime? newDateTime =
                                      await setDateTime(context);
                                  if (newDateTime != null) {
                                    DatabaseService().updateAlarmDateTime(
                                        alarm.alarmId, newDateTime);
                                  }
                                },
                                style: ButtonStyle(
                                  splashFactory: InkRipple.splashFactory,
                                  // enableFeedback: true,
                                ),
                              ),
                              Switch(
                                value: alarm.active,
                                onChanged: (val) {
                                  DatabaseService().updateAlarmActive(
                                      alarm.alarmId, !alarm.active);
                                },
                                activeColor: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          // Icon(
                          //   Icons.label,
                          //   color: alarm.active ? Colors.white : Colors.black54,
                          //   size: 24,
                          // ),
                          // SizedBox(width: 10),
                          // Text(
                          //   alarm.title,
                          //   style: TextStyle(
                          //     color:
                          //         alarm.active ? Colors.white : Colors.black54,
                          //     fontSize: 16,
                          //   ),
                          // ),
                          // SizedBox(width: 5),
                          // Icon(
                          //   Icons.circle,
                          //   size: 5,
                          //   color: alarm.active ? Colors.white : Colors.black54,
                          // ),
                          // SizedBox(width: 5),
                          // Text(
                          //   alarm.description,
                          //   style: TextStyle(
                          //     color:
                          //         alarm.active ? Colors.white : Colors.black54,
                          //     fontSize: 16,
                          //   ),
                          // ),
                        ],
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    icon: alarm.repeat
                                        ? Icon(
                                            Icons.check_box_outlined,
                                            size: 26,
                                          )
                                        : Icon(
                                            Icons.check_box_outline_blank,
                                            size: 26,
                                          ),
                                    label: Text(
                                      "Repeat",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () {
                                      alarm.repeat = !alarm.repeat;
                                      DatabaseService().updateAlarmRepeat(
                                          alarm.alarmId, alarm.repeat);
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: WeekdaySelector(
                                      onChanged: (int day) {
                                        alarm.days[day % 7] =
                                            !alarm.days[day % 7];
                                        DatabaseService().updateAlarmDays(
                                            alarm.alarmId, alarm.days);
                                      },
                                      values: alarm.days,
                                      color:
                                          gradientTemplate[alarm.gradientColor]
                                              .first,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    icon: Icon(
                                      Icons.notifications_on_outlined,
                                      size: 26,
                                    ),
                                    label: Text(
                                      "Alarm Sound",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                  TextButton.icon(
                                    icon: alarm.vibrate
                                        ? Icon(
                                            Icons.check_box_outlined,
                                            size: 26,
                                          )
                                        : Icon(
                                            Icons.check_box_outline_blank,
                                            size: 26,
                                          ),
                                    label: Text(
                                      "Vibrate",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () {
                                      alarm.vibrate = !alarm.vibrate;
                                      DatabaseService().updateAlarmVibrate(
                                          alarm.alarmId, alarm.vibrate);
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  icon: Icon(
                                    Icons.label_outline,
                                    size: 26,
                                  ),
                                  label: Text(
                                    "Label",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    alignment: Alignment.centerLeft,
                                  ),
                                  onPressed: () async {
                                    // return showDialog(
                                    //   context: context,
                                    //   builder: (_) => AlertDialog(
                                    //     title: Text("Label"),
                                    //     content: TextField(),
                                    //   ),
                                    // );
                                  },
                                ),
                              ),
                              Divider(thickness: 0.5, color: Colors.white),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  icon: Icon(
                                    Icons.delete_outlined,
                                    size: 28,
                                  ),
                                  label: Text(
                                    "Delete",
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                  onPressed: () {
                                    DatabaseService()
                                        .deleteAlarm(alarm.alarmId);
                                  },
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
