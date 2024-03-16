import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/scr/door_screen.dart';
import 'package:tester_share_app/scr/my_tester_request_post_tr.dart';
import 'package:tester_share_app/scr/myinformation_screen.dart';
import 'package:tester_share_app/scr/notice_screen.dart';
import 'package:tester_share_app/scr/terms_and_privacy_screen.dart';
import 'package:tester_share_app/scr/unapproved_post_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.interstitle_ad.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SettingScreen extends StatelessWidget {
  final ColorsCollection colors = ColorsCollection();
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final InterstitialAdController adController = InterstitialAdController();
  final AuthController _authController = AuthController.instance;

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
                Get.back();
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
                style: TextStyle(
                  color: colors.textColor,
                  fontSize: _fontSizeCollection.subjectFontSize,
                ),
              ).tr(),
              SizedBox(height: 30),
              Row(
                children: [
                  Icon(
                    Icons.question_mark,
                    color: colors.iconColor,
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                      onPressed: () {
                        Get.to(DoorScreen());
                      },
                      child: Text(
                        "Tester Share is?",
                        style: TextStyle(
                            color: colors.textColor,
                            fontSize: _fontSizeCollection.settingFontSize),
                      ).tr()),
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
                            fontSize: _fontSizeCollection.settingFontSize),
                      ).tr()),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: colors.iconColor,
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                      onPressed: () {
                        Get.to(() => MyInformationScreen());
                      },
                      child: Text(
                        "My Page",
                        style: TextStyle(
                            color: colors.textColor,
                            fontSize: _fontSizeCollection.settingFontSize),
                      ).tr()),
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
                            fontSize: _fontSizeCollection.settingFontSize),
                      ).tr()),
                ],
              ),
              if (_authController.userData!['isAdmin'] == true)
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
                              fontSize: _fontSizeCollection.settingFontSize),
                        ).tr()),
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
                        // Get.to(() => InquiriesAndPartnershipsScreen());
                        _sendEmail();
                      },
                      child: Text(
                        "Inquiries and Partnerships",
                        style: TextStyle(
                            color: colors.textColor,
                            fontSize: _fontSizeCollection.settingFontSize),
                      ).tr()),
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
                        Get.to(() => const TermsAndPrivacyScreen());
                      },
                      child: Text(
                        "Terms and Privacy",
                        style: TextStyle(
                            color: colors.textColor,
                            fontSize: _fontSizeCollection.settingFontSize),
                      ).tr()),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.tv,
                    color: colors.iconColor,
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      // InterstitialAdExample();
                      adController.loadAndShowAd();
                    },
                    child: Text(
                      "After watching the advertisement, \nsupport us",
                      style: TextStyle(
                        color: colors.textColor,
                        fontSize: _fontSizeCollection.settingFontSize,
                      ),
                    ).tr(),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          child: BannerAD(),
        ));
  }

  void _sendEmail() async {
    var _body = tr(
        "Please provide the following information for assistance.\nID:\nOS Version:\nDevice Modle:\nPlease write ypur inquiry below.\n");
    var _subject = tr('Inquiry and Partnership Inquiry Regarding Tester Share');
    final Email email = Email(
        body: _body,
        subject: _subject,
        recipients: ['maccrey@naver.com'],
        cc: ['m01071630214@gmail.com'],
        isHTML: false);

    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      String title = tr(
          "Since I cannot use the default mail app,\nit is difficult to send inquiries directly through the app.\n\nPlease use your preferred email\nand send inquiries to maccrey@naver.com. Thank you.");
      ;
      Get.defaultDialog(
        title: tr("Guidance"),
        content: Text(title),
        textConfirm: tr("Confirmation"),
        confirmTextColor: Colors.white54,
        onConfirm: Get.back,
      );
    }
  }
}
