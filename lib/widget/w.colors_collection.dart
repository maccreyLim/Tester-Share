import 'package:flutter/material.dart';

class ColorsCollection {
  static final ColorsCollection _instance = ColorsCollection._internal();

  factory ColorsCollection() {
    return _instance;
  }

  ColorsCollection._internal();

  Color get background => Colors.black;
  Color get textColor => Colors.white60;
  Color get buttonColor => Colors.blue;
  Color get iconColor => Colors.white;
  Color get cardColor => Colors.white12;
  Color get stateIsIng => Colors.blue;
  Color get stateIsClose => Colors.red;
  Color get importantMessage => Colors.red;
  Color get boxColor => Color.fromARGB(221, 31, 30, 30);
}
