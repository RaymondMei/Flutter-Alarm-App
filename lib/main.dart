import 'package:alarm_app/constants/theme.dart';
import 'package:alarm_app/screens/wrapper.dart';
import 'package:alarm_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:alarm_app/screens/home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  var initializationSettingsAndroid =
      new AndroidInitializationSettings('codex_logo');
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
