import 'dart:math';
import 'package:alarm_app/main.dart';
import 'package:alarm_app/models/alarm_info.dart';
import 'package:alarm_app/screens/alarm_list.dart';
import 'package:alarm_app/services/database.dart';
import 'package:alarm_app/services/schedule_alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:alarm_app/constants/theme.dart';
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDarkMode = true;
  // int nextGradientColor = (alarms.length == 0 ? 0 : alarms.length - 1) % 5;
  int nextGradientColor = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification != null && android != null) {
  //       flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             channel.description,
  //             color: Colors.blue,
  //             playSound: true,
  //           ),
  //         ),
  //       );
  //     }
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print("New onMessageOpenedApp even was published!");
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification != null && android != null) {
  //       showDialog(
  //         context: context,
  //         builder: (_) {
  //           return AlertDialog(
  //             title: Text(notification.title.toString()),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(notification.body.toString()),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     }
  //   });
  // }

  // void showNotification() {
  //   int _counter = 0;
  //   setState(() {
  //     _counter++;
  //   });
  //   flutterLocalNotificationsPlugin.show(
  //     0,
  //     "Test $_counter",
  //     "How you Doing ? ",
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         channel.id,
  //         channel.name,
  //         channel.description,
  //         importance: Importance.max,
  //         playSound: true,
  //       ),
  //     ),
  //   );
  // }

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

            // * debugging code; delete later
            // TextButton(
            //   child: Text("List Notifs", style: TextStyle(color: Colors.white)),
            //   onPressed: () {
            //     flutterLocalNotificationsPlugin
            //         .pendingNotificationRequests()
            //         .then(
            //           (value) => {
            //             print(value.length),
            //             value.forEach((v) => print("${v.title} ${v.id}"))
            //           },
            //         );
            //   },
            // ),
            // TextButton(
            //   child:
            //       Text("Delete Notifs", style: TextStyle(color: Colors.white)),
            //   onPressed: () {
            //     flutterLocalNotificationsPlugin.cancelAll();
            //     print("Deleted :(");
            //   },
            // ),
            // *
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
