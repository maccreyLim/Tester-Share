import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/model/notice_firebase_model.dart';
import 'package:tester_share_app/scr/update_notice_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class DetailNoticeScreen extends StatelessWidget {
  //Property
  final NoticeFirebaseModel notice;
  final ColorsCollection colors = ColorsCollection();
  final AuthController authController = AuthController.instance;
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  DetailNoticeScreen({super.key, required this.notice});

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
        body: Container(
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: detailScreen()),
                if (authController.userData!['isAdmin']) confirmButton(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          child: BannerAD(),
        ));
  }

  Widget detailScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Text(
            notice.title,
            style: TextStyle(
              fontSize: _fontSizeCollection.settinFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 1.0,
            width: double.infinity,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notice.content,
                style: TextStyle(
                  fontSize: _fontSizeCollection.settinFontSize,
                  color: colors.textColor,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          // 원하는 다른 위젯 추가
        ],
      ),
    );
  }

  Widget confirmButton() {
    return Container(
      height: _fontSizeCollection.buttonSize,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => UpdateNoticeScreen(notice: notice));
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colors.stateIsIng),
        ),
        child: Text(
          "Update",
          style: TextStyle(
              fontSize: _fontSizeCollection.buttonFontSize,
              // fontWeight: FontWeight.bold,
              color: colors.iconColor),
        ),
      ),
    );
  }
}
