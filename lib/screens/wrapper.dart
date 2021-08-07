import 'package:alarm_app/constants/loading.dart';
import 'package:alarm_app/screens/home.dart';
import 'package:alarm_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final DatabaseService _auth = DatabaseService();

  Future<dynamic> initUserId() async {
    dynamic result = await _auth.userId();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Home();
        } else {
          print("Loading... ${snapshot.data}");
          return Loading();
        }
      },
    );
  }
}
