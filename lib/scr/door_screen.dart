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
        body: Column(
          children: [
            SizedBox(height: 100),
            createText(
                '신규 개발자들이 2023년 11월 13일 이후 Google Play에 앱을 등록하기 위해서는 20명 이상의 테스터가 14일 동안 참여해야 하는 정책이 시행되었습니다. '),
            createText(
                '이에 대응하여, 테스터 수를 모으기 어려운 상황에서 개발자들은 상호 보안적인 관계를 맺고 Tester Share를 통해 서로의 앱을 테스트하며 협력하고 있습니다.'),
            createText(
                '이는 Google Play의 정책을 준수하면서도 개발자들이 앱을 성공적으로 등록할 수 있는 방법을 모색하는 시도입니다.'),
            SizedBox(height: 80),
            createText('[플러터 개발자] Maccrey'),
          ],
        ));
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
