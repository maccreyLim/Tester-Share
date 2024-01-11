import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/scr/home_screen.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

class CreateBoardScreen extends StatelessWidget {
  final ColorsCollection colors = ColorsCollection();
  CreateBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.background,
        actions: [
          IconButton(
            onPressed: () {
              Get.off(() => HomeScreen());
            },
            icon: Icon(
              Icons.close,
              color: colors.iconColor,
            ),
          )
        ],
      ),
      body: Container(
        color: Color(0xFF2196F3),
      ),
    );
  }
}
