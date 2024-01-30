import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class FindPasswordScreen extends StatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  State<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  final AuthController _authController = AuthController();
  final ColorsCollection _colors = ColorsCollection();
  final FontSizeCollection _fontSize = FontSizeCollection();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _colors.background,
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      backgroundColor: _colors.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                icon: const Icon(Icons.email),
                labelText: 'Google Play Store ID',
                hintText: 'Google Play Store ID를 입력해 주세요.',
                labelStyle: TextStyle(color: _colors.textColor),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 400),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color?>(Colors.blue),
                ),
                onPressed: () async {
                  // 비밀번호 찾기 실행
                  await _authController.forgotPassword(emailController.text);
                  // 알림 표시
                  showToast('비밀번호 재설정 메일을 전송했습니다.', 2);
                  Get.back();
                },
                child: Text(
                  '비밀번호 찾기',
                  style: TextStyle(
                    fontSize: _fontSize.buttonFontSize,
                    fontWeight: FontWeight.bold,
                    color: _colors.iconColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
