import 'package:easy_localization/easy_localization.dart';
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
              ).tr(),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Thank you for signing up for Tester Share.\n\n",
                    style: TextStyle(
                        fontSize: 20,
                        color: colors.textColor,
                        fontWeight: FontWeight.bold,
                        height: 2),
                  ).tr(),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      "-- IMPORTANT --\n",
                      style: TextStyle(
                          fontSize: 26,
                          color: colors.iconColor,
                          fontWeight: FontWeight.bold),
                    ).tr(),
                  ],
                ),
              ),
              Text(
                "We have sent a verification email to the email address you provided during registration. \nPlease check your inbox and complete the verification process to log in. \nIt is mandatory to complete the verification process for login.",
                style: TextStyle(
                  fontSize: 20,
                  color: colors.textColor,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ).tr(),
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
                        Get.offAll(const LoginScreen());
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                            color: colors.iconColor,
                            fontSize: fontsize.buttonFontSize),
                      ).tr(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
