import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/scr/home_screen.dart';
import 'package:tester_share_app/scr/inquiries_and_partnerships_screen.dart';
import 'package:tester_share_app/scr/my_tester_request_post.dart';
import 'package:tester_share_app/scr/mypage_screen.dart';
import 'package:tester_share_app/scr/notice_screen.dart';
import 'package:tester_share_app/scr/terms_and_privacy_screen.dart';
import 'package:tester_share_app/scr/unapproved_post_screen.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class SettingScreen extends StatelessWidget {
  final ColorsCollection colors = ColorsCollection();
  final AuthController _authController = AuthController.instance;
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  SettingScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
        child: Column(
          children: [
            Text(
              "Setting",
              style: TextStyle(color: colors.textColor, fontSize: 28),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: colors.iconColor,
                ),
                const SizedBox(width: 10),
                TextButton(
                    onPressed: () {
                      Get.to(() => MypageScreen());
                    },
                    child: Text(
                      "My Page",
                      style: TextStyle(
                          color: colors.textColor,
                          fontSize: _fontSizeCollection.SettinFontSize),
                    )),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.assignment,
                  color: colors.iconColor,
                ),
                const SizedBox(width: 10),
                TextButton(
                    onPressed: () {
                      Get.to(() => MyTesterRequestPostScreen());
                    },
                    child: Text(
                      "My Tester Request Post",
                      style: TextStyle(
                          color: colors.textColor,
                          fontSize: _fontSizeCollection.SettinFontSize),
                    )),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.post_add,
                  color: colors.iconColor,
                ),
                const SizedBox(width: 10),
                TextButton(
                    onPressed: () {
                      Get.to(() => UnapprovedPostScreen());
                    },
                    child: Text(
                      "Unapproved post",
                      style: TextStyle(
                          color: colors.textColor,
                          fontSize: _fontSizeCollection.SettinFontSize),
                    )),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.announcement,
                  color: colors.iconColor,
                ),
                const SizedBox(width: 10),
                TextButton(
                    onPressed: () {
                      Get.to(() => NoticeScreen());
                    },
                    child: Text(
                      "Notice",
                      style: TextStyle(
                          color: colors.textColor,
                          fontSize: _fontSizeCollection.SettinFontSize),
                    )),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.mail,
                  color: colors.iconColor,
                ),
                const SizedBox(width: 10),
                TextButton(
                    onPressed: () {
                      Get.to(() => InquiriesAndPartnershipsScreen());
                    },
                    child: Text(
                      "Inquiries and Partnerships",
                      style: TextStyle(
                          color: colors.textColor,
                          fontSize: _fontSizeCollection.SettinFontSize),
                    )),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.library_books,
                  color: colors.iconColor,
                ),
                const SizedBox(width: 10),
                TextButton(
                    onPressed: () {
                      Get.to(() => TermsAndPrivacyScreen());
                    },
                    child: Text(
                      "Terms and Privacy",
                      style: TextStyle(
                          color: colors.textColor,
                          fontSize: _fontSizeCollection.SettinFontSize),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
