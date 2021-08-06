import 'dart:math';

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
import 'package:animations/animations.dart';

class AlarmList extends StatefulWidget {
  const AlarmList({Key? key}) : super(key: key);

  @override
  _AlarmListState createState() => _AlarmListState();
}

class _AlarmListState extends State<AlarmList> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double alarmDateTimeFontSize = screenWidth * 0.1;
    final double alarmOptionsFontSize = screenWidth * 0.05;
    final double alarmOptionsIconSize = screenWidth * 0.07;
    final double tileMargins = screenWidth * 0.03;
    final double paddingH = screenWidth * 0.025;
    final double paddingV = screenHeight * 0.008;

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
                String desc = alarm.repeat ? setDesc(alarm.days) : "";
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
                  margin: EdgeInsets.fromLTRB(
                      tileMargins, tileMargins, tileMargins, tileMargins / 6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: alarm.active ? Colors.transparent : Colors.black45,
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(
                          horizontal: paddingH, vertical: paddingV),
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
                                    fontSize: alarmDateTimeFontSize,
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
                                ),
                              ),
                              Transform.scale(
                                scale: max(1, screenWidth / 600),
                                child: Switch(
                                  value: alarm.active,
                                  onChanged: (val) {
                                    DatabaseService().updateAlarmActive(
                                        alarm.alarmId, !alarm.active);
                                  },
                                  activeColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          if (alarm.repeat == true && desc.length != 0) ...[
                            SizedBox(width: paddingH * 0.8),
                            Container(
                              child: Text(
                                desc,
                                style: TextStyle(
                                  color: alarm.active
                                      ? Colors.white
                                      : Colors.black54,
                                  fontSize: alarmOptionsFontSize * 0.75,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                          if (alarm.title.length != 0) ...[
                            SizedBox(width: paddingH * 0.8),
                            Icon(
                              Icons.label,
                              color:
                                  alarm.active ? Colors.white : Colors.black54,
                              size: alarmOptionsIconSize * 0.7,
                            ),
                            SizedBox(width: paddingH * 0.8),
                            Expanded(
                              child: Text(
                                alarm.title,
                                style: TextStyle(
                                  color: alarm.active
                                      ? Colors.white
                                      : Colors.black54,
                                  fontSize: alarmOptionsFontSize * 0.9,
                                ),
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ],
                      ),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingH * 2.5,
                              vertical: paddingV * 1.5),
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
                                            size: alarmOptionsIconSize,
                                          )
                                        : Icon(
                                            Icons.check_box_outline_blank,
                                            size: alarmOptionsIconSize,
                                          ),
                                    label: Text(
                                      "Repeat",
                                      style: TextStyle(
                                        fontSize: alarmOptionsFontSize,
                                      ),
                                    ),
                                    onPressed: () {
                                      alarm.repeat = !alarm.repeat;
                                      DatabaseService().updateAlarmRepeat(
                                          alarm.alarmId, alarm.repeat);
                                      if (desc.length == 0) {
                                        alarm.days[0] = true;
                                        DatabaseService().updateAlarmDays(
                                            alarm.alarmId, alarm.days);
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.45,
                                    child: WeekdaySelector(
                                      firstDayOfWeek: 0,
                                      onChanged: (int day) {
                                        alarm.days[day % 7] =
                                            !alarm.days[day % 7];
                                        DatabaseService().updateAlarmDays(
                                            alarm.alarmId, alarm.days);
                                        if (alarm.days
                                            .every((_day) => _day == false)) {
                                          alarm.repeat = false;
                                          DatabaseService().updateAlarmRepeat(
                                              alarm.alarmId, alarm.repeat);
                                        }
                                      },
                                      values: alarm.repeat
                                          ? alarm.days
                                          : List.filled(7, null),
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
                                      size: alarmOptionsIconSize,
                                    ),
                                    label: Text(
                                      "Alarm Sound",
                                      style: TextStyle(
                                        fontSize: alarmOptionsFontSize,
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
                                            size: alarmOptionsIconSize,
                                          )
                                        : Icon(
                                            Icons.check_box_outline_blank,
                                            size: alarmOptionsIconSize,
                                          ),
                                    label: Text(
                                      "Vibrate",
                                      style: TextStyle(
                                        fontSize: alarmOptionsFontSize,
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
                                    size: alarmOptionsIconSize * 1.05,
                                  ),
                                  label: Text(
                                    "Label",
                                    style: TextStyle(
                                      fontSize: alarmOptionsFontSize,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    alignment: Alignment.centerLeft,
                                  ),
                                  onPressed: () async {
                                    alarm.title =
                                        await setTitle(context, alarm.title);
                                    DatabaseService().updateAlarmTitle(
                                        alarm.alarmId, alarm.title);
                                  },
                                ),
                              ),
                              Divider(thickness: 1, color: Colors.white),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  icon: Icon(
                                    Icons.delete_outlined,
                                    size: alarmOptionsIconSize * 1.1,
                                  ),
                                  label: Text(
                                    "Delete",
                                    style: TextStyle(
                                      fontSize: alarmOptionsFontSize * 1.3,
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
