import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/scr/change_password_screen_tr.dart';
import 'package:tester_share_app/widget/w.RewardAdManager.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class MyInformationScreen extends StatefulWidget {
  const MyInformationScreen({Key? key}) : super(key: key);

  @override
  State<MyInformationScreen> createState() => _MyInformationScreenState();
}

class _MyInformationScreenState extends State<MyInformationScreen> {
  final ColorsCollection colors = ColorsCollection();

  final AuthController _authController = AuthController.instance;

  final FontSizeCollection _fontSizeCollection = FontSizeCollection();

  late int maxTester;

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = _authController.userData!['createAt'];
    DateTime createAt = timestamp.toDate();
    String formattedDate = formatDateTime(createAt, 'yyyy년 MM월 dd일');
    maxTester = 0;

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
            Obx(() =>
                _textForm('deployed', tr('Number of App Launch Experiences'))),
            const SizedBox(height: 20),
            Obx(() =>
                _textForm('testerRequest', tr('Number of Tester Requests'))),
            const SizedBox(height: 20),
            Obx(() => _textForm(
                'testerParticipation', tr('Number of Tester Participation'))),
            const SizedBox(height: 20),
            Obx(() => _textForm('point', 'point')),
            const SizedBox(height: 10),
            Obx(() {
              maxTester = _authController.userData!['point'] ?? 0;
              return Text(
                "( You can request recruitment of up to {} testers currently. )",
                style: TextStyle(color: colors.textColor),
              ).tr(args: [
                '$maxTester'
              ]).tr(); // 변경 사항을 반영해야 할 화면 요소가 있는 위젯을 반환합니다.
            }),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  showRewardAd();
                },
                child: const Text("Earn points by watching \nadvertisements")
                    .tr()),
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
      maxTester = data;
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
        ).tr(),
      ),
    );
  }

  void showRewardAd() {
    final RewardAdManager _rewardAd = RewardAdManager();
    _rewardAd.showRewardFullBanner(() {
      String _uid = _authController.userData!['uid'];
      int value = ++_authController.userData!['point']; // 전위 증가 연산자 사용

      // 업데이트할 데이터
      Map<String, dynamic> _userNewData = {
        "point": value,
        // 필요한 경우 다른 필드도 추가할 수 있습니다.
      };
      // 사용자 데이터 업데이트
      _authController.updateUserData(_uid, _userNewData);
      // 광고를 보고 사용자가 리워드를 얻었을 때 실행할 로직
      // 예: 기부하기 또는 다른 작업 수행
    });
  }
}
