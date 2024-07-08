import 'package:flutter/material.dart';

class DarkMode extends ChangeNotifier {
  bool value = false;
  bool get isValue => value;

  void Change() {
    value = !value;
    notifyListeners();
  }
}
