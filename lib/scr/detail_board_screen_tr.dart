import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/developer_message_create_screen_tr.dart';

import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBoardScreen extends StatelessWidget {
  final BoardFirebaseModel
      boards; // List<BoardFirebaseModel> 대신 BoardFirebaseModel을 사용
  final ColorsCollection colors = ColorsCollection();
  final AuthController _authController = AuthController.instance;

  DetailBoardScreen({Key? key, required this.boards}) : super(key: key);

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
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                Image.network(
                  boards.iconImageUrl,
                  width: 120,
                  height: 120,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cardText(boards.title, 20),
                    cardText(
                        '[${boards.testerParticipation}/${boards.testerRequest}]',
                        16),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Creation date',
                        style: TextStyle(fontSize: 14, color: colors.textColor),
                      ).tr(),
                      Text(
                        ': ${_formattedDate(boards.createAt)}',
                        style: TextStyle(fontSize: 14, color: colors.textColor),
                      ),
                    ],
                  ),
                  if (boards.updateAt != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Modification date',
                          style:
                              TextStyle(fontSize: 14, color: colors.textColor),
                        ).tr(),
                        Text(
                          ': ${_formattedDate(boards.updateAt!)}',
                          style:
                              TextStyle(fontSize: 14, color: colors.textColor),
                        ),
                      ],
                    )
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Text(
                    "-  Developer  -",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ).tr(),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    color: colors.boxColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          cardText(boards.developer, 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // 메시지 보내기 기능 추가
                                  Get.to(DeveloperMessageCreateScreen(
                                      receiverUid: boards.createUid,
                                      developer: boards.developer,
                                      boards: boards));
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.message,
                                        color: Colors.white),
                                    SizedBox(width: 20),
                                    Text(
                                      "Send a message",
                                      style: TextStyle(
                                          color: colors.importantMessage),
                                    ).tr(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '-  Test App URL  -',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ).tr(),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    color: colors.boxColor,
                    child: TextButton(
                      onPressed: () {
                        try {
                          final inputUrl = boards.appSetupUrl;

                          // 입력된 URL이 이미 'http://' 또는 'https://'로 시작하는지 확인
                          final hasProtocol = inputUrl.startsWith('http://') ||
                              inputUrl.startsWith('https://');

                          // 프로토콜이 없는 경우 'https://'를 추가하여 안전하게 URL 생성
                          final urlWithProtocol =
                              hasProtocol ? inputUrl : 'https://$inputUrl';

                          // URL을 Uri 객체로 변환
                          final _url = Uri.parse(urlWithProtocol);

                          // 생성된 Uri를 사용하여 브라우저 열기
                          launchUrl(_url);
                        } catch (e) {
                          // URL이 유효하지 않거나 열 수 없는 경우 처리
                          print('URL 열기 오류: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.boxColor,

                        elevation:
                            8, // Add some elevation for a raised appearance
                      ),
                      child: cardText(boards.appSetupUrl, 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  '-  Supported Languages  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
                const SizedBox(height: 20),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: colors.boxColor,
                width: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: boards.language!.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                    child: Row(
                      children: [
                        Icon(
                          Icons.task_alt,
                          color: colors.iconColor,
                          size: 20,
                        ),
                        const SizedBox(width: 20),
                        cardText(
                          tr(boards.language![index]),
                          20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const Text(
                  '-  Github URL  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    color: colors.boxColor,
                    child: TextButton(
                      onPressed: () {
                        try {
                          final inputUrl = boards.githubUrl;

                          // 입력된 URL이 이미 'http://' 또는 'https://'로 시작하는지 확인
                          final hasProtocol = inputUrl.startsWith('http://') ||
                              inputUrl.startsWith('https://');

                          // 프로토콜이 없는 경우 'https://'를 추가하여 안전하게 URL 생성
                          final urlWithProtocol =
                              hasProtocol ? inputUrl : 'https://$inputUrl';

                          // URL을 Uri 객체로 변환
                          final url = Uri.parse(urlWithProtocol);

                          // 생성된 Uri를 사용하여 브라우저 열기
                          launchUrl(url);
                        } catch (e) {
                          // URL이 유효하지 않거나 열 수 없는 경우 처리
                          print('URL 열기 오류: $e');
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: colors.boxColor,
                        elevation: 8,
                      ),
                      child: cardText(boards.githubUrl, 20),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '-  App Image  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 300,
                width: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: boards.appImagesUrl.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(boards.appImagesUrl[index],
                          width: 150, height: 300, fit: BoxFit.fill),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '-  Introduction  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  color: colors.boxColor,
                  child: cardText(boards.introductionText, 16)),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: !boards.rquestProfileName
                      .contains(_authController.userData!['profileName'])
                  ? ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        String testApplyMessage =
                            "아래의 메일 주소로 테스터를 신청합니다. \nhere is the email to request to become a tester. \nこちらがテスターになるためのメールアドレスです。";
                        // 테스터 신청 이메일 메시지를 구성합니다.
                        String emailMessage =
                            "$testApplyMessage\n${_authController.userData!['email']}";
                        //테스터 신청
                        Get.to(DeveloperMessageCreateScreen(
                          receiverUid: boards.createUid,
                          developer: boards.developer,
                          message: emailMessage,
                          boards: boards,
                        ));
                      },
                      child: Text(
                        'Apply to be a Tester',
                        style: TextStyle(fontSize: 20, color: colors.iconColor),
                      ).tr(),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Already participated as a tester",
                        style: TextStyle(fontSize: 20, color: colors.iconColor),
                      ).tr(),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }

  Widget cardText(String text, double size) {
    return Text(
      text,
      style: TextStyle(color: colors.textColor, fontSize: size),
    );
  }

  // DateFormat 함수 추가
  String _formattedDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }
}
