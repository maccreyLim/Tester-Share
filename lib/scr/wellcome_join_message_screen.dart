import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/scr/login_screen_tr.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class WellcomeJoinMessageScreen extends StatelessWidget {
  const WellcomeJoinMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorsCollection colors = ColorsCollection();
    final FontSizeCollection fontsize = FontSizeCollection();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colors.background,
        ),
        backgroundColor: colors.background,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'wellcome',
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Tester Share에 회원 가입을 해주셔서 \n감사합니다.\n\n',
                    style: TextStyle(
                        fontSize: 20,
                        color: colors.textColor,
                        fontWeight: FontWeight.bold,
                        height: 2),
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      '-- 중 요 --\n',
                      style: TextStyle(
                          fontSize: 26,
                          color: colors.iconColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text(
                '가입시 입력하신  E-mail주소로 인증메일을 \n보내드렸습니다.\n인증메일을 확인하시고 로그인은 \n반드시 인증절차를 완료하셔야 \n가능합니다.',
                style: TextStyle(
                  fontSize: 20,
                  color: colors.textColor,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(Colors.blue),
                      ),
                      onPressed: () {
                        //로그아웃
                        //Goto 로그인페이지
                        Get.to(() => const LoginScreen());
                      },
                      child: Text(
                        '확인',
                        style: TextStyle(
                            color: colors.iconColor,
                            fontSize: fontsize.buttonFontSize),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
