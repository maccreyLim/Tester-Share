import 'package:flutter/material.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

Widget cardText(String text, double size) {
  final ColorsCollection colors = ColorsCollection();
  return Text(
    text,
    style: TextStyle(color: colors.textColor, fontSize: size),
  );
}
