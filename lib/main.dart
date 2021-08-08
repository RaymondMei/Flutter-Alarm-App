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

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     "High Importance Notifications", // title
//     "This channel is used for important notifications", // desc
//     importance: Importance.max,
//     playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Bg message: ${message.messageId}");
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //     alert: true, badge: true, sound: true);

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
