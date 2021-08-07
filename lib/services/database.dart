import 'package:alarm_app/constants/theme.dart';
import 'package:alarm_app/models/alarm_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<void> deleteAlarm(String alarmId) async {
    return await alarmCollection[uid]!.doc(alarmId).delete();
  }

  List<AlarmInfo> _alarmListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AlarmInfo(
        doc.get("dateTime").toDate() ?? DateTime.now(),
        doc.get("title") ?? "Title",
        doc.get("description") ?? "Description",
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

  Future updateAlarmDateTime(String alarmId, DateTime newDateTime) async {
    return await alarmCollection[uid]!.doc(alarmId).update({
      "dateTime": newDateTime,
    });
  }

  Future updateAlarmTitle(String alarmId, String newTitle) async {
    return await alarmCollection[uid]!.doc(alarmId).update({
      "title": newTitle,
    });
  }

  Future updateAlarmDescription(String alarmId, String newDescription) async {
    return await alarmCollection[uid]!.doc(alarmId).update({
      "description": newDescription,
    });
  }

  Future updateAlarmActive(String alarmId, bool newActive) async {
    return await alarmCollection[uid]!.doc(alarmId).update({
      "active": newActive,
    });
  }

  Future updateAlarmRepeat(String alarmId, bool newRepeat) async {
    return await alarmCollection[uid]!.doc(alarmId).update({
      "repeat": newRepeat,
    });
  }

  Future updateAlarmDays(String alarmId, List<bool> newDays) async {
    return await alarmCollection[uid]!.doc(alarmId).update({
      "days": newDays,
    });
  }

  Future updateAlarmVibrate(String alarmId, bool newVibrate) async {
    return await alarmCollection[uid]!.doc(alarmId).update({
      "vibrate": newVibrate,
    });
  }
}
