import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tester_share_app/scr/home_screen.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

class DoorScreen extends StatelessWidget {
  final ColorsCollection colors = ColorsCollection();
  DoorScreen({super.key});

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
              Get.off(() => HomeScreen());
            },
            icon: Icon(
              Icons.close,
              color: colors.iconColor,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            createText(
                "Starting from November 13, 2023, new developers are required to have at least 20 testers participate for a duration of 14 days to register an app on Google Play. This policy has been implemented."),
            createText(
                "In response to this, developers, facing difficulties in gathering a sufficient number of testers, are forming mutually beneficial relationships and collaborating through Tester Share to test each other's apps."),
            createText(
                "This is an effort to explore ways for developers to successfully register their apps while complying with Google Play policies."),
            const SizedBox(height: 40),
            createText("[Flutter developer] Maccrey"),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget createText(String testMassage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        testMassage,
        style: TextStyle(color: colors.textColor, fontSize: 22),
      ),
    );
  }
}
