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

  initUserId() async {
    dynamic result = await _auth.userId();
    if (result == null) {
      print("Error signing in");
    } else {
      print("Signed in");
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user != null) {
      return Home();
    } else {
      initUserId();
      print(user);
      return Loading();
    }
    // return Scaffold(
    //   body: Padding(
    //     padding: const EdgeInsets.all(50.0),
    //     child: Container(
    //       child: ElevatedButton(
    //         child: Text("Sign Out ANON"),
    //         onPressed: () {
    //           DatabaseService().signOut();
    //           print("Signed out");
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}
