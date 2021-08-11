import 'package:alarm_app/constants/theme.dart';
import 'package:alarm_app/main.dart';
import 'package:alarm_app/models/alarm_info.dart';
import 'package:alarm_app/services/schedule_alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var alarmCollection = <String, CollectionReference<Map<String, dynamic>>>{};
var uid = "";

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future userId() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      if (user != null) {
        createUser(user.uid);
        return user.uid;
      } else {
        return null;
      }
    } catch (e) {
      print("Error signing in: " + e.toString());
      return null;
    }
  }

  // DONT USE THIS
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  void createUser(String _uid) async {
    uid = _uid;
    alarmCollection.putIfAbsent(
        uid, () => userCollection.doc(uid).collection("alarms"));
  }

  Future<String> createAlarm(AlarmInfo newAlarmInfo) async {
    String alarmId = Timestamp.now().toString();
    newAlarmInfo.alarmId = alarmId;
    updateNoti(newAlarmInfo);
    await alarmCollection[uid]!.doc(alarmId).set({
      "dateTime": newAlarmInfo.dateTime,
      "title": newAlarmInfo.title,
      "description": newAlarmInfo.description,
      "gradientColor": newAlarmInfo.gradientColor,
      "active": newAlarmInfo.active,
      "repeat": newAlarmInfo.repeat,
      "days": newAlarmInfo.days,
      "vibrate": newAlarmInfo.vibrate,
    });
    return alarmId;
  }

  List<AlarmInfo> _alarmListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AlarmInfo(
        doc.get("dateTime").toDate() ?? DateTime.now(),
        doc.get("title") ?? "Alarm",
        doc.get("description") ??
            DateFormat.jm().format(DateTime.now().toLocal()),
        doc.get("gradientColor") ?? 0,
        doc.get("active") ?? true,
        doc.get("repeat") ?? false,
        doc.get("days") ?? List.filled(7, false),
        doc.get("vibrate") ?? false,
        alarmId: doc.id,
      );
    }).toList();
  }

  Stream<List<AlarmInfo>> get retrieveAlarms {
    return alarmCollection[uid]!.snapshots().map(_alarmListFromSnapshot);
  }

  Future<void> deleteAlarm(String alarmId) async {
    for (var i = 0; i < 7; i++) {
      flutterLocalNotificationsPlugin.cancel(alarmId.hashCode + i,
          tag: alarmId);
    }
    return await alarmCollection[uid]!.doc(alarmId).delete();
  }

  Future updateAlarmDateTime(AlarmInfo newAlarmInfo) async {
    updateNoti(newAlarmInfo);
    return await alarmCollection[uid]!.doc(newAlarmInfo.alarmId).update({
      "dateTime": newAlarmInfo.dateTime,
    });
  }

  Future updateAlarmTitle(AlarmInfo newAlarmInfo) async {
    updateNoti(newAlarmInfo);
    return await alarmCollection[uid]!.doc(newAlarmInfo.alarmId).update({
      "title": newAlarmInfo.title,
    });
  }

  Future updateAlarmDescription(AlarmInfo newAlarmInfo) async {
    updateNoti(newAlarmInfo);
    return await alarmCollection[uid]!.doc(newAlarmInfo.alarmId).update({
      "description": newAlarmInfo.description,
    });
  }

  Future updateAlarmActive(AlarmInfo newAlarmInfo) async {
    updateNoti(newAlarmInfo);
    return await alarmCollection[uid]!.doc(newAlarmInfo.alarmId).update({
      "active": newAlarmInfo.active,
    });
  }

  Future updateAlarmRepeat(AlarmInfo newAlarmInfo) async {
    updateNoti(newAlarmInfo);
    return await alarmCollection[uid]!.doc(newAlarmInfo.alarmId).update({
      "repeat": newAlarmInfo.repeat,
    });
  }

  Future updateAlarmDays(AlarmInfo newAlarmInfo) async {
    updateNoti(newAlarmInfo);
    return await alarmCollection[uid]!.doc(newAlarmInfo.alarmId).update({
      "days": newAlarmInfo.days,
    });
  }

  Future updateAlarmVibrate(AlarmInfo newAlarmInfo) async {
    updateNoti(newAlarmInfo);
    return await alarmCollection[uid]!.doc(newAlarmInfo.alarmId).update({
      "vibrate": newAlarmInfo.vibrate,
    });
  }
}
