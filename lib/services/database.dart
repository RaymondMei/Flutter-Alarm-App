import 'package:alarm_app/constants/theme.dart';
import 'package:alarm_app/models/alarm_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final CollectionReference alarmCollection =
      FirebaseFirestore.instance.collection("alarms");

  Future<String> createAlarm(AlarmInfo newAlarmInfo) async {
    String alarmId = Timestamp.now().toString();
    await alarmCollection.doc(alarmId).set({
      "dateTime": newAlarmInfo.dateTime,
      "title": newAlarmInfo.title,
      "description": newAlarmInfo.description,
      "gradientColor": newAlarmInfo.gradientColor,
      "active": newAlarmInfo.active,
      "repeat": newAlarmInfo.repeat,
      "days": newAlarmInfo.days,
      "vibrate": newAlarmInfo.vibrate,
      // }).then((docRef) => alarmId = docRef.id);
    });
    return alarmId;
  }

  Future<void> deleteAlarm(String alarmId) async {
    return await alarmCollection.doc(alarmId).delete();
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
    return alarmCollection.snapshots().map(_alarmListFromSnapshot);
  }

  Future updateAlarmDateTime(String alarmId, DateTime newDateTime) async {
    return await alarmCollection.doc(alarmId).update({
      "dateTime": newDateTime,
    });
  }

  Future updateAlarmTitle(String alarmId, String newTitle) async {
    return await alarmCollection.doc(alarmId).update({
      "title": newTitle,
    });
  }

  Future updateAlarmDescription(String alarmId, String newDescription) async {
    return await alarmCollection.doc(alarmId).update({
      "description": newDescription,
    });
  }

  Future updateAlarmActive(String alarmId, bool newActive) async {
    return await alarmCollection.doc(alarmId).update({
      "active": newActive,
    });
  }

  Future updateAlarmRepeat(String alarmId, bool newRepeat) async {
    return await alarmCollection.doc(alarmId).update({
      "repeat": newRepeat,
    });
  }

  Future updateAlarmDays(String alarmId, List<bool> newDays) async {
    return await alarmCollection.doc(alarmId).update({
      "days": newDays,
    });
  }

  Future updateAlarmVibrate(String alarmId, bool newVibrate) async {
    return await alarmCollection.doc(alarmId).update({
      "vibrate": newVibrate,
    });
  }
}
