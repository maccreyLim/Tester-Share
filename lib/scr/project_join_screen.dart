import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

class ProjectJoinScreen extends StatelessWidget {
  ProjectJoinScreen({super.key});
  final ColorsCollection colors = ColorsCollection();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colors.background,
          actions: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.close,
                color: colors.iconColor,
              ),
            )
          ],
        ));
  }
}
