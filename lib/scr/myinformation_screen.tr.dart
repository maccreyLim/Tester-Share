import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/scr/change_password_screen_tr.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class MyInformationScreen extends StatelessWidget {
  final ColorsCollection colors = ColorsCollection();
  final AuthController _authController = AuthController.instance;
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();

  MyInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = _authController.userData!['createAt'];
    DateTime createAt = timestamp.toDate();
    String formattedDate = formatDateTime(createAt, 'yyyy년 MM월 dd일');

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
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Information",
              style: TextStyle(
                fontSize: _fontSizeCollection.subjectFontSize,
                color: colors.textColor,
              ),
            ).tr(),
            const SizedBox(height: 40),
            _textForm('email', 'E - mail'),
            const SizedBox(height: 20),
            _textForm('formattedDate', 'Registration Date', formattedDate),
            const SizedBox(height: 20),
            _textForm('deployed', tr('Number of App Launch Experiences')),
            const SizedBox(height: 20),
            _textForm('testerRequest', tr('Number of Tester Requests')),
            const SizedBox(height: 20),
            _textForm(
                'testerParticipation', tr('Number of Tester Participation')),
            const SizedBox(height: 20),
            _textForm('point', 'point'),
            const SizedBox(height: 20),
            Expanded(child: Container()),
            changePasswordButton(),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }

  Widget _textForm(String field, String subject, [String? additionalData]) {
    dynamic data = _authController.userData![field];

    String yearText = tr("year");
    String monthText = tr("month");
    String dayText = tr("day");

    // Timestamp 또는 int인 경우 문자열로 변환
    if (data is Timestamp) {
      data = formatDateTime(
          data.toDate(), 'yyyy $yearText MM $monthText dd $dayText');
    } else if (data is int) {
      data = data.toString();
    }

    if (additionalData != null) {
      data = additionalData;
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: _fontSizeCollection.settingFontSize,
          color: colors.textColor,
        ),
        children: [
          TextSpan(
            text: '$subject : ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '$data',
            style: const TextStyle(color: Colors.blue), // 변경하고자 하는 글자색으로 설정
          ),
        ],
      ),
    );
  }

  String formatDateTime(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  Widget changePasswordButton() {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => const ChangePasswordScreen());
          // _authController.changePassword(email, currentPassword, newPassword)
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colors.stateIsIng),
        ),
        child: Text(
          "Change Password",
          style: TextStyle(
              fontSize: _fontSizeCollection.buttonFontSize,
              // fontWeight: FontWeight.bold,
              color: colors.iconColor),
        ),
      ),
    );
  }
}
