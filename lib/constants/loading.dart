import 'package:alarm_app/constants/theme.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: backgroundTheme,
        ),
      ),
    );
  }
}
