import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DarkModeModel extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark {
    return _isDark;
  }

  toggleDarkMode() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
