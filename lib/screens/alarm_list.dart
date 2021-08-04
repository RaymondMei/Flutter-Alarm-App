import 'package:alarm_app/constants/theme.dart';
import 'package:alarm_app/models/alarm_info.dart';
import 'package:alarm_app/services/schedule_alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
                // SEPARATE ALARMS
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: gradientTemplate[alarm.gradientColor]),
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    boxShadow: [
                      BoxShadow(
                        color: alarm.isActive
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
                  // DISABLED COLOR COVER
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          alarm.isActive ? Colors.transparent : Colors.black45,
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
                                    color: alarm.isActive
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
                                    // setState(() {
                                    //   alarm.dateTime = newDateTime;
                                    // });
                                  }
                                },
                                style: ButtonStyle(
                                  splashFactory: InkRipple.splashFactory,
                                  // enableFeedback: true,
                                ),
                              ),
                              Switch(
                                value: alarm.isActive,
                                onChanged: (val) {
                                  setState(() {
                                    alarm.isActive = !alarm.isActive;
                                  });
                                },
                                activeColor: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.label,
                                color: alarm.isActive
                                    ? Colors.white
                                    : Colors.black54,
                                size: 24,
                              ),
                              SizedBox(width: 10),
                              Text(
                                alarm.title,
                                style: TextStyle(
                                  color: alarm.isActive
                                      ? Colors.white
                                      : Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.circle,
                                size: 5,
                                color: alarm.isActive
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              SizedBox(width: 5),
                              Text(
                                alarm.description,
                                style: TextStyle(
                                  color: alarm.isActive
                                      ? Colors.white
                                      : Colors.black54,
                                  fontSize: 16,
                                ),
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
