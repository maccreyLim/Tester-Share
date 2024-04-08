import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tester_share_app/scr/home_screen_tr.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
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
            createText(tr(
                "After November 13, 2023, a policy was implemented on Google Play requiring new individual developers to have at least 20 testers participate for 14 days before registering an app.")),
            createText(tr(
                "In response to this, developers, facing difficulty in gathering testers, have formed mutually beneficial relationships and are collaborating through Tester Share to test each other's apps.")),
            createText(tr(
                "This is an effort to explore ways for developers to successfully register their apps while complying with Google Play policies.")),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                createText("[ Flutter developer ] Maccrey".tr(), fontSize: 16),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }

  Widget createText(String testMessage, {double fontSize = 22}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        testMessage,
        style: TextStyle(color: colors.textColor, fontSize: fontSize),
      ),
    );
  }
}
