import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/scr/login_screen_tr.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class ReWellcomeMessageScreen extends StatelessWidget {
  const ReWellcomeMessageScreen({super.key});

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
            Text(
              tr('wellcome'),
              style: const TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  tr("Thank you for signing up for Tester Share.\n\n"),
                  style: TextStyle(
                      fontSize: 16,
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
                    tr("Email Resend Notification\n"),
                    style: TextStyle(
                        fontSize: 26,
                        color: colors.iconColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Text(
              tr("We have resent the email as your email verification was not completed. \nPlease check your email titled 'Verify your email for Share Tester' \nand click the link to log in."),
              style: TextStyle(
                fontSize: 20,
                color: colors.textColor,
                fontWeight: FontWeight.bold,
                height: 2,
              ),
            ),
            const SizedBox(height: 60),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color?>(Colors.blue),
                    ),
                    onPressed: () {
                      //로그아웃
                      //Goto 로그인페이지
                      Get.offAll(const LoginScreen());
                    },
                    child: Text(
                      tr("Confirm"),
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
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }
}
