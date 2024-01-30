import 'package:flutter/material.dart';

class ColorsCollection {
  static final ColorsCollection _instance = ColorsCollection._internal();

  factory ColorsCollection() {
    return _instance;
  }

  ColorsCollection._internal();

  Color get background => Colors.black;
  Color get textColor => Colors.white60;
  Color get iconColor => Colors.white;
  Color get cardColor => Colors.white12;
  Color get stateIsIng => Colors.blue;
  Color get stateIsClose => Colors.red;
}
