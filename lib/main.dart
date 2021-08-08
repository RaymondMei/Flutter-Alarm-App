import 'package:alarm_app/constants/theme.dart';
import 'package:alarm_app/screens/wrapper.dart';
import 'package:alarm_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:alarm_app/screens/home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();

  var initializationSettingsAndroid =
      new AndroidInitializationSettings('@drawable/codex_logo');
  var initializationSettingsIOS = new IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {});
  var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ALARM APP",
      theme: ThemeData(
        primarySwatch: backgroundTheme,
        dialogTheme: DialogTheme(
          backgroundColor: backgroundTheme,
        ),
      ),
      home: StreamProvider<User?>.value(
        value: DatabaseService().user,
        initialData: null,
        child: Wrapper(),
      ),
    ),
  );
}
