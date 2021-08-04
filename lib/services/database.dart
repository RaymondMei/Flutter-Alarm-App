import 'package:alarm_app/constants/theme.dart';
import 'package:alarm_app/models/alarm_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<AlarmInfo> alarms = [
  // AlarmInfo(DateTime.now(), "Office", "Going :)", GradientColors.sky, true),
  // AlarmInfo(DateTime.now(), "Sport", "Going :)", GradientColors.sunset, true),
  // AlarmInfo("Game", "Going :)", DateTime.now(), GradientColors.sea, true),
  // AlarmInfo("School", "Going :)", DateTime.now(), GradientColors.mango, true),
  // AlarmInfo("Wakeup", "Going :)", DateTime.now(), GradientColors.fire, true),
];

class DatabaseService {
  // final String alarmId;
  // DatabaseService({required this.alarmId});

  final CollectionReference alarmCollection =
      FirebaseFirestore.instance.collection("alarms");

  Future<String> createAlarm(AlarmInfo newAlarmInfo) async {
    String alarmId = "";
    await alarmCollection.add({
      "dateTime": newAlarmInfo.dateTime,
      "title": newAlarmInfo.title,
      "description": newAlarmInfo.description,
      "gradientColor": newAlarmInfo.gradientColor,
      "isActive": newAlarmInfo.isActive,
    }).then((docRef) => alarmId = docRef.id);
    return alarmId;
  }

  Future updateAlarm(String alarmId, AlarmInfo newAlarmInfo) async {
    return await alarmCollection.doc(alarmId).update({
      "dateTime": newAlarmInfo.dateTime,
      "title": newAlarmInfo.title,
      "description": newAlarmInfo.description,
      "gradientColor": newAlarmInfo.gradientColor,
      "isActive": newAlarmInfo.isActive,
    });
  }

  List<AlarmInfo> _alarmListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AlarmInfo(
        doc.get("dateTime").toDate() ?? DateTime.now(),
        doc.get("title") ?? "Title",
        doc.get("description") ?? "Description",
        doc.get("gradientColor") ?? 0,
        doc.get("isActive") ?? false,
        alarmId: doc.id,
      );
    }).toList();
  }

  Stream<List<AlarmInfo>> get retrieveAlarms {
    return alarmCollection.snapshots().map(_alarmListFromSnapshot);
  }
}
